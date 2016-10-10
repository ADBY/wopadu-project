<?php

/*
*	Stripe Registeration
*	URL:
http://localhost:8080/wopadu/ws/stripe-register.php?user_id=1&stripe_id=shirishmakwana&pin_number=1234
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
	
	$pin_number 	= sprintf("%04d", $pin_number);
	
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
		$sql = "SELECT * FROM users WHERE id = $user_id";
		$data = mysqli_query($link, $sql);
		
		if($data)
		{
			if(mysqli_num_rows($data) == 0)
			{
				 print_r('4');     //User id invalid
				 exit;			
			}
			else
			{
				$row = mysqli_fetch_assoc($data);
				
				$user_id = $row['id'];
				
				$sql = "UPDATE `users` SET `pin_number` = '$pin_number', `stripe_id` = '$stripe_id' WHERE id = $user_id";
				
				if(mysqli_query($link, $sql))
				{
					$row['stripe_id'] = $stripe_id;
					$row['pin_number'] = $pin_number;
					
					print_r(json_encode($row)); // User details array
				}
				else
				{
					 print_r('5');	//Something went wrong, Query error
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