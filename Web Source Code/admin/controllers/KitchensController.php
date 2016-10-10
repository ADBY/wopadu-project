<?php
namespace app\controllers;
use Yii;
use app\models\LoginUser;
use app\models\Kitchens;
use app\models\KitchensSearch;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
/**
 * KitchensController implements the CRUD actions for Kitchens model.
 */
class KitchensController extends Controller
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
     * Lists all Kitchens models.
     * @return mixed
     */
    public function actionIndex()
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		if(isset($_GET['s'])) {
			$s_id = $_GET['s'];
			if(empty($stores_list) && $s_id == 0) {
				$s_id = 0;
			} else if(empty($stores_list) && $s_id != 0) {
				$this->redirect(['index', 's'=> 0]);
			} else {
				if(!array_key_exists($s_id, $stores_list)) {
					reset($stores_list);
					$this->redirect(['index', 's'=> key($stores_list)]);
				}
			}
		} else {
			if(empty($stores_list)) {
				$this->redirect(['index', 's'=> 0]);
			} else {
				reset($stores_list);
				$this->redirect(['index', 's'=> key($stores_list)]);
			}
		}
		
        $searchModel = new KitchensSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'stores_list' => $stores_list
        ]);
    }
    /**
     * Displays a single Kitchens model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		$model_k = $this->findModel($id);
		$store_id = $model_k->store_id;
		//$login_id = $model_k->login_id;
		
		//$model_l = LoginUser::findOne($login_id);
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
        return $this->render('view', [
            //'model_l' => $model_l,
			'model_k' => $model_k,
        ]);
    }
    /**
     * Creates a new Kitchens model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		if(!array_key_exists($_GET['s'], $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
        //$model_l = new LoginUser();
		$model_k = new Kitchens();
        //if ($model_k->load(Yii::$app->request->post()))
		if(Yii::$app->request->post())
		{
			//$model_l->attributes = $_POST['LoginUser'];
			$model_k->attributes = $_POST['Kitchens'];
			
			/*$model_l->role = 3;	// Kitchen Cook User
			$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);*/
			$model_k->added_date = date('Y-m-d H:i:s');
			
			//$model_k->login_id = 1;
			
			//if($model_l->validate() && $model_k->validate())
			if($model_k->validate())
			{
				//if($model_l->save())
				{
					//$login_id = $model_l->id;
					
					//$model_k->login_id = $login_id;
					$model_k->save();
					
					Yii::$app->session->setFlash('kitchens', 'Area has been added.');
					return $this->redirect(['view', 'id' => $model_k->id]);
				}
			}
		}
		return $this->render('create', [
        	//'model_l' => $model_l,
			'model_k' => $model_k,
        ]);
    }
    /**
     * Updates an existing Kitchens model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		$model_k = $this->findModel($id);
		$store_id = $model_k->store_id;
		//$login_id = $model_k->login_id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
		//$model_l = LoginUser::findOne($login_id);
		//$cur_password = $model_l->password;
		
        if(Yii::$app->request->post())
		{
			//$model_l->attributes = $_POST['LoginUser'];
			$model_k->attributes = $_POST['Kitchens'];
			
			/*if($model_l->re_password != "") {
				if($model_l->password != "" && $model_l->password == $model_l->re_password) {
					$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
				} else {
					$model_l->addError('password', 'Please enter same password twice');
					$model_l->password = $cur_password;
				}
			} else {
				$model_l->password = $cur_password;
			}*/
			
			/*$err_model = $model_l->getErrors();
			if(isset($err_model['password'])) {
				$error_1 = true;
			} else {
				$error_1 = false;
			}*/
			//if($error_1 == false && $model_l->validate() && $model_k->validate())
			if($model_k->validate())
			{			
				//$model_l->save();
				$model_k->save();
			
				Yii::$app->session->setFlash('kitchens', 'Area details has been updated.');
				return $this->redirect(['view', 'id' => $model_k->id]);
			}
        }
				
		return $this->render('update', [
			//'model_l' => $model_l,
			'model_k' => $model_k,
		]);
    }
    /**
     * Deletes an existing Kitchens model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
		$session = Yii::$app->session;		
		$stores_list = $session['stores_list'];		
		
		$model = $this->findModel($id);
		$store_id = $model->store_id;
		//$login_id = $model->login_id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			Yii::$app->session->setFlash('kitchens', 'Area does not exist.');
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
		$item_exist_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE kitchen_id = $id")->queryOne();
		if($item_exist_check)
		{
			Yii::$app->session->setFlash('kitchens', 'Some products associated with this area, Please delete these products first.');
			$this->redirect(['view', 'id'=> $id]);
		}
		
		$employee_exist_check = Yii::$app->db->createCommand("SELECT id FROM employee WHERE kitchen_id = $id")->queryOne();
		if($employee_exist_check)
		{
			Yii::$app->session->setFlash('kitchens', 'Please delete employees first to delete area.');
			$this->redirect(['view', 'id'=> $id]);
		}
				
		$order_exist_check = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE kitchen_id = $id")->queryOne();
		if($order_exist_check)
		{
			Yii::$app->session->setFlash('kitchens', 'Some order associated with this area, Thus can not delete area.');
			$this->redirect(['view', 'id'=> $id]);
		}
		
		$model->delete();
		
        /*if($model->delete())
		{
			$login_user = LoginUser::findOne($login_id);
			$login_user->delete();
		}*/
		Yii::$app->session->setFlash('kitchens', 'Area has been deleted.');
        return $this->redirect(['index', 's'=>$store_id]);
    }
    /**
     * Finds the Kitchens model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Kitchens the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Kitchens::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
