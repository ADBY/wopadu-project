<?php

/*
*	My Orders
* 	URL: http://localhost:8080/wopadu/ws/orders-store.php?ws=1&user_id=1&store_id=1&page=0
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";
require_once "define.php";

if(!isset($_REQUEST['user_id']) || !isset($_REQUEST['store_id']) || !isset($_REQUEST['page']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$user_id = mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$store_id = mysqli_real_escape_string($link, $_REQUEST['store_id']);
	
	$limit = 10;
	
	if(!isset($_REQUEST['page']))
	{
		$page = 0;
		$offset = $page * $limit;
	}
	else
	{
		$page = $_REQUEST['page'];
		if($page > 0)
		{
			$page = ($page - 1);
		}
		$offset = $page * $limit;
	}
	
	$result = mysqli_query($link, "SELECT O.*, S.store_name, S.image as store_image FROM orders as O INNER JOIN stores as S ON O.store_id = S.id WHERE O.user_id = '$user_id' and O.store_id = '$store_id' and O.payment_status = 1 order by O.id DESC LIMIT $offset, $limit");
	
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
			$orders = array();
			while($row = mysqli_fetch_assoc($result))
			{
				$row['status'] = order_status($row['status']);
				if($row['store_image'] != ""){
					$row['store_image'] = $store_image.$row['store_image'];
				}
				//$row['invoice_number'] = "INV".$row['invoice_number'];
				$orders[] = $row;	// Orders details array
			}
			print_r(json_encode($orders));
		}
	}
}