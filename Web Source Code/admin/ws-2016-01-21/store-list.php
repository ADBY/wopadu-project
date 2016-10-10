<?php

/*
*	Get list of store
* 	URL: http://localhost:8080/wopado/ws/store-list.php
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

$result_store = mysqli_query($link, "SELECT id, store_name from stores");

if(!$result_store)
{
	print_r('0');	// Something went wrong, Please try again
	exit;
}
else
{
	if(mysqli_num_rows($result_store) == 0)
	{
		print_r('1');	// No stores found
		exit;
	}
	else
	{
		$stores = [];
		while($row_store = mysqli_fetch_assoc($result_store))
		{
			$stores[] = $row_store;
		}
		print_r(json_encode($stores));	// Store Details array
		exit;
	}
}