<?php

/*
*	Stripe check
*	URL: http://localhost:8080/wopadu/ws/stripe-check.php?user_id=1&store_id=1&stripe_id=shirishmakwana&pin_number=1234
*
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

if(!isset($_REQUEST["user_id"]) || !isset($_REQUEST["store_id"]) || !isset($_REQUEST["stripe_id"]) || !isset($_REQUEST["pin_number"]))
{
	print_r('0');	//	Variables not set
	exit;
}
else
{
	$user_id 		= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$store_id 		= mysqli_real_escape_string($link, $_REQUEST['store_id']);
	$stripe_id 		= mysqli_real_escape_string($link, $_REQUEST['stripe_id']);
	$pin_number		= mysqli_real_escape_string($link, $_REQUEST['pin_number']);
	
	if($user_id == "" || $store_id == "" || $stripe_id == "" || $pin_number == "")
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
		$sql = "SELECT 	id,pin_number FROM users WHERE id = $user_id";
		$data = mysqli_query($link, $sql);
		
		if(!$data)
		{
			print_r('3');    //Something went wrong, Query error
			exit;
		}
		else
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
				$pin_number_db = $row['pin_number'];
				
				if($pin_number != $pin_number_db)
				{
					print_r('5');	//Invalid pin number
					exit;
				}
				else
				{
					$result_stripe = mysqli_query($link, "SELECT stripe_account_id from stripe_accounts WHERE user_id = '$user_id' and store_id = '$store_id' LIMIT 1");
		
					if(!$result_stripe)
					{
						print_r('6');	// Something went wrong, Please try again
						exit;
					}
					else
					{
						if(mysqli_num_rows($result_stripe) == 0)
						{
							print_r('7');	// Stripe Account Id doesn't found
							exit;
						}
						else
						{
							$row_stripe = mysqli_fetch_assoc($result_stripe);
							
							$stripe_id_db = $row_stripe['stripe_account_id'];
				
							if($stripe_id != $stripe_id_db)
							{
								print_r('8');	//Invalid stripe id has been given
								exit;
							}
							else
							{
								print_r('OK');	//Stripe id and pin number is OK
								exit;
							}
						}
					}
				}
			}
		}
	}
}