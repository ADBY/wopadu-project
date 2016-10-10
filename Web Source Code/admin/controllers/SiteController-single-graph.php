<?php
namespace app\controllers;
use Yii;
use yii\filters\AccessControl;
use yii\web\Controller;
use yii\filters\VerbFilter;
use app\models\LoginForm;
use app\models\ContactForm;
use app\models\Admin;
use app\models\Accounts;
//use app\models\Kitchens;
use app\models\Employee;
use app\models\LoginUser;
class SiteController extends Controller
{
	/*public function init()
	{
		echo "shirishh";
		exit;
	}*/
	
	public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'only' => ['logout'],
                'rules' => [
                    [
                        'actions' => ['logout'],
                        'allow' => true,
                        'roles' => ['@'],
                    ],
                ],
            ],
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'logout' => ['get'],
                ],
            ],
        ];
    }
    public function actions()
    {
        return [
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null,
            ],
        ];
    }
    public function actionIndex()
    {
		$session = Yii::$app->session;
		
		if(Yii::$app->user->isGuest)
		{
			//$this->redirect(['site/login']);
		}
		
		if($session['super_admin'] == 'YES' && !$session['security-que-check'])
		{
			return $this->redirect('logout');
		}
		
		if(isset($_REQUEST['acc_id']) && $_REQUEST['acc_id'] != "")
		{
			/*$record=Condo::model()->findByPk($_REQUEST['condo_id']);
			 Yii::app()->user->setState('condo_id',$record->condo_id);				 
			 Yii::app()->user->setState('condo_name',$record->condo_name);
			 Yii::app()->user->setState('role',$record->role);
			 */
			$record = Accounts::find()->where(['id' => $_REQUEST['acc_id']])->one();
			
			$login_id = $record->login_id;
			
			$login_details = Yii::$app->db->createCommand("SELECT email, role FROM login_user where id = $login_id")->queryOne();
			$session = Yii::$app->session;
			$session->set('login_id', $record->id);
			$session->set('login_role', $login_details['role']);
			$session->set('login_email', $login_details['email']);
			$session->set('account_id', $record->id);
			$session->set('account_name', $record->account_name);
			$session->set('allowed_stores', $record->allowed_stores);
			
			$stores = [];
			$stores_array = Yii::$app->db->createCommand('SELECT id, store_name FROM stores where account_id = '.$record->id)->queryAll();
			foreach($stores_array as $item)
			{
				//$stores[] = ['id' => $item['id'], 'store_name' => $item['store_name']];
				$stores[$item['id']] = $item['store_name'];
			}
			$session->set('stores_list', $stores);
		 }
        return $this->render('index');
    }
    public function actionLogin()
    {
		//echo "shirishM";
		//exit;
		$this->layout = 'loginlayout';
        if (!\Yii::$app->user->isGuest) {
            return $this->goHome();
        }
        $model = new LoginForm();
		
        if ($model->load(Yii::$app->request->post()) && $model->login()) {	
			
			$session = Yii::$app->session;
			$login_id = Yii::$app->user->id;
			
			$ip_address = Yii::$app->request->getUserIP();
			$datetime = date('Y-m-d H:i:s');
			
			$session->set('last_login_date', Yii::$app->user->identity->last_login_date);
			$session->set('last_login_ip', Yii::$app->user->identity->last_login_ip);
			
			$up_dt_ip = LoginUser::findOne($login_id);
			$up_dt_ip->last_login_date = $datetime;
			$up_dt_ip->last_login_ip = $ip_address;
			$up_dt_ip->save();
			if(Yii::$app->user->identity->role == 1)
			{
				$session->set('super_admin', "YES");
				
				$check_device = Yii::$app->db->createCommand("SELECT id FROM admin_login_devices WHERE ip_address = '$ip_address'")->queryOne();
				if(!$check_device) {
					return $this->redirect('security-question');
				} else {
					$session->set('security-que-check', TRUE);
					$session->set('login_id', Yii::$app->user->id);
					$session->set('login_email', Yii::$app->user->identity->email);
					$session->set('login_role', Yii::$app->user->identity->role);
				}
			}
			else if(Yii::$app->user->identity->role == 2)
			{
				$session->set('login_id', Yii::$app->user->id);
				$session->set('login_email', Yii::$app->user->identity->email);
				$session->set('login_role', Yii::$app->user->identity->role);
				
				$record = Accounts::find()->where(['login_id' => $login_id])->one();
				
				$session->set('super_admin', "NO");
				$session->set('account_id', $record->id);
				$session->set('account_name', $record->account_name);
				$session->set('allowed_stores', $record->allowed_stores);
				
				$stores = [];
				$stores_array = Yii::$app->db->createCommand('SELECT id, store_name FROM stores where account_id = '.$record->id)->queryAll();
				foreach($stores_array as $item)
				{
					//$stores[] = ['id' => $item['id'], 'store_name' => $item['store_name']];
					$stores[$item['id']] = $item['store_name'];
				}
				$session->set('stores_list', $stores);
			}
			else  if(Yii::$app->user->identity->role == 3)
			{
				$session->set('login_id', Yii::$app->user->id);
				$session->set('login_email', Yii::$app->user->identity->email);
				$session->set('login_role', Yii::$app->user->identity->role);
				
				$record = Employee::find()->where(['login_id' => $login_id])->one();
				
				$session->set('super_admin', "NO");
				$session->set('emp_id', $record->id);
				$session->set('kitchen_id', $record->kitchen_id);
				$session->set('emp_name', $record->emp_name);
			}
			else
			{
				return $this->redirect('logout');
				/*$session->set('login_id', Yii::$app->user->id);
				$session->set('login_email', Yii::$app->user->identity->email);
				$session->set('login_role', Yii::$app->user->identity->role);
				$session->set('super_admin', "NO");*/
			}
			
            return $this->goBack();
        }
        return $this->render('login', [
            'model' => $model,
        ]);
    }
    public function actionLogout()
    {
        Yii::$app->user->logout();
        return $this->goHome();
    }
    public function actionContact()
    {
        $model = new ContactForm();
        if ($model->load(Yii::$app->request->post()) && $model->contact(Yii::$app->params['adminEmail'])) {
            Yii::$app->session->setFlash('contactFormSubmitted');
            return $this->refresh();
        }
        return $this->render('contact', [
            'model' => $model,
        ]);
    }
    public function actionAbout()
    {
        return $this->render('about');
    }
	
	public function actionForgotPassword(){
		//$site_url = "http://localhost:8080/wopadu/";
		$site_url = "http://ec2-54-206-17-113.ap-southeast-2.compute.amazonaws.com/";
		
		$email = $_POST['email'];
		$check_user = Yii::$app->db->createCommand("SELECT id FROM login_user WHERE email='$email'")->queryOne();
		if($check_user)
		{
			$user_id = $check_user['id'];
			
			$password_reset_token = time().mt_rand(1000, 9999).mt_rand(1000, 9999); 
			$verif_code_exp = date("Y-m-d H:i:s", strtotime("+2 hours"));
			
			$change_password_url = $site_url."site/change-password?email=".$email."&token=".$password_reset_token;
			
			$update_user = Yii::$app->db->createCommand("UPDATE login_user SET password_reset_token = '$password_reset_token', verif_code_exp = '$verif_code_exp' WHERE id ='$user_id'")->execute();
			$row_email = Yii::$app->db->createCommand("SELECT value from site_info WHERE id = 1 and name = 'contact_email'")->queryOne();			
			$admin_email = $row_email['value'];
			$to 		= $email;
			$subject 	= "Wopadu - Forgot Password";
			$message 	= '
				<!doctype html>
				<head>
				<meta charset="utf-8">
				<title>Forgot Password | Wopadu</title>
				</head>
				
				<body>
				<table dir="ltr">
				<tbody>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#551570">Wopadu account</td>
					</tr>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#CE1764">Forgot Password</td>
					</tr>
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Please use this link to change your password at Wopadu account <a dir="ltr" style="color:#2672ec;text-decoration:none" href="'.$change_password_url.'" target="_blank">'.$change_password_url.'</a>.</td>
					</tr>
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Thanks,</td>
					</tr>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">The Wopadu team</td>
					</tr>
				</tbody>
				</table>
				</body>
				</html>';
							
			$header 	= "From:".$admin_email." \r\n";
			$header 	.= "MIME-Version: 1.0\r\n";
			$header 	.= "Content-type: text/html\r\n";
			
			$sentmail = mail ($to, $subject, $message, $header);
			echo 1;	//	Email has been sent with verification code.
			exit;
		}
		else
		{
			echo 0;
			exit;
		}	
	}
	
	public function actionChangePassword()
	{
		$this->layout = 'loginlayout';
		$error = [];
		
		//$model = new LoginForm();
		if(!isset($_GET['email']) || !isset($_GET['token'])) 
		{
			$this->redirect('login');
		}
		else
		{
			$email = $_GET['email'];
			
			$check_token = Yii::$app->db->createCommand("SELECT id, email, password_reset_token, verif_code_exp FROM login_user WHERE email = '$email'")->queryOne();
			
			if($check_token)
			{
				$token					= $_GET['token'];
				
				$user_id 				= $check_token['id'];			
				$email					= $check_token['email'];
				$password_reset_token 	= $check_token['password_reset_token'];
				$verif_code_exp 		= $check_token['verif_code_exp'];
				
				$cur_time = date("Y-m-d H:i:s");
				
				if($token != $password_reset_token)
				{
					$this->redirect('login');
				}
				else if($cur_time > $verif_code_exp)
				{
					$error['error_1'] = "Verification token has been expired.";
				}
				else
				{
					$model = LoginUser::findOne($user_id);
				}
			}
			else
			{
				$this->redirect('login');
			}
		}		
		
		if(isset($_POST['password']) && isset($_POST['re_password']))
		{
			$password = $_POST['password']; 
			$re_password = $_POST['re_password'];
			
			if($password == "" || $re_password == "") {
				$error['error_2'] = "Please enter password.";
			} else if($password != $re_password) {
				$error['error_2'] = "Password does not match.";
			} else {
				
				$model->password = Yii::$app->security->generatePasswordHash($password);
				$model->password_reset_token = NULL;
				$model->verif_code_exp = NULL;
				
				if($model->save())
				{
					$error['error_3'] = "Password has been changed successfully. Please login to continue.";
				}
				else
				{
					$error['error_2'] = "Something went wrong. Please try again.";
				}
				
			}
		}
		return $this->render('change-password', [
            'error' => $error,
        ]);
	}
	
	public function actionSecurityQuestion()
	{
		$this->layout = 'loginlayout';
		$error = [];
		
		$session = Yii::$app->session;
		
		$fetch_qa = Yii::$app->db->createCommand("SELECT security_question, security_answer FROM admin")->queryOne();
		
		$security_question = $fetch_qa['security_question'];
		$security_answer = $fetch_qa['security_answer'];
		
		if(!$session['security-que-check']) {
			
		} else {
			$this->redirect('index');
		}
		
		if(isset($_POST['answer']))
		{
			$answer = $_POST['answer'];
			
			if($answer == "") {
				$error['error_1'] = "Please enter answer for the above question.";
			} else if(strtolower($security_answer) != strtolower($answer)) {
				$error['error_1'] = "Answer does not match, Please enter correct answer.";
			} else {
				
				$ip_address = Yii::$app->request->getUserIP();
				$datetime = date("Y-m-d H:i:s");
				
				$insert_device = Yii::$app->db->createCommand("INSERT INTO `admin_login_devices`(`ip_address`, `used_datetime`, `status`) VALUES ('$ip_address', '$datetime', 1)")->execute();
				
				if($insert_device) {
					$session->set('security-que-check', TRUE);
					
					$admin = LoginUser::findOne(1);
					$session->set('login_id', $admin->id);
					$session->set('login_email', $admin->email);
					$session->set('login_role', $admin->role);
					
					return $this->redirect('index');
				} else {
					$error['error_1'] = "Something went wrong. Please try again.";
				}
				
			}
		}
		return $this->render('security-question', [
            'error' => $error,
			'security_question' => $security_question,
        ]);
	}
}