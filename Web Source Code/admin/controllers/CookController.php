<?php

namespace app\controllers;

use Yii;
use app\models\Kitchens;
use app\models\LoginUser;
use app\models\Employee;
use app\models\Orders;
use app\models\OrderDetails;
use app\models\OrderComplete;

class CookController extends \yii\web\Controller
{
    public function actionIndex()
    {
        $session = Yii::$app->session;
		
		$login_id = $session['login_id'];
		$kitchen_id = $session['kitchen_id'];
		$emp_id = $session['emp_id'];
		
		$model_l = LoginUser::findOne($login_id);
		$model_k = Kitchens::findOne($kitchen_id);
		$model_e = Employee::findOne($emp_id);
		
		
        return $this->render('index', [
            'model_l' => $model_l,
			'model_k' => $model_k,
			'model_e' => $model_e,
        ]);
    }
	
	/**
     * Updates an existing Kitchens model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate()
    {
		$session = Yii::$app->session;

		$login_id = $session['login_id'];
		$id = $session['emp_id']; // Kitchen Id

		$model_e = Employee::findOne($id);
		$model_l = LoginUser::findOne($login_id);

		$cur_password = $model_l->password;
		
        if(Yii::$app->request->post())
		{
			$model_l->attributes = $_POST['LoginUser'];
			$model_e->attributes = $_POST['Employee'];
			
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

			if($error_1 == false && $model_l->validate() && $model_e->validate())
			{			
				$model_l->save();
				$model_e->save();
			
				Yii::$app->session->setFlash('kitchens', 'Profile details has been updated.');
				return $this->redirect(['index']);
			}
        }
				
		return $this->render('update', [
			'model_l' => $model_l,
			'model_e' => $model_e,
		]);
    }
	
	public function actionOrders(){
		
		$session = Yii::$app->session;
		
		//$login_id = $session['login_id'];
		$id = $session['kitchen_id'];	// Kitchen Id
		$limit = 6;
	
		if(!isset($_GET['page'])) {
			$page = 0;
			$offset = $page * $limit;
		} else {
			$page = $_GET['page'];
			if($page > 0) {
				$page = ($page - 1);
			}
			$offset = $page * $limit;
		}

		$this->layout = 'emplayout';

		$kitchen = Kitchens::findOne($id);
		$cook = [];
		
		if($kitchen)
		{
			$store_id = $kitchen->store_id;
			
			//$totalPendingOrders = Yii::$app->db->createCommand("SELECT COUNT(DISTINCT order_id) FROM `order_details` WHERE kitchen_id = $id and status < 4");
			$totalPendingOrders = Yii::$app->db->createCommand("SELECT COUNT(DISTINCT order_id) FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id WHERE OD.kitchen_id = ".$session['kitchen_id']." and OD.status < 4 and O.payment_status = 1");
			
			$orderCount = $totalPendingOrders->queryScalar();
			
			
			//$pendingOrders = Yii::$app->db->createCommand("SELECT DISTINCT order_id FROM `order_details` WHERE kitchen_id = $id and status < 4 LIMIT $offset, $limit");
			$pendingOrders = Yii::$app->db->createCommand("SELECT DISTINCT order_id FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id WHERE OD.kitchen_id = $id and OD.status < 4 and O.payment_status = 1 LIMIT $offset, $limit");
			
			$pendingOrdersList = $pendingOrders->queryAll();
			
			//$cook = [];
			$s = 0;
			foreach($pendingOrdersList as $pol) 
			{			
				$order = Yii::$app->db->createCommand("SELECT id, user_id, order_number, table_location, add_note, allergies, status, n_datetime FROM orders WHERE id = ".$pol['order_id']." and payment_status = 1")->queryOne();

				if($order)
				{
					/*echo "<pre>";
					print_r($order);
					echo "</pre>";*/

					$cook[] = $order;
					
					$user_name = Yii::$app->db->createCommand("SELECT first_name, last_name FROM users WHERE id = ".$order['user_id']."")->queryOne();
					
					if($user_name)
					{
						$cook[$s]['username'] = $user_name['first_name']; //.' '.$user_name['last_name'];
					}

					//foreach($orders as $order)
					{
						$order_details = Yii::$app->db->createCommand("SELECT OD.status, OD.quantity, OD.add_note, OD.item_options_id, OD.item_variety_id, OD.id as od_id, I.item_name FROM order_details as OD INNER JOIN items as I ON I.id = OD.item_id WHERE OD.order_id = '".$order['id']."' and OD.kitchen_id = '".$id."'")->queryAll();
		
						if($order_details)
						{
							$k = 0;
							$complete_kitchen = true;
							foreach($order_details as $details)
							{
								if($details['status'] == 1 || $details['status'] == 2 || $details['status'] == 3)
								{
									$complete_kitchen = false;
								}
								
								if($details['item_options_id'] != "")
								{
									$item_options = $details['item_options_id'];
									
									$options = Yii::$app->db->createCommand("SELECT  IOM.id as item_main_id, option_name, IOS.id as item_sub_id, sub_name, sub_amount FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)")->queryAll();
									
									if($options)
									{
										$order_details[$k]['options'] = $options;
									}
									else
									{
										$order_details[$k]['options'] = [];
									}
								}
								else
								{
									$order_details[$k]['options'] = [];
								}
								
								$item_variety_id = $details['item_variety_id'];							
								if($item_variety_id != NULL)
								{
									$item_variety_details = Yii::$app->db->createCommand("SELECT variety_name, variety_price FROM item_variety WHERE `id` = '".$item_variety_id."'")->queryOne();
									
									if($item_variety_details)
									{
										$order_details[$k]['item_variety_name'] = $item_variety_details['variety_name'];
									}
									else
									{
										$order_details[$k]['item_variety_id'] = NULL;
									}
								}
								
								$k++;
							}
							if($complete_kitchen == true)
							{
								unset($cook[$s]);
							}
							else
							{
								$cook[$s]['ordered_items'] = $order_details;
							}
						}
						else
						{
							unset($cook[$s]);
						}
						//$s++;
					}
					$s++;
				}
				
				
			
			}
			
			/*$prev_datetime = date("Y-m-d H:i:s", strtotime("-5 minutes"));
			
			$cook_cancelled = [];
			//$cancelled = Yii::$app->db->createCommand("SELECT id,order_number, table_location, add_note, status, c_datetime  FROM orders WHERE store_id = $store_id and c_datetime > '$prev_datetime' and status = 5 order by id asc")->queryAll();
			$cancelled = Yii::$app->db->createCommand("SELECT id,order_number, table_location, add_note, status, c_datetime  FROM orders WHERE store_id = $store_id and status = 5 order by id asc")->queryAll();

			$cook_cancelled = $cancelled;
			
			if($cancelled)
			{
				$s = 0;
				foreach($cancelled as $order)
				{
					$order_details = Yii::$app->db->createCommand("SELECT OD.status, OD.quantity, OD.add_note, OD.item_options_id, OD.item_variety_id, OD.id as od_id, I.item_name FROM order_details as OD INNER JOIN items as I ON I.id = OD.item_id WHERE OD.order_id = '".$order['id']."' and OD.kitchen_id = '".$id."'")->queryAll();
					
					if($order_details)
					{
						$k = 0;
						$complete_kitchen = true;
						
						foreach($order_details as $details)
						{
							if($details['status'] == 1 || $details['status'] == 2)
							{
								$complete_kitchen = false;
							}
							
							if($details['item_options_id'] != "")
								{
									$item_options = $details['item_options_id'];
									
									$options = Yii::$app->db->createCommand("SELECT  IOM.id as item_main_id, option_name, IOS.id as item_sub_id, sub_name, sub_amount FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)")->queryAll();
									
									if($options)
									{
										$order_details[$k]['options'] = $options;
									}
									else
									{
										$order_details[$k]['options'] = [];
									}
								}
								else
								{
									$order_details[$k]['options'] = [];
								}
								
								$item_variety_id = $details['item_variety_id'];							
								if($item_variety_id != NULL)
								{
									$item_variety_details = Yii::$app->db->createCommand("SELECT variety_name, variety_price FROM item_variety WHERE `id` = '".$item_variety_id."'")->queryOne();
									
									if($item_variety_details)
									{
										$order_details[$k]['item_variety_name'] = $item_variety_details['variety_name'];
									}
								}
							$k++;
						}
						
						if($complete_kitchen == true)
						{
							unset($cook_cancelled[$s]);
						}
						else
						{
							$cook_cancelled[$s]['ordered_items'] = $order_details;
						}						
					}
					else
					{
						unset($cook_cancelled[$s]);
					}					
					$s++;
				}
			}
			
			$cook = array_merge($cook_cancelled, $cook);*/
		}
		
		$first_kitchen = Yii::$app->db->createCommand("SELECT id FROM kitchens WHERE store_id = $store_id")->queryOne();
		
		if($first_kitchen) {
			if($first_kitchen['id'] == $id) {
				$request_water = Yii::$app->db->createCommand("SELECT DISTINCT store_id, table_number FROM request_water WHERE store_id = $store_id")->queryAll();
			} else {
				$request_water = [];
			}
		} else {
			$request_water = [];
		}
		
		/*echo "<pre>";
print_r(array_values($cook));
echo "</pre>";
exit;*/


		return $this->render('orders', [
			'cook' => array_values($cook),
			'orderCount' => $orderCount,
			'request_water' => $request_water,
		]);
	}
	
	
	public function actionUporderstatus()
	{
		$new_od_status 	= $_POST['status'];
		$od_id 			= $_POST['od_id'];

		$datetime = date("Y-m-d H:i:s");

		$orderItem = OrderDetails::findOne($od_id);
		
		$order_id 	= $orderItem->order_id;
		$kitchen_id = $orderItem->kitchen_id;

		$orderItem->status = $new_od_status;
		$orderItem->save();

		$order = Orders::findOne($order_id);

		$store_id 		= $order->store_id;
		$new_o_status 	= $order->status;
		$user_id_order	= $order->user_id;
		$table_location = $order->table_location;

		/*if($new_od_status == 1)
		{
			$order_details = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE order_id = $order_id and status > 1")->queryAll();
			if(!$order_details)
			{
				if($new_o_status != 1)
				{
					$order->status = 1;
					$order->p_datetime = NULL;
					$order->r_datetime = NULL;
					$order->c_datetime = NULL;
					$order->save();
				}
			}
			else
			{
				if($new_o_status != 2)
				{
					$order->status = 2;
					//$order->p_datetime = $datetime;
					$order->r_datetime = NULL;
					$order->c_datetime = NULL;
					$order->save();
				}
			}
		}
		else */
		if($new_od_status == 2)
		{
			if($new_o_status != 2)
			{
				$order->status = 2;
				$order->p_datetime = $datetime;
				$order->r_datetime = NULL;
				$order->c_datetime = NULL;
				$order->save();
			}
		}
		else if($new_od_status == 3)
		{
			$order_details = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE order_id = $order_id and status < 3")->queryAll();
			if(!$order_details)
			{
				if($new_o_status != 3)
				{
					$order->status = 3;
					if($order->p_datetime == NULL)
					{
						$order->p_datetime = $datetime;
					}
					$order->r_datetime = $datetime;
					$order->c_datetime = NULL;
					$order->save();
				}
			}
			else
			{
				if($new_o_status != 2)
				{
					$order->status = 2;
					//$order->p_datetime = $datetime;
					$order->r_datetime = NULL;
					$order->c_datetime = NULL;
					$order->save();
				}
			}
		}
		else if($new_od_status == 4)
		{
			$order_details = Yii::$app->db->createCommand("SELECT id, status FROM order_details WHERE order_id = $order_id and status < 4")->queryAll();
			if(!$order_details)
			{
				if($new_o_status != 4)
				{
					$order->status = 4;
					if($order->p_datetime == NULL)
					{
						$order->p_datetime = $datetime;
					}
					$order->r_datetime = $datetime;
					$order->c_datetime = $datetime;
					$order->save();
				}
			}
			else
			{
				/*if($new_o_status != 3)
				{
					$order->status = 3;
					//$order->p_datetime = $datetime;
					$order->r_datetime = $datetime;
					$order->c_datetime = NULL;
					$order->save();
				}*/
				
				$order_details = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE order_id = $order_id and status < 3")->queryAll();
				if(!$order_details)
				{
					if($new_o_status != 3)
					{
						$order->status = 3;
						if($order->p_datetime == NULL)
						{
							$order->p_datetime = $datetime;
						}
						$order->r_datetime = $datetime;
						$order->c_datetime = NULL;
						$order->save();
					}
				}
				else
				{
					if($new_o_status != 2)
					{
						$order->status = 2;
						//$order->p_datetime = $datetime;
						$order->r_datetime = NULL;
						$order->c_datetime = NULL;
						$order->save();
					}
				}
			}			
		}
		
		$o_status = $order->status;
		$rem_o_id = "";

		/*if($o_status != 3)
		{
			$new_check_status = Yii::$app->db->createCommand("SELECT id, status, kitchen_id FROM order_details WHERE order_id = $order_id and status < 3")->queryAll();
			if(!$new_check_status)
			{
				$o_k_status = 3; 	// Order status for this particular kitchen
			}
			else
			{
				$this_kitchen = false;
				foreach($new_check_status as $single_check)
				{
					if($single_check['kitchen_id'] == $kitchen_id)
					{
						$this_kitchen = true;
					}
					$rem_o_id .= $single_check['id'].",";
				}
				$rem_o_id = rtrim($rem_o_id, ",");
				
				if($this_kitchen == false)
				{
					$o_k_status = 3; // Order status for this particular kitchen
				}
				else
				{
					$o_k_status = $o_status; // Order status for this particular kitchen
				}
			}
		}
		else 
		{
			$o_k_status = $o_status;	// Order status for this particular kitchen
		}*/

		$new_check_status = Yii::$app->db->createCommand("SELECT id, status FROM order_details WHERE order_id = $order_id and kitchen_id = $kitchen_id")->queryAll();
		
		$min_status = $o_status;
		foreach($new_check_status as $single_check)
		{
			if($single_check['status'] < 3)
			{
				$rem_o_id .= $single_check['id'].",";
			}
			
			if($single_check['status'] < $min_status)
			{
				$min_status = $single_check['status'];
			}
		}
		
		$rem_o_id = rtrim($rem_o_id, ",");
		
		/*if($this_kitchen == false)
		{
			$o_k_status = 3; // Order status for this particular kitchen
		}
		else
		{
			$o_k_status = $o_status; // Order status for this particular kitchen
		}*/
		
		if($min_status == 1 && $o_status == 1) {
			$o_k_status = 1;
		} else if($min_status == 1 && ( $o_status == 2 || $o_status == 3 || $o_status == 4)) {
			$o_k_status = 2;
		} else if($min_status == 1 && $o_status == 5) {
			$o_k_status = 1;
		} else if($min_status == 2 && ( $o_status == 2 || $o_status == 3 || $o_status == 4 || $o_status == 5)) {
			$o_k_status = 2;
		} else if($min_status == 3 && ($o_status == 3 || $o_status == 4 || $o_status == 5)) {
			$o_k_status = 3;
		} else if($min_status == 4) {
			$o_k_status = 4;
		}
		
		//$o_k_status = $min_status;
			
		if($new_od_status == 3)
		{
			$model = new OrderComplete();
			$model->store_id = $store_id;
			$model->order_id = $order_id;
			$model->order_detail_id = $od_id;
			$model->remaining_od = $rem_o_id;
			$model->added_date = date("Y-m-d H:i:s");
			$model->save();
		}
		else if($new_od_status == 4)
		{
			$model = OrderComplete::findOne(['store_id' => $store_id, 'order_id' => $order_id, 'order_detail_id' => $od_id]);
			$model->delete();
		}
		
		if($new_od_status == 3 && $user_id_order != NULL && $table_location == "Takeaway")
		{
			$report = Yii::$app->mycomponent->sendOrderReadyPush($order_id, $od_id, $user_id_order);
		}
		
		/*if($new_od_status == 4 && $user_id_order != NULL && $table_location == "Takeaway")
		{
			$report = Yii::$app->mycomponent->sendOrderReadyPush($order_id, $od_id, $user_id_order);
		}*/

		echo json_encode(['o_id' => $order_id, 'o_status' => $o_k_status, 'od_status' => $new_od_status]);
	}
	
	public function actionReqWaterDel()
	{
		$tbl_n = $_POST['tbl_n'];
		$str_id = $_POST['str_id'];
		
		$del = Yii::$app->db->createCommand("DELETE FROM request_water WHERE store_id = $str_id and table_number = $tbl_n")->execute();
		
		if($del) {
			echo 1; exit;
		} else {
			echo 0; exit;
		}
		
	}
	
	public function actionRestoScreen(){
		
		$session = Yii::$app->session;
		
		//$login_id = $session['login_id'];
		$id = $session['kitchen_id'];	// Kitchen Id
		$emp_id = $session['emp_id'];
		$model_e = Employee::findOne($emp_id);
		$store_id = $model_e->store_id;
		
		$this->layout = 'emplayout';
		
		$resto = [];
		$query = "SELECT DISTINCT(order_id) FROM order_complete WHERE store_id = $store_id order by id asc";
		$order_completed = Yii::$app->db->createCommand($query)->queryAll();
		if($order_completed)
		{
			//echo 'eeee';
			//exit;
			$order_id_str = "";
			foreach($order_completed as $comp)
			{
				$order_id_str .= $comp['order_id'].",";
			}
			$order_id_str = rtrim($order_id_str, ",");
			
			$order_details = Orders::find(['order_number', 'table_location'])->where("id in ($order_id_str)")->all();
			$order_details = Yii::$app->db->createCommand("SELECT order_number, table_location FROM orders WHERE id in ($order_id_str)")->queryAll();
			
			$resto = $order_details;
		}
/*echo "<pre>";
print_r($resto);
echo "</pre>";
exit;*/
		return $this->render('resto-screen', [
			'resto' => $resto,
		]);
	}
	
	public function actionTestpushmsg()
	{
		//$report = Yii::$app->mycomponent->sendOrderReadyPush($order_id, $od_id, $user_id_order);
		Yii::$app->mycomponent->sendOrderReadyPush(784,882,38);
		//Yii::$app->mycomponent->welcome();
	}

}
