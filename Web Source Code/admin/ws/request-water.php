<?php

/*
*	Place Order
* 	URL: http://localhost:8080/wopadu/ws/request-water.php?user_id=1&store_id=1&table_number=1
*
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

if(!isset($_REQUEST['user_id']) || !isset($_REQUEST['store_id']) || !isset($_REQUEST['table_number']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$user_id 			= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$store_id 			= mysqli_real_escape_string($link, $_REQUEST['store_id']);
	$table_number		= mysqli_real_escape_string($link, $_REQUEST['table_number']);

	if($user_id == "" || $store_id == "" || $table_number == "")
	{
		print_r('1'); 	// Variables can not be empty
		exit;
	}
	else
	{
		$added_date = date("Y-m-d H:i:s");
		
		$res = mysqli_query($link, "INSERT INTO request_water (`store_id`, `user_id`, `table_number`, `added_date`) VALUES ($store_id, $user_id, $table_number, '$added_date')");
		
		if($res)
		{
			print_r("OK");		// request placed
			exit;
		}
		else
		{
			print_r('2');	// something went wrong, query error
			exit;
		}
	}
}