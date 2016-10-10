<?php
namespace app\controllers;
use Yii;
use app\models\Accounts;
use app\models\AccountsSearch;
use app\models\LoginUser;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
/**
 * AccountsController implements the CRUD actions for Accounts model.
 */
class AccountsController extends Controller
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
     * Lists all Accounts models.
     * @return mixed
     */
    public function actionIndex()
    {
		$session = Yii::$app->session;
		
		if($session['super_admin'] == "NO") {
			$this->redirect(\Yii::$app->urlManager->createUrl('accounts/profile'));
		} else {
			$record = LoginUser::find()->where(['id' => '1'])->one();			
			$session->set('login_id', Yii::$app->user->id);
			$session->set('login_role', Yii::$app->user->identity->role);
			$session->set('login_email', Yii::$app->user->identity->email);
			//$session->set('super_admin', 'YES');
		}	
		
		$searchModel = new AccountsSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
		
        /*$dataProvider = new ActiveDataProvider([
            'query' => Accounts::find(),
        ]);
        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);*/
    }
    /**
     * Displays a single Accounts model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		$session = Yii::$app->session;
		
		if($session['login_role'] == 2) {
			$this->redirect(\Yii::$app->urlManager->createUrl('accounts/profile'));
		}
		
		$model_a = $this->findModel($id);
		$model_l = LoginUser::findOne($model_a->login_id);
		
		return $this->render('view', [
            'model_l' => $model_l,
			'model_a' => $model_a,
        ]);
    }
    /**
     * Displays a Current login users Accounts model.
     * @param string $id
     * @return mixed
     */
    public function actionProfile()
    {
		$session = Yii::$app->session;
		$id = $session['account_id'];
		/*$account_details = Yii::$app->db->createCommand("SELECT * FROM accounts where id = $id")->queryOne();
		$login_id = $account_details['login_id'];
		$login_details = Yii::$app->db->createCommand("SELECT * FROM login_user where id = $login_id")->queryOne();
		$model = array_merge($account_details, $login_details);*/
		
		$model_a = $this->findModel($id);
		$model_l = LoginUser::findOne($model_a->login_id);
		
		return $this->render('view', [
            'model_l' => $model_l,
			'model_a' => $model_a,
        ]);
    }
    /**
     * Creates a new Accounts model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		
		if ($session['role'] == 2) {
			$this->redirect(\Yii::$app->urlManager->createUrl('accounts/profile'));
		}
		
        $model_l = new LoginUser();
		$model_a = new Accounts();
        //if ($model_a->load(Yii::$app->request->post()))
		if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_a->attributes = $_POST['Accounts'];
			
			/*echo "<pre>";
			print_r($model_l);
			print_r($model_a);
			echo "</pre>";
			exit;*/
			
			$model_l->role = 2;	// Account Login User
			$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
			if($model_a->account_type == 1)
			{
				$model_a->allowed_stores = 1;
			}
			$model_l->added_date = date('Y-m-d H:i:s');
			
			$model_a->login_id = 1;
			if($model_l->validate() && $model_a->validate())
			{
				if($model_l->save())
				{
					$login_id = $model_l->id;
					
					$model_a->login_id = $login_id;
					$model_a->save();
					
					Yii::$app->session->setFlash('accounts', 'Account has been created');
					return $this->redirect(['view', 'id' => $model_a->id]);
					exit;
				}
			}
        }
		return $this->render('create', [
			'model_l' => $model_l,
			'model_a' => $model_a,
		]);
    }
    /**
     * Updates an existing Accounts model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		
		if ($session['login_role'] == 2) {
			$id = $session['account_id'];
		}
		
        $model_a = $this->findModel($id);
		
		$model_l = LoginUser::findOne($model_a->login_id);
		
		$cur_password = $model_l->password;
        if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_a->attributes = $_POST['Accounts'];
			
			if($model_l->re_password != "")
			{
				if($model_l->password != "" && $model_l->password == $model_l->re_password)
				{
					$model_l->password = Yii::$app->security->generatePasswordHash($model_l->password);
				}
				else
				{
					$model_l->addError('password', 'Please enter same password twice');
				}
				
			}
			else
			{
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
				
				Yii::$app->session->setFlash('accounts', 'Account details has been updated');
				return $this->redirect(['view', 'id' => $model_a->id]);
			}
        }
		
		return $this->render('update', [
			'model_l' => $model_l,
			'model_a' => $model_a,
		]);
    }
    /**
     * Deletes an existing Accounts model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
		$session = Yii::$app->session;
		$model = $this->findModel($id);
		$login_id = $model->login_id;
		
		if ($session['super_admin'] != "YES") {
			$this->redirect(\Yii::$app->urlManager->createUrl('site/index'));
		}
		
		$store_check = Yii::$app->db->createCommand("SELECT id FROM stores WHERE account_id = $id")->queryOne();
		if($store_check) {
			Yii::$app->session->setFlash('accounts', 'Please delete stores first to delete account');
			if($session['login_role'] == 1) {
				return $this->redirect(['view', 'id' => $id]);
			} else {
				return $this->redirect(['profile']);
			}
		}		
        
		$model->delete();
		$login_user = LoginUser::findOne($login_id);
		$login_user->delete();
		
		Yii::$app->session->setFlash('accounts', 'Account has been deleted successfully');
        return $this->redirect(['index']);
    }
    /**
     * Finds the Accounts model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Accounts the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Accounts::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }	
}
