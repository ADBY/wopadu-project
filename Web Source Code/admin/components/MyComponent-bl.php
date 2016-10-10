<?php

namespace app\components;

use Yii;
use yii\base\Component;
use yii\base\InvalidConfigException;
 
class MyComponent extends Component
{
	public function welcome()
	{
		echo "Hello..Welcome to MyComponent";
	}
	
	public function loginRole($value)
	{
		if($value == 1)
		{
			return "Super Admin";
		} else if($value == 2)
		{
			return "Account Manager";
		} else if($value == 3)
		{
			return "Cook / Bar Tender";
		} else if($value == 4)
		{
			return "Waiter";
		}
	}
	
	public function updateWaiterSync($value)
	{
		$store_id = $value['store_id'];
		$type = $value['type'];
		$date = date('Y-m-d H:i:s');
		
		if($type == "c")	// category
		{
			Yii::$app->db->createCommand("UPDATE waiter_update SET category = '$date' WHERE store_id = '$store_id'")->execute();
		}
		else if($type == "cd")	// Category Discount
		{
			Yii::$app->db->createCommand("UPDATE waiter_update SET category_discount = '$date' WHERE store_id = '$store_id'")->execute();
		}
		else if($type == "i")	// Items
		{
			Yii::$app->db->createCommand("UPDATE waiter_update SET items = '$date' WHERE store_id = '$store_id'")->execute();
		}
		else if($type == "id")	// Items Discount
		{
			Yii::$app->db->createCommand("UPDATE waiter_update SET item_discount = '$date' WHERE store_id = '$store_id'")->execute();
		}
		else if($type == "io")	// Item Options
		{
			Yii::$app->db->createCommand("UPDATE waiter_update SET item_option = '$date' WHERE store_id = '$store_id'")->execute();
		}
		else if($type == "iv")	// Item Variety
		{
			Yii::$app->db->createCommand("UPDATE waiter_update SET item_variety = '$date' WHERE store_id = '$store_id'")->execute();
		}
	}
	
	public function createreport($data)
	{
		$account = $data['account'];
		$store = $data['store'];
		$oType = $data['type'];
		$startDate = $data['start_date'];
		$endDate = $data['end_date'];
		
		$report = [];
		if($account != 0 && $account != "")
			{
				if($store != 0 && $store != "")
				{
					$account_store = Yii::$app->db->createCommand("SELECT A.account_name, S.id as store_id, S.account_id, S.store_name FROM accounts AS A INNER JOIN stores AS S ON A.id = S.account_id WHERE A.id = $account and S.id = $store")->queryAll();
				}
				else
				{
					$account_store = Yii::$app->db->createCommand("SELECT A.account_name, S.id as store_id, S.account_id, S.store_name FROM accounts AS A INNER JOIN stores AS S ON A.id = S.account_id WHERE A.id = $account")->queryAll();
				}
			}
			else
			{
				$account_store = Yii::$app->db->createCommand("SELECT A.account_name, S.id as store_id, S.account_id, S.store_name FROM accounts AS A INNER JOIN stores AS S ON A.id = S.account_id")->queryAll();
			}
			
			if($account_store)
			{
				
				$acc_array = [];
				
				foreach($account_store as $acc)
				{
					if(!in_array($acc['account_id'], $acc_array)) {
						$acc_array[] = $acc['account_id'];
					}
				}
				$a = [];
				
				foreach($account_store as $ac)
				{
					$a[$ac['account_id']]['account_id'] = $ac['account_id'];
					$a[$ac['account_id']]['account_name'] = $ac['account_name'];
					$a[$ac['account_id']]['stores'][] = ['store_id' => $ac['store_id'], 'store_name' => $ac['store_name']];
				}
							
				$account_new = array_values($a);
	
				$i = 0;
				foreach($account_new as $b)
				{
					$stores = [];
					foreach($b['stores'] as $j)
					{
						$query = "SELECT id, order_number, invoice_number, order_type, total_amount, n_datetime FROM orders WHERE store_id = ".$j['store_id'];
						if($oType != 0) {
							$query .= " AND order_type = $oType";
						}
						$query .= " AND payment_status = 1 AND (n_datetime BETWEEN '$startDate' AND '$endDate')";
						
						$order_store = Yii::$app->db->createCommand($query)->queryAll();
						
						$k = 0;
						$orders = [];
						if($order_store)
						{
							foreach($order_store as $order)
							{
								$oreder_item = Yii::$app->db->createCommand("SELECT I.item_name, O.quantity FROM order_details AS O INNER JOIN items AS I ON O.item_id = I.id WHERE O.order_id =".$order['id'])->queryAll();
								
								$order['details'] = $oreder_item;
								$orders[] = $order;
							}
						}
	
						$stores[] = ['store_id' => $j['store_id'], 'store_name' => $j['store_name'], 'orders' => $orders];
					}
					
					$b['stores'] = $stores;
					$report[$i] = $b;
					$i++;
				
				}			
			}
			
		return $report;
	}
	
	public function printreportpdf($report)
	{
		$a = 1;
		$html ="";
		foreach($report as $account)
		{
			$html .= '<div class="panel-group " id="accordion2">';
			$html .= '<h1>Wopadu</h1>';
			$html .= '<h4>Date: '.date('d-m-Y').'<br /><br /></h1>';
			$html .='<div class="panel">';
			$html .= '<div class="panel-heading dark">
						<h4 class="panel-title">
							<a style="text-decoration:none" class="">
							'.$a.'. '.$account['account_name'].'
							</a>
						</h4>
					</div>';
					
			$in = "";
			if($a == 1) { $in = 'in'; }
		
			$html .= '<div  class="panel">
					<div class="panel-body">';
			
			$b = 1; 
			foreach($account['stores'] as $store)
			{		
				$html .= '<div style="margin-bottom:50px;">
						<h4 class="text-info"><strong>'.$b.'. '.$store['store_name'].'</strong></h4>
						<br />';
				if(empty($store['orders']))
				{ 
					$html .= '<span class="text-warning"><strong>No Orders found...</strong></span>';
				}
				else
				{
					$html .= '<div style="">
								<table class="table table-bordered">
									<thead>
										<tr>
											<th style="width:10%; padding:5px">#</th>
											<th style="padding:5px">Description</th>
											<th style="width:15%; padding:5px">Order Number</th>
											<th style="width:15%; padding:5px; text-align:center">Date</th>
											<th style="width:15%; padding:5px; text-align:right">Amount</th>
											</tr>
									</thead>
									<tbody>';
					$c= 1;
					$total_income = 0; 
					foreach($store['orders'] as $order)
					{
						$html .= '<tr><td style="padding:5px">'.$c.'</td><td style="padding:5px">';
										
						foreach($order['details'] as $item)
						{
							$html .= $item['quantity']. ' x <strong>'.$item['item_name'].'</strong><br />';
						}
						
						$html .= '</td>
								<td style="padding:5px">'.$order['order_number'].'</td>
								<td style="text-align:center; padding:5px;">'.date("d-m-Y", strtotime($order['n_datetime'])).'</td>
								<td style="text-align:right; padding:5px;">$ '.$order['total_amount'].'</td>
							</tr>';
											
						$c++;
						$total_income = $total_income + $order['total_amount'];
					}
					$html .= '</tbody>
									</table>
									</div>	
									<div style="margin:20px 0">
										<strong >Total no. of orders:</strong>'. ($c-1) .'
										<br />
										<strong>Total Income:</strong> $ '. $total_income .'
										
									</div>';
				}
				$html .= '</div>';
				$b++; 
			}		
			$html .= '</div>
					</div>
				</div>
			</div>';
		$a++; 
		}
		return $html;
	}
	
	function actionApn($data)
	{
		$registrationIds 	= $data['registrationIds'];
		$message 			= $data['message'];
		
		//$registrationIds = [''];
		//$message = ['order_id' => 1, 'order_number' => 1, 'item_name' => 'test'];
		
		define('API_ACCESS_KEY', 'AIzaSyDXKVQwZOwFxBTDFEOWXTLv_9UNeK-KSHQ');
		//$registrationIds = array( $_REQUEST['id'] );
		//$registrationIds = array('APA91bGpvE6CaGR1BJpb5zy_i5UwBd79JxJsskFjFLKd8jsyBkf2h0yyM1Y5qpQ3dEhUjiHLtLTRn2VBmpOxPYB8CQLQRINqozC3xcJ85vtdtatrJUdVTE1-51uCRJxSPDmq8Gn02eQ9VqF8jvHctOT90pSeU6iPPQ','APA91bGpvE6CaGR1BJpb5zy_i5UwBd79JxJsskFjFLKd8jsyBkf2h0yyM1Y5qpQ3dEhUjiHLtLTRn2VBmpOxPYB8CQLQRINqozC3xcJ85vtdtatrJUdVTE1-51uCRJxSPDmq8Gn02eQ9VqF8jvHctOT90pSeU6iPPQ','APA91bGpvE6CaGR1BJpb5zy_i5UwBd79JxJsskFjFLKd8jsyBkf2h0yyM1Y5qpQ3dEhUjiHLtLTRn2VBmpOxPYB8CQLQRINqozC3xcJ85vtdtatrJUdVTE1-51uCRJxSPDmq8Gn02eQ9VqF8jvHctOT90pSeU6iPPQ');
		//print_r($registrationIds);
		// prep the bundle
		
		$msg = array(
			'message' => 'Message', 					//here is a message. message
			'title' => 'Title', 					//This is a title. title
			'subtitle' => 'Wopadu', 			//This is a subtitle. subtitle
			//'tickerText' => 'Order placed',
			'vibrate' => 1,
			//'sound' => 1,
			'sound' => 'N_Sound.wav',
			'alert' => 'Order is ready',
			'custom' => $message,
			'largeIcon' => 'large_icon',
			'smallIcon' => 'small_icon'
		);
	
		$fields = array(
			'registration_ids' => $registrationIds,
			'data' => $msg
		);
	
		$headers = array(
			'Authorization: key=' . API_ACCESS_KEY,
			'Content-Type: application/json'
		);
	
	
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, 'https://android.googleapis.com/gcm/send');
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
		$result = curl_exec($ch);
		curl_close($ch);
	
		//echo $result;
		//echo "1";
	}
	
	function actionIpn($data)
	{
		$deviceIds 		= $data['registrationIds'];
		$message 		= $data['message'];
		
		// set time limit to zero in order to avoid timeout
		set_time_limit(0);
	
		// charset header for output
		header('content-type: text/html; charset: utf-8');
	
		// this is the pass phrase you defined when creating the key
		$passphrase = '30091988';
	
		
		// load your device ids to an array
		/* $deviceIds = array(
		  'lh142lk3h1o2141p2y412d3yp1234y1p4y1d3j4u12p43131p4y1d3j4u12p4313',
		  'y1p4y1d3j4u12p43131p4y1d3j4u12p4313lh142lk3h1o2141p2y412d3yp1234'
		  ); */
	
		// this is where you can customize your notification
		//$payload = '{"aps":{"alert":"' . $message . '","sound":"default"}}';
		$payload = '{"aps":{"alert":"Order is ready", "custom":"' . $message . '","sound":"N_Sound.wav"}}';
		
		//echo $payload;
		//exit;
		
		$result = 'Start' . '<br />';
	
		////////////////////////////////////////////////////////////////////////////////
		// start to create connection
		$ctx = stream_context_create();
		stream_context_set_option($ctx, 'ssl', 'local_cert', 'components/WopaduDist.pem');
		stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
	
		$op_msg = count($deviceIds) . ' devices will receive notifications.<br />';
	
		foreach ($deviceIds as $item) {
			// wait for some time
			sleep(1);
	
			// Open a connection to the APNS server			
			$fp = stream_socket_client('ssl://gateway.push.apple.com:2195', $err, $errstr, 60, STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT, $ctx);
	
			if (!$fp) {
				exit;
				//exit("Failed to connect: $err $errstr" . '<br />');
			} else {
				$op_msg .= 'Apple service is online. ' . '<br />';
			}
	
			// Build the binary notification
			$msg = chr(0) . pack('n', 32) . pack('H*', $item) . pack('n', strlen($payload)) . $payload;
	
			// Send it to the server
			$result = fwrite($fp, $msg, strlen($msg)); 
	
			if (!$result) {
				$op_msg .= 'Undelivered message count: ' . $item . '<br />';
			} else {
				$op_msg .= 'Delivered message count: ' . $item . '<br />';
			}
	
			if ($fp) {
				fclose($fp);
				$op_msg .= 'The connection has been closed by the client' . '<br />';
			}
		}
	
		$op_msg .= count($deviceIds) . ' devices have received notifications.<br />';
	
		// set time limit back to a normal value
		//echo $op_msg;
		set_time_limit(30);
	}
	
	// Send Order ready Push Notification
	public function sendOrderReadyPush($order_id, $order_detail_id, $user_id)
	{
		$order_main = Yii::$app->db->createCommand("SELECT order_number, n_datetime FROM orders WHERE id = ".$order_id)->queryOne();
		$order_details = Yii::$app->db->createCommand("SELECT I.item_name, OD.quantity, OD.item_options_id, OD.item_variety_id FROM order_details as OD INNER JOIN items as I ON OD.item_id = I.id WHERE OD.id = ".$order_detail_id)->queryOne();
		
		$message = ['order_id' => $order_id, 'order_number' => $order_main['order_number'], 'order_time' => $order_main['n_datetime'],'item_name' => $order_details['item_name']];
		
		$item_options = $order_details['item_options_id'];
		if($item_options)
		{
			//$options = Yii::$app->db->createCommand("SELECT  IOM.id as item_main_id, option_name, IOS.id as item_sub_id, sub_name, sub_amount FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)")->queryAll();
			$options = Yii::$app->db->createCommand("SELECT  option_name, sub_name FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)")->queryAll();
			$message['options'] = $options;
		}else
		{
			$message['options'] = [];
		}
		
		$item_variety_id = $order_details['item_variety_id'];
		if($item_variety_id != NULL)
		{
			$item_variety_details = Yii::$app->db->createCommand("SELECT variety_name, variety_price FROM item_variety WHERE `id` = '".$item_variety_id."'")->queryOne();

			if($item_variety_details)
			{
				$message['item_variety_name'] = $item_variety_details['variety_name'];
			}
		}		
		
		$user_id_array = [];
		
		$res_devices = Yii::$app->db->createCommand("SELECT `type`, `notif_id` FROM device_registered WHERE user_id = ".$user_id." and status = 1 and notif_id != 'testingRegistrationId'")->queryAll();
		
		$APNids = array();
		$IPNids = array();
		foreach($res_devices as $row_device)
		{
			if ($row_device['type'] == 1)
			{
				$IPNids[] = $row_device['notif_id'];
			}
			else if ($row_device['type'] == 2)
			{
				$APNids[] = $row_device['notif_id'];
			}
		}
	
		/*echo "<pre>";
		print_r($APNids);print_r($IPNids);print_r($message);
		echo "</pre>";
		exit;*/
	
		if($APNids) {
			Yii::$app->mycomponent->actionApn(
				array(
					'registrationIds' 	=> $APNids, 
					'message'			=> $message,					
				)
			);
		}
		else
		{
			//echo "No android devices<br />";
		}
		if($IPNids) {
			Yii::$app->mycomponent->actionIpn(
				array(
					'registrationIds' 	=> $IPNids, 
					//'message' 			=> $message,
					'message'			=> $order_id.':'.$order_detail_id,
				)
			);
		}
		else
		{
			//echo "No iOs devices<br />";
		}
		//echo 1;
		//exit;
	}	
}