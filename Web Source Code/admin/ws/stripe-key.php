<?php

/*
*	Get details of Stripe Account details from super admin
* 	URL: http://localhost:8080/wopadu/ws/stripe-key.php
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
	  
$result_stripe = mysqli_query($link, "SELECT stripe_secret_key, stripe_publishable_key from admin WHERE id = 1 LIMIT 1");

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