<?php

/*
*	Check menu for synhronise
* 	URL: http://localhost:8080/wopado/ws/waiter/check-menu-sync.php?waiter_id=12&store_id=1
*/

header("Content-type: text/plain");		//Convert to plain text

require_once "../config.php";
require_once "../define.php";

$curr_date = date('Y-m-d H:i:s');

if(!isset($_REQUEST['waiter_id']) || !isset($_REQUEST['store_id']))
{
	print_r('0');	//	Variables not set
	exit;
}
else
{
	$waiter_id 		= mysqli_real_escape_string($link, $_REQUEST['waiter_id']);
	$store_id 		= mysqli_real_escape_string($link, $_REQUEST['store_id']);
	
	if($waiter_id == "" || $store_id == "")
	{
		print_r('1');     //Please enter waiter id and store id
		exit;
	}
	else
	{
		$res_sql = mysqli_query($link, "SELECT * FROM `waiter_update` WHERE `waiter_login_id` = '$waiter_id' and `store_id` = '$store_id'");
		
		if(!$res_sql)
		{
			print_r('2');     //Something went wrong, Query Error
			exit;
		}
		else
		{
			if(mysqli_num_rows($res_sql) == 0)
			{
				print_r('3');     //Waiter and store not found
				exit;
			}
			else
			{
				$output = [];
				
				$row = mysqli_fetch_assoc($res_sql);
				
				$last_update_checked 	= $row['last_update_checked'];
				$category 				= $row['category'];
				$category_discount 		= $row['category_discount'];
				$items 					= $row['items'];
				$item_discount 			= $row['item_discount'];
				$item_option 			= $row['item_option'];
				$item_variety 			= $row['item_variety'];
				
				if($last_update_checked == NULL) {
					$output = ['category', 'item'];
				} else {
					$output = [];
					
					if($category != NULL && $last_update_checked < $category) {
						$output[] = 'category';
					}
					if($category_discount != NULL && $last_update_checked < $category_discount) {
						$output[] = 'category';
					}
					if($items != NULL && $last_update_checked < $items) {
						$output[] = 'item';
					}
					if($item_discount != NULL && $last_update_checked < $item_discount) {
						$output[] = 'item';
					}
					if($item_option != NULL && $last_update_checked < $item_option) {
						$output[] = 'item';
					}
					if($item_variety != NULL && $last_update_checked < $item_variety) {
						$output[] = 'item';
					}
					
					$output = array_values(array_unique($output));
				}	
				
				print_r(json_encode($output));
				exit;
			}
		}
	}
}