<?php

/*
*	Order Detail
* 	URL: http://localhost:8080/wopado/ws/orders-detail-notif.php?order_id=1&order_detail_id=1
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";
require_once "define.php";

if(!isset($_REQUEST['order_id']) || !isset($_REQUEST['order_detail_id']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$order_id = mysqli_real_escape_string($link, $_REQUEST['order_id']);
	$order_detail_id = mysqli_real_escape_string($link, $_REQUEST['order_detail_id']);
	
	$result = mysqli_query($link, "SELECT order_number, n_datetime FROM orders WHERE id = ".$order_id);
	
	if(!$result)
	{
		print_r('1'); 	// Something went wrong, Query error
		exit;
	}
	else
	{
		if(mysqli_num_rows($result) == 0)
		{
			print_r('2');	// No orders found
			exit;
		}
		else
		{
			$row = mysqli_fetch_assoc($result);

			$res_order_details = mysqli_query($link, "SELECT I.item_name, OD.quantity, OD.item_options_id, OD.item_variety_id FROM order_details as OD INNER JOIN items as I ON OD.item_id = I.id WHERE OD.id = ".$order_detail_id);
			if(!$res_order_details)
			{
				print_r('3'); 	// Something went wrong, Query error
				exit;
			}
			else
			{
				if(mysqli_num_rows($res_order_details) == 0)
				{
					print_r('4'); 	// Order details not found
					exit;
				}
				else
				{
					
					$row_order_detail = mysqli_fetch_assoc($res_order_details);
					$output = ['order_id' => $order_id, 'order_details_id' => $order_detail_id, 'order_number' => $row['order_number'], 'order_time' => $row['n_datetime'], 'item_name' => $row_order_detail['item_name']];
					
					$item_options = $row_order_detail['item_options_id'];
					$item_variety_id = $row_order_detail['item_variety_id'];
					
					if($item_options != "")
					{						
						$qqq = "SELECT  option_name, sub_name FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)";
						
						$res_option = mysqli_query($link, $qqq);
						if(!$res_option)
						{
							// do not give error
						}
						else
						{
							$options = array();
							while($row_option = mysqli_fetch_assoc($res_option))
							{
								$options[] = $row_option;
							}
							$output['options'] = $options;
						}							
					}
					else
					{
						$output['options'] = [];
					}
					
					if($item_variety_id != NULL)
					{
						$qqq = "SELECT variety_name, variety_price FROM item_variety WHERE `id` = '".$item_variety_id."'";							
						$item_variety_details = mysqli_query($link, $qqq);
						
						if(!$item_variety_details)
						{
							// do not give error
						}
						else
						{
							$row_option = mysqli_fetch_assoc($item_variety_details);
							//$row_order_detail['item_variety_name'] = $row_option['variety_name'];
							//$row_order_detail['item_amount'] = $row_option['variety_price'];
							$output['item_variety_name'] = $row_option['variety_name'];
						}
					}
					print_r(json_encode($output));
				}	
			}
		}
	}
}