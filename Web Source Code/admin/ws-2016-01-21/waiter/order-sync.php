<?php

/*
*	Place Order
* 	URL: http://localhost:8080/wopado/ws/waiter/order-sync.php?waiter_id=1&store_id=1&order=JSON
*
*/

//header("Content-type: text/plain");	//Convert to plain text

require_once "../config.php";
require_once "../functions.php";
require_once "../define.php";

$curr_date = date('Y-m-d H:i:s');
$curr_time = date("H:i:s");

if(!isset($_REQUEST['waiter_id']) || !isset($_REQUEST['store_id']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$waiter_id 			= mysqli_real_escape_string($link, $_REQUEST['waiter_id']);
	$store_id 			= mysqli_real_escape_string($link, $_REQUEST['store_id']);
	
	$order 				= json_decode($_REQUEST['order']);
	
	//$a = '{"order_number":1,"invoice_number":1,"table_location":2,"total_amount":123,"payment_done_date":"2015-12-05 11:36:38","payment_status":1,"add_note":"test","status":5,"n_datetime":"2015-12-05 11:36:38","p_datetime":"2015-12-05 11:36:38","r_datetime":"2015-12-05 11:36:38","c_datetime":"2015-12-05 11:36:38","items":[{"item_id":5,"kitchen_id":1,"item_options_id":"","item_variety_id":"5","item_quantity":1,"item_amount":"85.00","item_options_amount":"0.00","item_discount":"0.00","tax_percentage":"10","final_amount":"85.00","item_note":"extra spicy","status":1},{"item_id":5,"kitchen_id":1,"item_options_id":"","item_variety_id":"5","item_quantity":1,"item_amount":"685.00","item_options_amount":"0.00","item_discount":"0.00","tax_percentage":"10","final_amount":"85.00","item_note":"extra spicy","status":1}]}';

	//$order = json_decode($a);

	if($waiter_id == "" || $store_id == "")
	{
		print_r('1'); 	// Waiter id, Store id can't be empty
		exit;
	}
	else
	{		
		$res_s = mysqli_query($link, "SELECT id FROM stores WHERE id = $store_id");
		if(!$res_s)
		{
			print_r('2');		// Something went wrong, Query Error
			exit;
		}
		else
		{
			if(mysqli_num_rows($res_s) == 0)
			{
				print_r('3');		// Store does not found
				exit;
			}
			else
			{
				$res_w = mysqli_query($link, "SELECT id FROM employee WHERE login_id = $waiter_id and store_id = $store_id");
				if(!$res_w)
				{
					print_r('4');		// Something went wrong, Query Error
					exit;
				}
				else
				{
					if(mysqli_num_rows($res_w) == 0)
					{
						print_r('5');		// Waiter does not found
						exit;
					}
					else
					{
						
						$order_type 	= 2; 			// 1 = Online, 2 = Offline
						
						$order_number 		= $order->order_number;
						$invoice_number 	= $order->invoice_number;
						$table_location 	= $order->table_location;
						$total_amount		= $order->total_amount;
						$payment_done_date 	= $order->payment_done_date;
						$payment_status 	= $order->payment_status;
						$add_note 			= $order->add_note;
						$status 			= $order->status;
						$n_datetime 		= $order->n_datetime;
						$p_datetime 		= $order->p_datetime;
						$r_datetime 		= $order->r_datetime;
						$c_datetime 		= $order->c_datetime;
						
						$items 				= $order->items;
				
						$res_order = mysqli_query($link, "INSERT INTO `orders`(`waiter_id`, `store_id`, `order_number`, `invoice_number`, `order_type`, `table_location`, `total_amount`, `payment_done_date`, `payment_status`, `add_note`, `status`, `n_datetime`, `p_datetime`, `r_datetime`, `c_datetime`) VALUES ('$waiter_id', '$store_id', '$order_number', '$invoice_number', '$order_type', '$table_location', '$total_amount', '$payment_done_date', '$payment_status', '$add_note', '$status', '$n_datetime', '$p_datetime', '$r_datetime', '$c_datetime')");
				
						if(!$res_order)
						{
							print_r('6'); 	// Something went wrong, Query error
							exit;
						}
						else
						{
							$order_id = mysqli_insert_id($link);						
								
							foreach($items as $item)
							{
								$item_id 				= $item->item_id;
								$kitchen_id 			= $item->kitchen_id;
								$item_options_id 		= $item->item_options_id;
								$item_variety_id 		= $item->item_variety_id;
								$item_quantity 			= $item->item_quantity;
								$item_amount 			= $item->item_amount;
								$item_options_amount 	= $item->item_options_amount;
								$item_discount 			= $item->item_discount;
								$tax_percentage			= $item->tax_percentage;
								$final_amount 			= $item->final_amount;
								$item_note 				= $item->item_note;
								$item_status					= $item->status;
								
								if($item_variety_id == "") {
								$query = "INSERT INTO `order_details`(`order_id`, `item_id`, `kitchen_id`, `item_options_id`, `quantity`, `item_amount`, `item_options_amount`, `item_discount`, `tax_percentage`, `final_amount`, `add_note`, `status`) VALUES ('$order_id', '$item_id', '$kitchen_id', '$item_options_id', '$item_quantity', '$item_amount', '$item_options_amount', '$item_discount', '$tax_percentage', '$final_amount', '$item_note', '$item_status')";
								} else {
									$query = "INSERT INTO `order_details`(`order_id`, `item_id`, `kitchen_id`, `item_options_id`, `item_variety_id`, `quantity`, `item_amount`, `item_options_amount`, `item_discount`, `tax_percentage`, `final_amount`, `add_note`, `status`) VALUES ('$order_id', '$item_id', '$kitchen_id', '$item_options_id', '$item_variety_id ', '$item_quantity', '$item_amount', '$item_options_amount', '$item_discount', '$tax_percentage', '$final_amount', '$item_note', '$item_status')";
								}
								
								$res_order_detail = mysqli_query($link, $query);
				
								if(!$res_order_detail)
								{
									print_r('7'); 	// Something went wrong, Query error
									exit;
								}
							}
							
							$order_placed = ['order_id'=> $order_id];
							//print_r("OK/".$order_id);	// Order has been placed
							print_r(json_encode($order_placed));	// Order has been placed
							exit;			
						}
						
					}
				}
			}
		}
	}	
}