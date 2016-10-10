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
		stream_context_set_option($ctx, 'ssl', 'local_cert', 'components/WopaduShrFinal.pem');
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
		echo "<br /><b>APN IDS</b><br />";
                print_r($APNids);
                echo "<br /><b>IPN IDS</b><br />";
                print_r($IPNids);
                echo "<br /><b>Message</b><br />";
                print_r($message);
                echo "<br /><b>Users</b><br />";
                print_r($user_id_array);
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
	
	// Google Translater
	public function googleTraslateAPI($text, $source_lang, $target_lang)
	{
		$api_key = 'AIzaSyBZGxG0th3SBB7mktcef9VUCR5zk4RF1Vo';
		//$text = 'How are you';
		//$source_lang="en";
		//$target_lang="fr";
		 
		$url = 'https://www.googleapis.com/language/translate/v2?key=' . $api_key . '&q=' . rawurlencode($text);
		$url .= '&target='.$target_lang;
		$url .= '&source='.$source_lang;
		
		$response = file_get_contents($url);
		$obj =json_decode($response,true); //true converts stdClass to associative array.
		if($obj != null)
		{
			if(isset($obj['error']))
			{
				$output['response'] = $obj['error']['message'];
			}
			else
			{
				$output['response'] = "OK";
				$output['translation'] = $obj['data']['translations'][0]['translatedText'];		
			}
		}
		else
		{
			$output['response'] = "UNKNOW ERROR";
		}
		return $output;
	}
	
	// Bing Translater
	
	/*
     * Get the access token.
     *
     * @param string $grantType    Grant type.
     * @param string $scopeUrl     Application Scope URL.
     * @param string $clientID     Application client ID.
     * @param string $clientSecret Application client ID.
     * @param string $authUrl      Oauth Url.
     *
     * @return string.
     */
	public function getTokens($grantType, $scopeUrl, $clientID, $clientSecret, $authUrl)
	{
        try {
            //Initialize the Curl Session.
            $ch = curl_init();
            //Create the request Array.
            $paramArr = array (
                 'grant_type'    => $grantType,
                 'scope'         => $scopeUrl,
                 'client_id'     => $clientID,
                 'client_secret' => $clientSecret
            );
            //Create an Http Query.//
            $paramArr = http_build_query($paramArr);
            //Set the Curl URL.
            curl_setopt($ch, CURLOPT_URL, $authUrl);
            //Set HTTP POST Request.
            curl_setopt($ch, CURLOPT_POST, TRUE);
            //Set data to POST in HTTP "POST" Operation.
            curl_setopt($ch, CURLOPT_POSTFIELDS, $paramArr);
            //CURLOPT_RETURNTRANSFER- TRUE to return the transfer as a string of the return value of curl_exec().
            curl_setopt ($ch, CURLOPT_RETURNTRANSFER, TRUE);
            //CURLOPT_SSL_VERIFYPEER- Set FALSE to stop cURL from verifying the peer's certificate.
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            //Execute the  cURL session.
            $strResponse = curl_exec($ch);
            //Get the Error Code returned by Curl.
            $curlErrno = curl_errno($ch);
            if($curlErrno){
                $curlError = curl_error($ch);
                throw new Exception($curlError);
            }
            //Close the Curl Session.
            curl_close($ch);
            //Decode the returned JSON string.
            $objResponse = json_decode($strResponse);
			/*echo "<pre>";
            print_r($objResponse);
			exit;*/
			if (isset($objResponse->error)){
                throw new Exception($objResponse->error_description);
            }
            return $objResponse->access_token;
        } catch (Exception $e) {
            echo "Exception-".$e->getMessage();
        }
    }
	
	/*
     * Create and execute the HTTP CURL request.
     *
     * @param string $url        HTTP Url.
     * @param string $authHeader Authorization Header string.
     * @param string $postData   Data to post.
     *
     * @return string.
     *
     */
    public function curlRequest($url, $authHeader)
	{
        //Initialize the Curl Session.
        $ch = curl_init();
        //Set the Curl url.
        curl_setopt ($ch, CURLOPT_URL, $url);
        //Set the HTTP HEADER Fields.
        curl_setopt ($ch, CURLOPT_HTTPHEADER, array($authHeader,"Content-Type: text/xml"));
        //CURLOPT_RETURNTRANSFER- TRUE to return the transfer as a string of the return value of curl_exec().
        curl_setopt ($ch, CURLOPT_RETURNTRANSFER, TRUE);
        //CURLOPT_SSL_VERIFYPEER- Set FALSE to stop cURL from verifying the peer's certificate.
        curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, False);
        //Execute the  cURL session.
        $curlResponse = curl_exec($ch);
        //Get the Error Code returned by Curl.
        $curlErrno = curl_errno($ch);
        if ($curlErrno) {
            $curlError = curl_error($ch);
            throw new Exception($curlError);
        }
        //Close a cURL session.
        curl_close($ch);
        return $curlResponse;
    }
	
	public function bingTraslateAPI($text, $fromLanguage, $toLanguage)
	{		
		//include_once 'components/HttpTranslator.php';
		//include_once 'components/AccessTokenAuthentication.php';
	
		try {
			//Client ID of the application.
			//$clientID       = "shirishmakwana_wopadu";
			$clientID 		= Yii::$app->params['clientIDBing'];
			
			//Client Secret key of the application.
			//$clientSecret = "Aw/Foz7H/e9fa+yq9XvxxPR8HASCC2hjFpvpM/DuOw0=";
			$clientSecret 		= Yii::$app->params['clientSecretBing'];
			
			//OAuth Url.
			$authUrl      = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13/";
			//Application Scope Url
			$scopeUrl     = "http://api.microsofttranslator.com";
			//Application grant type
			$grantType    = "client_credentials";
	
			//Create the AccessTokenAuthentication object.
			//$authObj      = new AccessTokenAuthentication();
			//Get the Access token.
			//$accessToken  = $authObj->getTokens($grantType, $scopeUrl, $clientID, $clientSecret, $authUrl);
			$accessToken  = Yii::$app->mycomponent->getTokens($grantType, $scopeUrl, $clientID, $clientSecret, $authUrl);
			
			//Create the authorization Header string.
			$authHeader = "Authorization: Bearer ". $accessToken;
	
			//Set the params.//
			//$fromLanguage = "en";
			//$toLanguage   = "hi";
			//$inputStr     = $_POST["txtToTranslate"];
			$inputStr     = $text;
			$contentType  = 'text/plain';
			$category     = 'general';
		
			$params = "text=".urlencode($inputStr)."&to=".$toLanguage."&from=".$fromLanguage;
			$translateUrl = "http://api.microsofttranslator.com/v2/Http.svc/Translate?$params";
		
			//Create the Translator Object.
			//$translatorObj = new HTTPTranslator();
		
			//Get the curlResponse.
			//$curlResponse = $translatorObj->curlRequest($translateUrl, $authHeader);
			$curlResponse = Yii::$app->mycomponent->curlRequest($translateUrl, $authHeader);
			
			//Interprets a string of XML into an object.
			$xmlObj = simplexml_load_string($curlResponse);
			foreach((array)$xmlObj[0] as $val){
				$translatedStr = $val;
			}
			$output['response'] = "OK";
			$output['translation'] = $translatedStr;
			//unset($authObj);
			//unset($translatorObj);

		} catch (Exception $e) {
			$output['response'] = "Exception: " . $e->getMessage() . PHP_EOL;
		}
		return $output;
	}
	
	
	public function translateItemNotif($data)
	{
		$type 		= $data['type'];
		$item_id 	= $data['item_id'];
		$action 	= 0; // By Default
		$added_date = date('Y-m-d H:i:s');	// Current Date
		
		Yii::$app->db->createCommand("INSERT INTO `translater_item`(`type`, `item_id`, `action`, `added_date`) VALUES ('$type', '$item_id', '$action', '$added_date')")->execute();
	}
	
	/*public function delTranslateItemNotif($data)
	{
		$type 		= $data['type'];
		$item_id 	= $data['item_id'];
		
		Yii::$app->db->createCommand("DELETE FROM `translater_item` WHERE `type` = '$type' AND `item_id` = '$item_id'")->execute();
	}*/
	
	public function image_validation($fileName, $fileTmpLoc, $fileType, $fileSize, $fileErrorMsg, $kaboom, $fileExt)
	{
		$error = "";
		// START PHP Image Upload Error Handling --------------------------------------------------
		if (!$fileTmpLoc)
		{ 
			// if file not chosen
			$error = "ERROR: Please browse for a file before clicking the upload button.";
		}
		else if($fileSize > 5242880)
		{
			// if file size is larger than 5 Megabytes
			$error = "ERROR: Your file was larger than 5 Megabytes in size.";
			@unlink($fileTmpLoc); // Remove the uploaded file from the PHP temp folder
		}
		else if (!preg_match("/.(jpg|png)$/i", $fileName))
		{
			 // This condition is only if you wish to allow uploading of specific file types    
			 $error = "ERROR: Your image was not .jpg, or .png.";
			 unlink($fileTmpLoc); // Remove the uploaded file from the PHP temp folder
		}
		else if ($fileErrorMsg == 1)
		{
			// if file upload error key is equal to 1
			 $error = "ERROR: An error occured while processing the file. Try again.";
		}
		
		return $output = array("error" => $error, "image_name" => $fileName);
	}
	
	public function image_resizing($fileName, $fileTmpLoc, $fileType, $fileSize, $fileErrorMsg, $kaboom, $fileExt, $folder_type)
	{
		$error = "";
		// END PHP Image Upload Error Handling ----------------------------------------------------
		// Place it into your "uploads" folder mow using the move_uploaded_file() function
		$moveResult = move_uploaded_file($fileTmpLoc, $folder_type."/$fileName");
		
		// Check to make sure the move result is true before continuing
		if ($moveResult != true)
		{
			$error = "ERROR: File not uploaded. Try again.";
			@unlink($fileTmpLoc); // Remove the uploaded file from the PHP temp folder
		}
		else
		{				
			@unlink($fileTmpLoc); // Remove the uploaded file from the PHP temp folder
			// ---------- Include Universal Image Resizing Function --------
			
			//include_once("function.php");
			
			$target_file = $folder_type."/$fileName";
			$resized_file = $folder_type."/$fileName";
			
			$wmax = 530;
			$hmax = 400;
			
			Yii::$app->mycomponent->ak_img_resize($target_file, $resized_file, $wmax, $hmax, $fileExt);
		}
		
		return $output = array("error" => $error, "image_name" => $fileName);
		
		
		// ----------- End Universal Image Resizing Function -----------
		// Display things to the page so you can see what is happening for testing purposes
		/*echo "The file named <strong>$fileName</strong> uploaded successfuly.<br /><br />";
		echo "It is <strong>$fileSize</strong> bytes in size.<br /><br />";
		echo "It is an <strong>$fileType</strong> type of file.<br /><br />";
		echo "The file extension is <strong>$fileExt</strong><br /><br />";
		echo "The Error Message output for this upload is: $fileErrorMsg";*/
	}
	
	public function ak_img_resize($target, $newcopy, $w, $h, $ext)
	{
		list($w_orig, $h_orig) = getimagesize($target);
		$scale_ratio = $w_orig / $h_orig;
		if (($w / $h) > $scale_ratio) {
			$w = $h * $scale_ratio;
		} else {
			$h = $w / $scale_ratio;
		}
		
		$img = "";
		$ext = strtolower($ext);
		if ($ext == "gif"){ 
			$img = imagecreatefromgif($target);
		} else if($ext =="png"){ 
			$img = imagecreatefrompng($target);
		} else { 
			$img = imagecreatefromjpeg($target);
		}
		
		$tci = imagecreatetruecolor($w, $h);
		// imagecopyresampled(dst_img, src_img, dst_x, dst_y, src_x, src_y, dst_w, dst_h, src_w, src_h)
		imagecopyresampled($tci, $img, 0, 0, 0, 0, $w, $h, $w_orig, $h_orig);
		imagejpeg($tci, $newcopy, 80);
	}
}