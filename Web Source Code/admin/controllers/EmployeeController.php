<?php

namespace app\controllers;

use Yii;
use app\models\Employee;
use app\models\EmployeeSearch;
use app\models\LoginUser;
use app\models\WaiterUpdate;
//use app\models\Waiter;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * EmployeeController implements the CRUD actions for Employee model.
 */
class EmployeeController extends Controller
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
     * Lists all Employee models.
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
		
        $searchModel = new EmployeeSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'stores_list' => $stores_list
        ]);
    }

    /**
     * Displays a single Employee model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
        /*return $this->render('view', [
            'model' => $this->findModel($id),
        ]);*/
		
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		$model_e = $this->findModel($id);
		$store_id = $model_e->store_id;
		$login_id = $model_e->login_id;
		
		$model_l = LoginUser::findOne($login_id);
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
        return $this->render('view', [
            'model_l' => $model_l,
			'model_e' => $model_e,
        ]);
    }

    /**
     * Creates a new Employee model.
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
		
        $model_l = new LoginUser();
		$model_e = new Employee();
		
        if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_e->attributes = $_POST['Employee'];
			
			//$model_l->role = 3;	// Kitchen Cook User
			if($model_l->role == 3)
			{
				$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
			}
			else if($model_l->role == 4)
			{
				$model_l->password = md5($model_l->password);
			}
			
			$model_l->added_date = date('Y-m-d H:i:s');
			
			//$model_e->login_id = NULL;
			if($_POST['emp_role'] == 3 || $_POST['emp_role'] == 4)
			{
				$model_l->role = $_POST['emp_role'];
			}
			
			if($_POST['emp_role'] == 3) {
				$model_e->kitchen_id = $_POST['kitchen_id'];
			} else {
				$model_e->kitchen_id = NULL;
			}
			
			if($model_l->validate() && $model_e->validate())
			{
				if($model_l->save())
				{
					$login_id = $model_l->id;
					
					$model_e->login_id = $login_id;
					$model_e->save();
					
					$model_w = new WaiterUpdate();
					$model_w->waiter_login_id = $login_id;
					$model_w->store_id = $model_e->store_id;
					$model_w->save();
					
					Yii::$app->session->setFlash('employee', 'Employee has been added.');
					return $this->redirect(['view', 'id' => $model_e->id]);
				}
			}
		}
		return $this->render('create', [
        	'model_l' => $model_l,
			'model_e' => $model_e,
        ]);
    }

    /**
     * Updates an existing Employee model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		$model_e = $this->findModel($id);
		$store_id = $model_e->store_id;
		$login_id = $model_e->login_id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
		$model_l = LoginUser::findOne($login_id);
		$cur_password = $model_l->password;
		
		$old_role = $model_l->role;
		
        if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_e->attributes = $_POST['Employee'];
			
			if($model_l->re_password != "") {
				if($model_l->password != "" && $model_l->password == $model_l->re_password) {
					//$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
					//$model_l->password = md5($model_l->password);
					if($model_l->role == 3)
					{
						$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
					}
					else if($model_l->role == 4)
					{
						$model_l->password = md5($model_l->password);
					}
				} else {
					$model_l->addError('password', 'Please enter same password twice');
					$model_l->password = $cur_password;
				}
			} else {
				$model_l->password = $cur_password;
			}
			
			if($_POST['emp_role'] == 3 || $_POST['emp_role'] == 4)
			{
				$model_l->role = $_POST['emp_role'];
			}
			
			if($_POST['emp_role'] == 3) {
				$model_e->kitchen_id = $_POST['kitchen_id'];
			} else {
				$model_e->kitchen_id = NULL;
			}
			
			$err_model = $model_l->getErrors();
			if(isset($err_model['password'])) {
				$error_1 = true;
			} else {
				$error_1 = false;
			}
			
			if($error_1 == false && $model_l->validate() && $model_e->validate())
			{			
				$model_l->save();
				$model_e->save();
				
				if($model_l->role != $old_role)
				{
					if($model_l->role == 3)
					{
						$model_w = Yii::$app->db->createCommand('DELETE FROM waiter_update WHERE waiter_login_id = '.$model_l->id)->execute();
					}
					else if($model_l->role == 4)
					{
						$model_w = new WaiterUpdate();
						$model_w->waiter_login_id = $model_l->id;
						$model_w->store_id = $model_e->store_id;
						$model_w->save();
					}
				}
				
				Yii::$app->session->setFlash('employee', 'Employee details has been updated.');
				return $this->redirect(['view', 'id' => $model_e->id]);
			}
        }

		return $this->render('update', [
			'model_l' => $model_l,
			'model_e' => $model_e,
		]);
    }

    /**
     * Deletes an existing Employee model.
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
		$login_id = $model->login_id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			Yii::$app->session->setFlash('employee', 'Employee does not exist.');
			$this->redirect(['index', 's'=> key($stores_list)]);
		}		
		
		//$login_user = LoginUser::findOne($login_id);
		//$role = $login_user->role;
				
		if($model->delete())
		{
			$model_w = Yii::$app->db->createCommand('DELETE FROM waiter_update WHERE waiter_login_id = '.$login_id)->execute();
			
			$login_user = LoginUser::findOne($login_id);
			$login_user->delete();
		}
		
		Yii::$app->session->setFlash('employee', 'Employee has been deleted.');
        return $this->redirect(['index', 's'=>$store_id]);
    }

    /**
     * Finds the Employee model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Employee the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Employee::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
