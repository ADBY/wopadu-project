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
use app\models\TranslaterUser;
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
				
				$store_id = $record->store_id;
				
				$check_account_status = Yii::$app->db->createCommand("SELECT login_user.status FROM accounts, stores, login_user WHERE stores.id = $store_id AND accounts.id = stores.account_id AND accounts.login_id = login_user.id")->queryOne();
				
				if($check_account_status['status'] == 0)
				{
					Yii::$app->user->logout();
					return $this->inactive(['a' => 'error']);
				}
				
				$session->set('super_admin', "NO");
				$session->set('emp_id', $record->id);
				$session->set('kitchen_id', $record->kitchen_id);
				$session->set('emp_name', $record->emp_name);
			}
			else  if(Yii::$app->user->identity->role == 6)	// Translater Login
			{
				$session->set('login_id', Yii::$app->user->id);
				$session->set('login_email', Yii::$app->user->identity->email);
				$session->set('login_role', Yii::$app->user->identity->role);
				
				$record = TranslaterUser::find()->where(['login_id' => $login_id])->one();
				
				$session->set('super_admin', "NO");
				$session->set('t_user_id', $record->id);
				$session->set('first_name', $record->first_name);
				$session->set('last_name', $record->last_name);
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
	
    public function inactive($model)
    {
        return $this->render('inactive', [
            'model' => $model,
        ]);
    }
	
	public function actionStripeInfo()
    {
		//echo 3;
		//exit;
		$this->layout = 'loginlayout';
        	return $this->render('stripe-info', [
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
	public function actionForgotPassword()
	{
		//$site_url = "http://localhost:8080/wopadu/";
		//$site_url = "http://ec2-54-206-17-113.ap-southeast-2.compute.amazonaws.com/";
		$site_url = "http://www.wopadu.com/";
		
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
	public function actionGetCatList()
	{
		$crt_id 	= $_REQUEST['a'];
		$store_id 	= $_REQUEST['b'];

		$result = Yii::$app->db->createCommand("SELECT id, parent_id, category_name, store_id  from categories WHERE store_id = '$store_id'")->queryAll();

		$rows = array();
		foreach($result as $row)
		{
			$sub_cat_exists_res = Yii::$app->db->createCommand("SELECT id FROM categories WHERE parent_id = ".$row['id'])->queryOne();
			if($sub_cat_exists_res)
			{
				$row['sub_cat_exists_res'] = "YES";
			}
			else
			{
				$row['sub_cat_exists_res'] = "NO";
			}
			$rows[] = $row;
		}
		$categories = $rows;	
		
		/*echo "<pre>";
		print_r($categories);
		echo "</pre>";
		exit;*/
		
		$items = $rows;
		$id = '';
		$categories = array();
		
		function sub($items, $id)
		{
			$output = array();
			foreach($items as $item)
			{
				if($item['parent_id'] == $id)
				{
					$item['sub_menu'] = sub($items, $item['id']);
					$output[] = $item;
				}
			}
			return $output;
		}
		
		foreach($items as $item)
		{	
			if($item['parent_id'] == 0)
			{
				$id = $item['id'];
				$item['sub_menu'] = sub($items, $id);
				$categories[] = $item;
			}
		}
		/*echo "<pre>";
		print_r($categories);
		echo "</pre>";*/
		//exit;
		
		echo '<label class="sr-only" for="">Select Category</label>';
		
		if($crt_id == 2)
		{
			echo '<select class="form-control" name="criteria_6_'.$store_id.'" id="criteria_6_'.$store_id.'">';
		}
		else
		{
			echo '<select class="form-control" name="criteria_6_'.$store_id.'" id="criteria_6_'.$store_id.'" onChange="sel_crt_6(this.value, '.$store_id.')">';
			echo '<option value="">Select Category</option>';
		}
		
		foreach($categories as $cat)
		{
			if($cat['sub_cat_exists_res'] == 'NO') {
				echo '<option value="'.$cat['id'].'">'.$cat['category_name'].'</option>';
			} else {
				echo '<optgroup label="'.$cat['category_name'].'">';
				foreach($cat['sub_menu'] as $sub)
				{
					echo '<option value="'.$sub['id'].'">'.$sub['category_name'].'</option>';
				}
				echo '</optgroup>';
			}
		}
		echo '</select>';
	}
	public function actionGetItemList()
	{
		$cat_id 	= $_REQUEST['a'];
		$store_id 	= $_REQUEST['b'];

		$result = Yii::$app->db->createCommand("SELECT id, item_name from items WHERE category_id = '$cat_id'")->queryAll();

		echo '<label class="sr-only" for="">Select Product</label>';
		
		echo '<select class="form-control" name="criteria_7_'.$store_id.'" id="criteria_7_'.$store_id.'">';
				
		foreach($result as $itm)
		{
			echo '<option value="'.$itm['id'].'">'.$itm['item_name'].'</option>';
		}
		echo '</select>';
	}
	public function actionGenGraph()
	{
		$key	 	= $_REQUEST['b']; // Store id
		$crt_1 		= $_REQUEST['crt_1'];
		$crt_2 		= $_REQUEST['crt_2'];
		$crt_3 		= $_REQUEST['crt_3'];
		$crt_4 		= $_REQUEST['crt_4'];
		$crt_5 		= $_REQUEST['crt_5'];
		$crt_6 		= $_REQUEST['crt_6'];
		$crt_7 		= $_REQUEST['crt_7'];
		
		/*echo "<pre>";
		print_r($_REQUEST);
		echo "</pre>";*/
		//exit;*/
		
		if($crt_1 == 1)
		{
			if($crt_5 == 1)
			{
				$countAccount = Yii::$app->db->createCommand("SELECT DATE_FORMAT(`n_datetime`, '%Y-%m')as month,SUM(`total_amount`) AS total_sale FROM `orders` WHERE store_id = $key and `status` = 4 GROUP BY DATE_FORMAT(`n_datetime`, '%Y-%m') ")->queryAll();
			}
			else if($crt_5 == 2)
			{
				if($crt_6 == "")
				{
					echo "0-Please select category first";
					exit;
				}
				
				$fetch_items = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $crt_6")->queryAll();
				
				if(!$fetch_items)
				{
					echo "0-No orders found";
					exit;
				}
				else
				{
					$item_str = "";
					foreach($fetch_items as $ft)
					{
						$item_str .= $ft['id'].",";
					}
					$item_str = rtrim($item_str, ",");
					
					if($item_str == "")
					{
						echo "0-No orders found";
						exit;
					}
					else
					{
						$countAccount = Yii::$app->db->createCommand("SELECT DATE_FORMAT(O.n_datetime, '%Y-%m')as month,SUM(OD.final_amount) AS total_sale FROM order_details as OD INNER JOIN `orders` as O ON OD.order_id = O.id and O.store_id = $key WHERE OD.item_id in ($item_str) and OD.status = 4 GROUP BY DATE_FORMAT(O.n_datetime, '%Y-%m') ")->queryAll();
					}
				}
			}
			else if($crt_5 == 3)
			{
				if($crt_6 == "")
				{
					echo "0-Please select category first";
					exit;
				}
				if($crt_7 == "")
				{
					echo "0-Please select product first";
					exit;
				}
				
				$countAccount = Yii::$app->db->createCommand("SELECT DATE_FORMAT(O.n_datetime, '%Y-%m')as month,SUM(OD.final_amount) AS total_sale FROM order_details as OD INNER JOIN `orders` as O ON OD.order_id = O.id and O.store_id = $key WHERE OD.item_id = $crt_7 and OD.status = 4 GROUP BY DATE_FORMAT(O.n_datetime, '%Y-%m') ")->queryAll();
			}
			
			/*echo "<pre>";
			print_r($countAccount);
			echo "</pre>";
			exit;*/
			
			if($countAccount)
			{
				$month_array = [];
				foreach($countAccount as $month)
				{
					$month_array[] = $month['month'];
				}
				
				asort($month_array);
				
				$count_month = count($month_array);
				
				$array = [];
				foreach($countAccount as $month)
				{
					$array[$month['month']] = $month['total_sale'];
				}
				
				if(!empty($month_array))
				{
					$start_key = $month_array[0];
					
					$ex_start_key = explode("-", $start_key);
					$start_month = $ex_start_key[1];
					$start_year = $ex_start_key[0];
						
					$end_key = $month_array[$count_month-1];
					
					$ex_end_key = explode("-", $end_key);
					$end_month = $ex_end_key[1];
					$end_year = $ex_end_key[0];		
					
					$date1  = $start_year.'-'.$start_month.'-15';
					$date2  = $end_year.'-'.$end_month.'-15';
					$bar_month_array = [];
					$time   = strtotime($date1);
					$last   = date('Y-m', strtotime($date2));
					
					do {
						$month = date('Y-m', $time);
						$total = date('t', $time);
						$bar_month_array[] = $month;
					
						$time = strtotime('+1 month', $time);
					} while ($month != $last);
					
					$bar_total_array = [];
					foreach($bar_month_array as $i)
					{
						if(isset($array[$i])) {
							$bar_total_array[] = $array[$i];
						} else {
							$bar_total_array[] = 0;
						}
					}
					
					$data = "";
					$kk = 0;
					foreach($bar_month_array as $mm)
					{
						$data .= '{y: '.$bar_total_array[$kk] .', label: "'.$mm.'"},';
						$kk++;
					}
					echo "[".$data."]";
				}
				else
				{
					echo "0-No orders found";
				}
			}
			else
			{
				echo "0-No orders found";
			}
		}
		else if($crt_1 == 2)
		{
			if($crt_2 == "")
			{
				echo "0-Please select month";
				exit;
			}
			
			$exp_crt_2 = explode("-", $crt_2);
			$month_crt = $exp_crt_2[1];
			$year_crt = $exp_crt_2[0];
			
			if($crt_5 == 1)
			{
				$query = "SELECT DATE_FORMAT(`n_datetime`, '%Y-%m-%d')as day,SUM(`total_amount`) AS total_sale FROM `orders` WHERE store_id = $key and YEAR(n_datetime) = '$year_crt' and MONTH(n_datetime) = '$month_crt' and `status` = 4 GROUP BY DATE_FORMAT(`n_datetime`, '%Y-%m-%d')";
				
				$countAccount = Yii::$app->db->createCommand($query)->queryAll();
			}
			else if($crt_5 == 2)
			{
				if($crt_6 == "")
				{
					echo "0-Please select category first";
					exit;
				}
				
				$fetch_items = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $crt_6")->queryAll();
				
				if(!$fetch_items)
				{
					echo "0-No orders found";
					exit;
				}
				else
				{
					$item_str = "";
					foreach($fetch_items as $ft)
					{
						$item_str .= $ft['id'].",";
					}
					$item_str = rtrim($item_str, ",");
					
					if($item_str == "")
					{
						echo "0-No orders found";
						exit;
					}
					else
					{						
						$query = "SELECT DATE_FORMAT(O.n_datetime, '%Y-%m-%d')as day,SUM(OD.final_amount) AS total_sale FROM order_details as OD INNER JOIN `orders` as O ON OD.order_id = O.id and O.store_id = $key and YEAR(O.n_datetime) = '$year_crt' and MONTH(O.n_datetime) = '$month_crt' WHERE OD.item_id in ($item_str) and OD.status = 4 GROUP BY DATE_FORMAT(O.n_datetime, '%Y-%m-%d')";
						$countAccount = Yii::$app->db->createCommand($query)->queryAll();
					}
				}
			}
			else if($crt_5 == 3)
			{
				
				if($crt_6 == "")
				{
					echo "0-Please select category first";
					exit;
				}
				if($crt_7 == "")
				{
					echo "0-Please select product first";
					exit;
				}
				
				$query = "SELECT DATE_FORMAT(O.n_datetime, '%Y-%m-%d')as day,SUM(OD.final_amount) AS total_sale FROM order_details as OD INNER JOIN `orders` as O ON OD.order_id = O.id and O.store_id = $key and YEAR(O.n_datetime) = '$year_crt' and MONTH(O.n_datetime) = '$month_crt' WHERE OD.item_id = $crt_7 and OD.status = 4 GROUP BY DATE_FORMAT(O.n_datetime, '%Y-%m-%d')";
				
				$countAccount = Yii::$app->db->createCommand($query)->queryAll();
				
			}
			
			/*echo "<pre>";
			print_r($countAccount);
			echo "</pre>";
			exit;*/
			if($countAccount)
			{
				$month_array = [];
				foreach($countAccount as $month)
				{
					$month_array[] = $month['day'];
				}
				
				asort($month_array);
				
				$count_month = count($month_array);
				
				$array = [];
				foreach($countAccount as $month)
				{
					$array[$month['day']] = $month['total_sale'];
				}
				
				/*echo "<pre>";
				//print_r($month_array);
				print_r($array);
				echo "</pre>";
				//exit;*/
				
				if(!empty($month_array))
				{
					$start_key = $month_array[0];
					
					$ex_start_key = explode("-", $start_key);
					$start_month = $ex_start_key[1];
					$start_year = $ex_start_key[0];
					
					$total_days = cal_days_in_month(CAL_GREGORIAN, $start_month, $start_year);
									
					for($id = 1; $id <= $total_days; $id++)
					{
						$bar_month_array[] = sprintf("%02d", $id);;
					}
					
					/*echo "<pre>";
					print_r($bar_month_array);
					echo "</pre>";*/
					//exit;
					
					$bar_total_array = [];
					foreach($bar_month_array as $i)
					{
						if(isset($array[$start_year.'-'.$start_month.'-'.$i])) {
							$bar_total_array[] = $array[$start_year.'-'.$start_month.'-'.$i];
						} else {
							$bar_total_array[] = 0;
						}
					}
					
					/*echo "<pre>";
					print_r($bar_month_array);
					print_r($bar_total_array);
					echo "</pre>";
					//exit;*/
					
					$data = "";
					$kk = 0;
					foreach($bar_month_array as $mm)
					{
						$data .= '{y: '.$bar_total_array[$kk] .', label: "'.$mm.'"},';
						$kk++;
					}
					echo "[".$data."]";
				}
				else
				{
					echo "0-No orders found";
				}
			}
			else
			{
				echo "0-No orders found";
			}
		}
		
		else if($crt_1 == 3)
		{
			if($crt_3 == "")
			{
				echo "0-Please select month";
				exit;
			}
			if($crt_4 == "")
			{
				echo "0-Please select day";
				exit;
			}
			
			$check_date = $crt_3.'-'.sprintf("%02d", $crt_4);
			
			if($crt_5 == 1)
			{
				/*$exp_crt_2 = explode("-", $crt_2);
				$month_crt = $exp_crt_2[1];
				$year_crt = $exp_crt_2[0];*/
				
				$query = "SELECT DATE_FORMAT(`n_datetime`, '%Y-%m-%d %H')as hour,SUM(`total_amount`) AS total_sale FROM `orders` WHERE store_id = $key and DATE(n_datetime) = '$check_date' and `status` = 4 GROUP BY DATE_FORMAT(`n_datetime`, '%Y-%m-%d %H')";
				
				$countAccount = Yii::$app->db->createCommand($query)->queryAll();
			}
			else if($crt_5 == 2)
			{
				if($crt_6 == "")
				{
					echo "0-Please select category first";
					exit;
				}
				
				$fetch_items = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $crt_6")->queryAll();
				
				if(!$fetch_items)
				{
					echo "0-No orders found";
					exit;
				}
				else
				{
					$item_str = "";
					foreach($fetch_items as $ft)
					{
						$item_str .= $ft['id'].",";
					}
					$item_str = rtrim($item_str, ",");
					
					if($item_str == "")
					{
						echo "0-No orders found";
						exit;
					}
					else
					{						
						$query = "SELECT DATE_FORMAT(O.n_datetime, '%Y-%m-%d %H')as hour, SUM(OD.final_amount) AS total_sale FROM order_details as OD INNER JOIN `orders` as O ON OD.order_id = O.id and O.store_id = $key and DATE(O.n_datetime) = '$check_date' WHERE OD.item_id in ($item_str) and OD.status = 4 GROUP BY DATE_FORMAT(O.n_datetime, '%Y-%m-%d %H')";
						$countAccount = Yii::$app->db->createCommand($query)->queryAll();
					}
				}
			}
			else if($crt_5 == 3)
			{
				
				if($crt_6 == "")
				{
					echo "0-Please select category first";
					exit;
				}
				if($crt_7 == "")
				{
					echo "0-Please select product first";
					exit;
				}
								
				//$query = "SELECT DATE_FORMAT(O.n_datetime, '%Y-%m-%d')as day,SUM(OD.final_amount) AS total_sale FROM order_details as OD INNER JOIN `orders` as O ON OD.order_id = O.id and O.store_id = $key and YEAR(O.n_datetime) = '$year_crt' and MONTH(O.n_datetime) = '$month_crt' WHERE OD.item_id = $crt_7 and OD.status = 4 GROUP BY DATE_FORMAT(O.n_datetime, '%Y-%m-%d')";
				
				$query = "SELECT DATE_FORMAT(O.n_datetime, '%Y-%m-%d %H')as hour, SUM(OD.final_amount) AS total_sale FROM order_details as OD INNER JOIN `orders` as O ON OD.order_id = O.id and O.store_id = $key and DATE(O.n_datetime) = '$check_date' WHERE OD.item_id = $crt_7 and OD.status = 4 GROUP BY DATE_FORMAT(O.n_datetime, '%Y-%m-%d %H')";
				
				$countAccount = Yii::$app->db->createCommand($query)->queryAll();
				
			}
			
			/*echo "<pre>";
			print_r($countAccount);
			echo "</pre>";
			//exit;*/
			
			if($countAccount)
			{
				$month_array = [];
				foreach($countAccount as $month)
				{
					$month_array[] = $month['hour'];
				}
				
				asort($month_array);
				
				$count_month = count($month_array);
				
				$array = [];
				foreach($countAccount as $month)
				{
					$array[$month['hour']] = $month['total_sale'];
				}
				
				/*echo "<pre>";
				//print_r($month_array);
				print_r($array);
				echo "</pre>";
				//exit;*/
				
				if(!empty($month_array))
				{
					/*$start_key = $month_array[0];
					
					$ex_start_key = explode("-", $start_key);
					$start_month = $ex_start_key[1];
					$start_year = $ex_start_key[0];
					
					$total_days = cal_days_in_month(CAL_GREGORIAN, $start_month, $start_year);*/
									
					for($id = 0; $id <= 23; $id++)
					{
						$bar_month_array[] = sprintf("%02d", $id);;
					}
					
					/*echo "<pre>";
					print_r($bar_month_array);
					echo "</pre>";*/
					//exit;
					
					$bar_total_array = [];
					foreach($bar_month_array as $i)
					{
						if(isset($array[$check_date.' '.$i])) {
							$bar_total_array[] = $array[$check_date.' '.$i];
						} else {
							$bar_total_array[] = 0;
						}
					}
					
					/*echo "<pre>";
					print_r($bar_month_array);
					print_r($bar_total_array);
					echo "</pre>";
					//exit;*/
					
					$data = "";
					$kk = 0;
					foreach($bar_month_array as $mm)
					{
						if($mm == 23)
						{
							$mm = "23/23:59";
						}
						else
						{
							$mm = $mm."/".$mm.":59";
						}
						
						$data .= '{y: '.$bar_total_array[$kk] .', label: "'.$mm.'"},';
						$kk++;
					}
					echo "[".$data."]";
				}
				else
				{
					echo "0-No orders found";
				}
			}
			else
			{
				echo "0-No orders found";
			}
		}
	}
	
	public function actionGenGraph2()
	{
		$key	 	= $_REQUEST['b']; // Store id
		$crt_1 		= $_REQUEST['crt_1'];
		$crt_2 		= $_REQUEST['crt_2'];
		$crt_3 		= $_REQUEST['crt_3'];
		$crt_4 		= $_REQUEST['crt_4'];
		//$crt_5 		= $_REQUEST['crt_5'];
		//$crt_6 		= $_REQUEST['crt_6'];
		//$crt_7 		= $_REQUEST['crt_7'];
		
		/*echo "<pre>";
		print_r($_REQUEST);
		echo "</pre>";*/
		//exit;*/
		
		/*** Fetch categories only starts ***/
		$categorise_4_store_all = Yii::$app->db->createCommand("SELECT id, parent_id, category_name FROM `categories` WHERE store_id = $key ORDER BY id ASC")->queryAll();
	
		$new_cat_array = [];
		
		foreach($categorise_4_store_all as $c4sa) {
			$new_cat_array[$c4sa['id']] = $c4sa;
		}
		
		foreach($categorise_4_store_all as $c4sa) {
			if($c4sa['parent_id'] != 0) {
				unset($new_cat_array[$c4sa['parent_id']]);
			}
		}
		/*** Fetch categories only ends ***/
			
		if($crt_1 == 1)
		{
			$today_month = date("m");
			$today_year = date("Y");
			$prev_year = $today_year - 1;
			if($today_month == 1) {
				$prev_month = 12;
			} else {
				$prev_month = $today_month - 1;
				$prev_month = sprintf("%02d", $prev_month);
				//echo $num_padded; // returns 04
			}
			$prev_date_for_check = $prev_year."-".$prev_month."-"."01 00:00:00";

			$order_details = Yii::$app->db->createCommand("SELECT SUM(OD.final_amount) as total_sale, I.category_id FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id INNER JOIN items AS I ON OD.item_id = I.id WHERE O.store_id = $key AND O.n_datetime >= '$prev_date_for_check' AND OD.status = 4 GROUP BY I.category_id")->queryAll();
			
			
		}
		else if($crt_1 == 2)
		{
			if($crt_2 == "")
			{
				echo "0-Please select month";
				exit;
			}
			
			$exp_crt_2 = explode("-", $crt_2);
			$month_crt = $exp_crt_2[1];
			$year_crt = $exp_crt_2[0];

			$order_details = Yii::$app->db->createCommand("SELECT SUM(OD.final_amount) as total_sale, I.category_id FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id INNER JOIN items AS I ON OD.item_id = I.id WHERE O.store_id = $key AND YEAR(O.n_datetime) = '$year_crt' and MONTH(O.n_datetime) = '$month_crt' AND OD.status = 4 GROUP BY I.category_id")->queryAll();
			
		}
		
		else if($crt_1 == 3)
		{
			if($crt_3 == "")
			{
				echo "0-Please select month";
				exit;
			}
			if($crt_4 == "")
			{
				echo "0-Please select day";
				exit;
			}
			
			$check_date = $crt_3.'-'.sprintf("%02d", $crt_4);
			
			/*$query = "SELECT DATE_FORMAT(`n_datetime`, '%Y-%m-%d %H')as hour,SUM(`total_amount`) AS total_sale FROM `orders` WHERE store_id = $key and DATE(n_datetime) = '$check_date' and `status` = 4 GROUP BY DATE_FORMAT(`n_datetime`, '%Y-%m-%d %H')";
			
			$countAccount = Yii::$app->db->createCommand($query)->queryAll();*/
			
			$order_details = Yii::$app->db->createCommand("SELECT SUM(OD.final_amount) as total_sale, I.category_id FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id INNER JOIN items AS I ON OD.item_id = I.id WHERE O.store_id = $key AND DATE(O.n_datetime) = '$check_date' AND OD.status = 4 GROUP BY I.category_id")->queryAll();
			
		}
		
		if($order_details)
		{
			$graph_details = [];
			
			foreach($order_details as $od)
			{
				$graph_details[$od['category_id']] = $od;
			}
			
			$final_array = [];
			
			foreach($new_cat_array as $nca)
			{
				if(isset($graph_details[$nca['id']]))
				{
					$nca['total_sale'] = $graph_details[$nca['id']]['total_sale'];
					$nca['category_id'] = $graph_details[$nca['id']]['category_id'];
				}
				else
				{
					$nca['total_sale'] = 0;
					$nca['category_id'] = $nca['id'];
				}
				$final_array[] = $nca;
			}
			
			$cat_array  = [];
			$total_sell_array = [];
			
			foreach($final_array as $gd)
			{
				$cat_array[] = $gd['category_name'];
				$total_sell_array[] = $gd['total_sale'];
			}
			
			$data = "";
			$kk = 0;
			foreach($cat_array as $mm)
			{
				$data .= '{y: '.$total_sell_array[$kk] .', label: "'.$mm.'"},';
				$kk++;
			}
			echo "[".$data."]";
		}
		else
		{
			echo "0-No orders found";
		}
	}
}