<?php

namespace app\controllers;

use Yii;
use app\models\AdminSub;
use app\models\LoginUser;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * AdminSubController implements the CRUD actions for AdminSub model.
 */
class AdminSubController extends Controller
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
     * Lists all AdminSub models.
     * @return mixed
     */
	
	public function actionIndex()
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 11) {
			$this->redirect(['site/index']);
		}
        $dataProvider = new ActiveDataProvider([
            'query' => AdminSub::find(),
        ]);

        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single AdminSub model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		
		$session = Yii::$app->session;
		
		if($session['login_role'] == 11) {
			$id = $session['a_user_id'];
		}
		
        $model_a = $this->findModel($id);
		$login_id = $model_a->login_id;
		
		$model_l = LoginUser::findOne($login_id);
		//echo $id; exit;
		return $this->render('view', [
            'model_l' => $model_l,
			'model_a' => $model_a,
        ]);
    }

    /**
     * Creates a new AdminSub model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 11) {
			$this->redirect(['site/index']);
		}

		$model_l = new LoginUser();
		$model_a = new AdminSub();
		
        if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_a->attributes = $_POST['AdminSub'];

			$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
			
			$model_l->added_date = date('Y-m-d H:i:s');
			$model_l->role = 11;
			
			if($model_l->validate() && $model_a->validate())
			{
				if($model_l->save())
				{
					$login_id = $model_l->id;
					
					$model_a->login_id = $login_id;
					$model_a->save();
					
					Yii::$app->session->setFlash('adminsub', 'Admin has been added.');
					return $this->redirect(['view', 'id' => $model_a->id]);
				}
			}
		}
		return $this->render('create', [
        	'model_l' => $model_l,
			'model_a' => $model_a,
        ]);
    }

    /**
     * Updates an existing AdminSub model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 11) {
			$id = $session['a_user_id'];
		}
		
        $model_a = $this->findModel($id);
		$login_id = $model_a->login_id;
		
		$model_l = LoginUser::findOne($login_id);
		$cur_password = $model_l->password;
		
		if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_a->attributes = $_POST['AdminSub'];
			
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
			
			if($error_1 == false && $model_l->validate() && $model_a->validate())
			{			
				$model_l->save();
				$model_a->save();
								
				Yii::$app->session->setFlash('adminsub', 'Admin details has been updated.');
				return $this->redirect(['view', 'id' => $model_a->id]);
			}
        }

		return $this->render('update', [
			'model_l' => $model_l,
			'model_a' => $model_a,
		]);
    }

    /**
     * Deletes an existing AdminSub model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $session = Yii::$app->session;
		
		if($session['login_role'] == 11) {
			$this->redirect(['site/index']);
		}
		
        $model = $this->findModel($id);
		$login_id = $model->login_id;
		
		if($model->delete())
		{
			$login_user = LoginUser::findOne($login_id);
			$login_user->delete();
		}
		
		Yii::$app->session->setFlash('adminsub', 'Admin has been deleted.');
        return $this->redirect(['index']);
    }

    /**
     * Finds the AdminSub model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return AdminSub the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = AdminSub::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
