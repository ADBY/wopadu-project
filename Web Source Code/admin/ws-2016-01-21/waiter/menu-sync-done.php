<?php

/*
*	Menu synhronise Complete
* 	URL: http://localhost:8080/wopado/ws/waiter/menu-sync-done.php?waiter_id=12&store_id=1
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
		$res_sql = mysqli_query($link, "SELECT id FROM `waiter_update` WHERE `waiter_login_id` = '$waiter_id' and `store_id` = '$store_id'");
		
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
				$row = mysqli_fetch_assoc($res_sql);
				
				$id 	= $row['id'];
				
				$up_res = mysqli_query($link, "UPDATE `waiter_update` SET `last_update_checked` = '$curr_date' WHERE id = $id");				
				
				if(!$up_res)
				{
					print_r('4');
					exit;
				}
				else
				{
					print_r('OK');
					exit;
				}
			}
		}
	}
}