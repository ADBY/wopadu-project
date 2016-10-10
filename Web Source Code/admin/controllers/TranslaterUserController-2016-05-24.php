<?php

namespace app\controllers;

use Yii;
use app\models\TranslaterUser;
use app\models\TranslaterItem;
use app\models\LoginUser;
use app\models\Stores;
use app\models\Categories;
use app\models\Items;
use app\models\ItemVariety;
use app\models\ItemOptionMain;
use app\models\ItemOptionSub;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * TranslaterUserController implements the CRUD actions for TranslaterUser model.
 */
class TranslaterUserController extends Controller
{
    public function behaviors()
    {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'delete' => ['post'],
                ],
            ],
        ];
    }

    /**
     * Lists all TranslaterUser models.
     * @return mixed
     */
    public function actionIndex()
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 6) {
			$this->redirect(['site/index']);
		}
        $dataProvider = new ActiveDataProvider([
            'query' => TranslaterUser::find(),
        ]);

        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single TranslaterUser model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 6) {
			$id = $session['t_user_id'];
		}
		
        $model_t = $this->findModel($id);
		$login_id = $model_t->login_id;
		
		$model_l = LoginUser::findOne($login_id);
		
		return $this->render('view', [
            'model_l' => $model_l,
			'model_t' => $model_t,
        ]);
    }

    /**
     * Creates a new TranslaterUser model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 6) {
			$this->redirect(['site/index']);
		}
	
		$model_l = new LoginUser();
		$model_t = new TranslaterUser();
		
        if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_t->attributes = $_POST['TranslaterUser'];
			
			$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
			
			$model_l->added_date = date('Y-m-d H:i:s');
			$model_l->role = 6;
			
			if($model_l->validate() && $model_t->validate())
			{
				if($model_l->save())
				{
					$login_id = $model_l->id;
					
					$model_t->login_id = $login_id;
					$model_t->save();
					
					Yii::$app->session->setFlash('translateruser', 'Translater has been added.');
					return $this->redirect(['view', 'id' => $model_t->id]);
				}
			}
		}
		return $this->render('create', [
        	'model_l' => $model_l,
			'model_t' => $model_t,
        ]);
    }

    /**
     * Updates an existing TranslaterUser model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 6) {
			$id = $session['t_user_id'];
		}
		
        $model_t = $this->findModel($id);
		$login_id = $model_t->login_id;
		
		$model_l = LoginUser::findOne($login_id);
		$cur_password = $model_l->password;
		
		if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_t->attributes = $_POST['TranslaterUser'];
			
			if($model_l->re_password != "") {
				if($model_l->password != "" && $model_l->password == $model_l->re_password) {
					$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
				} else {
					$model_l->addError('password', 'Please enter same password twice');
					$model_l->password = $cur_password;
				}
			} else {
				$model_l->password = $cur_password;
			}
			
			$err_model = $model_l->getErrors();
			if(isset($err_model['password'])) {
				$error_1 = true;
			} else {
				$error_1 = false;
			}
			
			if($error_1 == false && $model_l->validate() && $model_t->validate())
			{			
				$model_l->save();
				$model_t->save();
								
				Yii::$app->session->setFlash('translateruser', 'Translater details has been updated.');
				return $this->redirect(['view', 'id' => $model_t->id]);
			}
        }

		return $this->render('update', [
			'model_l' => $model_l,
			'model_t' => $model_t,
		]);
    }

    /**
     * Deletes an existing TranslaterUser model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 6) {
			$this->redirect(['site/index']);
		}
		
        $model = $this->findModel($id);
		$login_id = $model->login_id;
		
		if($model->delete())
		{
			$login_user = LoginUser::findOne($login_id);
			$login_user->delete();
		}
		
		Yii::$app->session->setFlash('translateruser', 'Translater has been deleted.');
        return $this->redirect(['index']);
    }

    /**
     * Finds the TranslaterUser model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return TranslaterUser the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = TranslaterUser::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
	
	
	/**
     * Lists all Stores requiring Translation correction.
     * @return mixed
     */
    public function actionTranslateItem($type)
    {
		$query = TranslaterItem::find();
		
		$query->andFilterWhere([
            'type' => $type,
        ]);
		if($type == 1) {
			$query->joinWith(['stores']);
		} else if($type == 2) {
			$query->joinWith(['categories']);
		} else if($type == 3) {
			$query->joinWith(['items']);
		} else if($type == 4) {
			$query->joinWith(['item_variety']);
		} else if($type == 5) {
			$query->joinWith(['item_option_main']);
		} else if($type == 6) {
			$query->joinWith(['item_option_sub']);
		}
		$dataProvider = new ActiveDataProvider([
            'query' => $query,
			'pagination' => [
				'pagesize' => 10,
			],
			'sort'=> ['defaultOrder' => ['id' => SORT_DESC]]
        ]);
		
		if($type == 1) {
			$dataProvider->sort->attributes['store_name'] = [
				// The tables are the ones our relation are configured to
				// in my case they are prefixed with "tbl_"
				'asc' => ['stores.store_name' => SORT_ASC],
				'desc' => ['stores.store_name' => SORT_DESC],
			];
		} else if($type == 2) {
			$dataProvider->sort->attributes['category_name'] = [
				'asc' => ['categories.category_name' => SORT_ASC],
				'desc' => ['categories.category_name' => SORT_DESC],
			];
		} else if($type == 3) {
			$dataProvider->sort->attributes['item_name'] = [
				'asc' => ['items.item_name' => SORT_ASC],
				'desc' => ['items.item_name' => SORT_DESC],
			];
		} else if($type == 4) {
			$dataProvider->sort->attributes['variety_name'] = [
				'asc' => ['item_variety.variety_name' => SORT_ASC],
				'desc' => ['item_variety.variety_name' => SORT_DESC],
			];
		} else if($type == 5) {
			$dataProvider->sort->attributes['option_name'] = [
				'asc' => ['item_option_main.option_name' => SORT_ASC],
				'desc' => ['item_option_main.option_name' => SORT_DESC],
			];
		} else if($type == 6) {
			$dataProvider->sort->attributes['sub_name'] = [
				'asc' => ['item_option_sub.sub_name' => SORT_ASC],
				'desc' => ['item_option_sub.sub_name' => SORT_DESC],
			];
		}

        return $this->render('list', [
            'dataProvider' => $dataProvider,
        ]);
    }
	
	/**
     * Update translate item details
     * @return mixed
     */
    public function actionTranslateItemUpdate($id)
    {
		$model_t = TranslaterItem::findOne($id);
		$type = $model_t->type;
		$item_id = $model_t->item_id;
		
		if($type == 1) {
			$model_i = Stores::findOne($item_id);
			$type_table = "stores";
		} else if($type == 2) {
			$model_i = Categories::findOne($item_id);
			$type_table = "categories";
		} else if($type == 3) {
			$model_i = Items::findOne($item_id);
			$type_table = "items";
		} else if($type == 4) {
			$model_i = ItemVariety::findOne($item_id);
			$type_table = "item_variety";
		} else if($type == 5) {
			$model_i = ItemOptionMain::findOne($item_id);
			$type_table = "item_option_main";
		} else if($type == 6) {
			$model_i = ItemOptionSub::findOne($item_id);
			$type_table = "item_option_sub";
		}
		
		if(!$model_i)
		{
			Yii::$app->db->createCommand("DELETE b FROM translater_item b LEFT JOIN $type_table f ON f.id = b.item_id WHERE f.id IS NULL AND b.type = $type")->execute();
			Yii::$app->session->setFlash('translateritem', 'Item details does not found.');
			return $this->redirect(['translate-item', 'type' => $type]);
		}
		
		if(Yii::$app->request->post())
		{
			$model_t->attributes = $_POST['TranslaterItem'];
			if($type == 1) {
				$model_i->attributes = $_POST['Stores'];
			} else if($type == 2) {
				$model_i->attributes = $_POST['Categories'];
			} else if($type == 3) {
				$model_i->attributes = $_POST['Items'];
			} else if($type == 4) {
				$model_i->attributes = $_POST['ItemVariety'];
			} else if($type == 5) {
				$model_i->attributes = $_POST['ItemOptionMain'];
			} else if($type == 6) {
				$model_i->attributes = $_POST['ItemOptionSub'];
			}
			
			if($model_t->validate() && $model_i->validate())
			{
				$model_t->action = 2;					
				$model_t->save();
				
				$model_i->save();
								
				Yii::$app->session->setFlash('translateritem', 'Translater details has been updated.');
				return $this->redirect(['translate-item', 'type' => $type]);
			}
        }
		
		if($model_t->action == 0) {
			$model_t->action = 1;
			$model_t->save();
		}

		return $this->render('update-item', [
			'model_t' => $model_t,
			'model_i' => $model_i,
		]);
    }
}
