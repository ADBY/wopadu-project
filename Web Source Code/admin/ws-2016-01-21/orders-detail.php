<?php

/*
*	Order Detail
* 	URL: http://localhost:8080/wopado/ws/orders-detail.php?ws=1&order_id=1
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";
require_once "define.php";

if(!isset($_REQUEST['order_id']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$order_id = mysqli_real_escape_string($link, $_REQUEST['order_id']);
	
	$result = mysqli_query($link, "SELECT O.*, S.store_name, S.store_branch, S.address, S.tax_invoice, S.abn_number, S.image FROM orders as O INNER JOIN stores as S ON O.store_id = S.id WHERE O.id = '$order_id'");
	
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
			
			$row['status'] = order_status($row['status']);
			if($row['image'] != ""){
				$row['image'] = $store_image.$row['image'];
			}
			
			$res_order_details = mysqli_query($link, "SELECT O.*, I.item_name FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = '".$row['id']."'");
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
					$items = array();
					while($row_order_detail = mysqli_fetch_assoc($res_order_details))
					{
						$item_options = $row_order_detail['item_options_id'];
						$item_variety_id = $row_order_detail['item_variety_id'];
						
						if($item_options != "")
						{
							//$ex_options = explode(",", $item_options);
							//$qqq = "SELECT id, option_name, description, amount FROM item_options WHERE item_id = '".$row_order_detail['item_id']."' and id IN ($item_options)";
							
							$qqq = "SELECT  IOM.id as item_main_id, option_name, IOS.id as item_option_sub_id, sub_name, sub_amount FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)";
							
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
								$row_order_detail['item_options'] = $options;
							}							
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
								$row_order_detail['item_variety_name'] = $row_option['variety_name'];
								$row_order_detail['item_amount'] = $row_option['variety_price'];
							}
						}
						
						$items[] = $row_order_detail;
					}
					$row['items'] = $items;
				}
			}
			$row['invoice_number'] = "INV".$row['invoice_number'];
			$orders = $row;	// Orders details array

			print_r(json_encode($orders));
		}
	}
}