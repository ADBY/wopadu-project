<?php

/*
*	Place Order Payment Success
* 	URL: http://localhost:8080/wopadu/ws/place-order-payment.php?user_id=1&store_id=1&order_id=37&transaction_id=41231464
*
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
//require_once "functions.php";
//require_once "define.php";

$curr_date = date('Y-m-d H:i:s');

if(!isset($_REQUEST['user_id']) || !isset($_REQUEST['store_id']) || !isset($_REQUEST['order_id']) || !isset($_REQUEST['transaction_id']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$user_id 			= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$store_id 			= mysqli_real_escape_string($link, $_REQUEST['store_id']);
	$order_id 			= mysqli_real_escape_string($link, $_REQUEST['order_id']);
	$transaction_id 	= mysqli_real_escape_string($link, $_REQUEST['transaction_id']);
	
	if($user_id == "" || $store_id == "" || $order_id == "" || $transaction_id == "")
	{
		print_r('1'); 	// User id, Store id, order id, transaction id can't be empty
		exit;
	}
	else
	{
		$result = mysqli_query($link, "SELECT id FROM orders WHERE id = $order_id and user_id = $user_id and store_id = $store_id");		
		if($result)
		{
			if(mysqli_num_rows($result) > 0)
			{
				//$row_11 = mysqli_fetch_assoc($result);
				$q = "UPDATE orders SET `transaction_id` = '$transaction_id', `payment_done_date` = '$curr_date', `payment_status` = 1 WHERE id = $order_id";
				$res_up = mysqli_query($link, $q);
				
				if($res_up)
				{
					print_r('OK'); 	// Payment has been successful
					exit;
				}
				else
				{
					print_r('4'); 	// Something went wrong, Query Error
					exit;
				}
			}
			else
			{
				print_r('3'); 	// Order does not found
				exit;
			}
		}
		else
		{
			print_r('2'); 	// Something went wrong, Query Error
			exit;
		}
	}
}