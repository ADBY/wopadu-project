<?php

/*
*	Get details of Stripe Account details
* 	URL: http://localhost:8080/wopadu/ws/stripe-view.php?user_id=1&store_id=1
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
	  
if(!isset($_REQUEST['user_id']) || !isset($_REQUEST['store_id']))
{
	print_r('0');  //	Variables not set
	exit;
}
else
{
	$user_id 	= $_REQUEST['user_id'];
	$store_id 	= $_REQUEST['store_id'];
	
	if($user_id == "" || $store_id == "")
	{
		print_r('1');	//	User id and Store id can't be empty
		exit;
	}
	else
	{
		$result_stripe = mysqli_query($link, "SELECT * from stripe_accounts WHERE user_id = '$user_id' and store_id = '$store_id' LIMIT 1");
		
		if(!$result_stripe)
		{
			print_r('2');	// Something went wrong, Please try again
			exit;
		}
		else
		{
			if(mysqli_num_rows($result_stripe) == 0)
			{
				print_r('3');	// Stripe Account Id doesn't found
				exit;
			}
			else
			{
				$row_stripe = mysqli_fetch_assoc($result_stripe);					
				print_r(json_encode($row_stripe));	// Stripe Details Array
				
			}
		}
	}
}