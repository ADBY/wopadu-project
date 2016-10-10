<?php

/*
*	Get details of store using beacon Id
* 	URL: http://localhost:8080/wopadu/ws/waiter/store-details.php?store_id=1
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "../config.php";
	  
if(!isset($_REQUEST['store_id']))
{
	print_r('0');  //	Variables not set
	exit;
}
else
{
	$store_id = $_REQUEST['store_id'];
	
	if($store_id == "")
	{
		print_r('1');	//	Store id can't be empty
		exit;
	}
	else
	{
		$q = "SELECT S.*, A.account_name from stores as S INNER JOIN accounts as A ON A.id = S.account_id WHERE S.id = '$store_id' LIMIT 1";
		$result = mysqli_query($link, $q);

		if(!$result)
		{
			print_r('2');	// Something went wrong, Please try again
			exit;
		}
		else
		{
			if(mysqli_num_rows($result) == 0)
			{
				print_r('3');	// Store doesn't found
				exit;
			}
			else
			{
				$row = mysqli_fetch_assoc($result);
				
				$countItems = mysqli_query($link, "SELECT count(I.id) as total_items FROM `items` as I INNER JOIN categories as C ON I.category_id = C.id AND C.store_id = $store_id");
				$row_items = mysqli_fetch_assoc($countItems);
				
				$row['total_items'] = $row_items['total_items'];
				print_r(json_encode($row));	// Store Details array
			}
		}
	}
}