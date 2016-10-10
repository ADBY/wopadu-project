<?php

/*
*	Stripe check
*	URL: http://localhost:8080/wopado/ws/stripe-check.php?user_id=1&stripe_id=shirishmakwana&pin_number=1234
*
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

if(!isset($_REQUEST["user_id"]) || !isset($_REQUEST["stripe_id"]) || !isset($_REQUEST["pin_number"]))
{
	print_r('0');	//	Variables not set
	exit;
}
else
{
	$user_id 		= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$stripe_id 		= mysqli_real_escape_string($link, $_REQUEST['stripe_id']);
	$pin_number		= mysqli_real_escape_string($link, $_REQUEST['pin_number']);
	
	if($user_id == "" || $stripe_id == "" || $pin_number == "")
	{
		print_r('1');   // Please insert all details
		exit;
	}
	else if(strlen($pin_number) != 4)
	{
		print_r('2');    //Pin number must be of 4 character
		exit;
	}
	else
	{
		$sql = "SELECT id, stripe_id, pin_number FROM users WHERE id = $user_id";
		$data = mysqli_query($link, $sql);
		
		if($data)
		{
			if(mysqli_num_rows($data) == 0)
			{
				 print_r('4');     // User id invalid
				 exit;			
			}
			else
			{
				$row = mysqli_fetch_assoc($data);
				
				$user_id = $row['id'];
				$db_stripe_id = $row['stripe_id'];
				$db_pin_number = $row['pin_number'];
				
				if($stripe_id != $db_stripe_id)
				{
					print_r('5');	//Invalid stripe id has been given
					exit;
				}
				else if($pin_number != $db_pin_number)
				{
					print_r('6');	//Something went wrong, Query error
					exit;
				}
				else
				{
					print_r('OK');	//Stripe id and pin number is OK
					exit;
				}
			}
		}
		else
		{
			print_r('3');    //Something went wrong, Query error
			exit;
		}
	}
}