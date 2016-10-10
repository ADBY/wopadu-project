<?php

/*
*	Add new stripe id
*	URL: http://localhost:8080/wopadu/ws/stripe-add.php?user_id=1&store_id=1&stripe_acc_id=213465fgsfkhsgdhg&cvv_number=235&card_number=4561346789&exp_date_month=03&exp_date_year=2017&secret_key=231456464&publishable_key=98754654&pin_number=4513
*	Type: 
*	1. iOs
*	2. Android
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";

if(!isset($_REQUEST['user_id']) || !isset($_REQUEST["store_id"]) || !isset($_REQUEST["stripe_acc_id"]) || !isset($_REQUEST["cvv_number"]) || !isset($_REQUEST["card_number"]) || !isset($_REQUEST["exp_date_month"]) || !isset($_REQUEST["exp_date_year"]) || !isset($_REQUEST["secret_key"]) || !isset($_REQUEST["publishable_key"]) || !isset($_REQUEST["pin_number"]))
{
	print_r('0');	//	Variables not set
	exit;	
}
else
{
	$user_id 			= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$store_id 			= mysqli_real_escape_string($link, $_REQUEST['store_id']);
	$stripe_acc_id 		= mysqli_real_escape_string($link, $_REQUEST['stripe_acc_id']);
	$cvv_number 		= mysqli_real_escape_string($link, $_REQUEST['cvv_number']);
	$card_number 		= mysqli_real_escape_string($link, $_REQUEST['card_number']);
	$exp_date_month 	= mysqli_real_escape_string($link, $_REQUEST['exp_date_month']);
	$exp_date_year 		= mysqli_real_escape_string($link, $_REQUEST['exp_date_year']);
	$secret_key 		= mysqli_real_escape_string($link, $_REQUEST['secret_key']);
	$publishable_key 	= mysqli_real_escape_string($link, $_REQUEST['publishable_key']);
	$pin_number 		= mysqli_real_escape_string($link, $_REQUEST['pin_number']);
	
	$up_date			= currentTime();
	
	if($user_id == "" || $store_id == "" || $stripe_acc_id == "" || $cvv_number == "" || $card_number == "" || $exp_date_month == "" || $exp_date_year == "" || $secret_key == "" || $publishable_key == "" || $pin_number == "")
	{
		print_r('1');   // Please insert all details
		exit;
	}
	else
	{
		$check_user = mysqli_query($link, "SELECT pin_number, card_number, cvv_number, expiry_date_month, expiry_date_year FROM users WHERE id = '$user_id'");
		if(!$check_user)
		{
			print_r('2');   // Something went wrong, Query Error
			exit;
		}
		else
		{
			if(mysqli_num_rows($check_user) == 0)
			{
				 print_r('3');     // User id does not exists
				 exit;			
			}
			else
			{
				
				$row_user = mysqli_fetch_assoc($check_user);
				$pin_number_db 			= $row_user['pin_number'];
				$card_number_db 		= $row_user['card_number'];
				$cvv_number_db 			= $row_user['cvv_number'];
				$expiry_date_month_db 	= $row_user['expiry_date_month'];
				$expiry_date_year_db 	= $row_user['expiry_date_year'];
				
				/*if($pin_number != $pin_number_db)
				{
					print_r('4');     // Invalid pin number
				 	exit;
				}
				else
				{*/
					
					if($pin_number_db == "" || $card_number_db == "" || $cvv_number_db == "" || $expiry_date_month_db == "" || $expiry_date_year_db == "")
					{
						$sql_1 = "UPDATE users SET pin_number = '$pin_number', card_number = '$card_number', cvv_number = '$cvv_number', expiry_date_month = '$exp_date_month', expiry_date_year = '$exp_date_year' WHERE id = '$user_id'";
						
						$up_card = mysqli_query($link, $sql_1);
						
						if(!$up_card)
						{
							print_r('5');   // Something went wrong, Query Error
							exit;
						}						
					}
					
					$check_strp = mysqli_query($link, "SELECT id FROM stripe_accounts WHERE user_id = '$user_id' and store_id = '$store_id'");
					if(!$check_strp)
					{
						print_r('6');   // Something went wrong, Query Error
						exit;
					}
					else
					{
						if(mysqli_num_rows($check_strp) > 0)
						{
							 print_r('7');     // Stripe id already exists for this store
							 exit;			
						}
						else
						{
				
							$sql = "INSERT INTO `stripe_accounts`(`user_id`, `store_id`, `stripe_account_id`, `card_number`, `cvv_number`, `expiry_date_month`, `expiry_date_year`, `secret_key`, `publishable_key`, `up_date`) VALUES ('$user_id', '$store_id', '$stripe_acc_id', '$card_number', '$cvv_number', '$exp_date_month', '$exp_date_year', '$secret_key', '$publishable_key', '$up_date')";
							if(!mysqli_query($link, $sql))
							{
								print_r('8'); // Something went wrong, Query error
								exit;
							}
							else
							{
								$id = mysqli_insert_id($link);
								
								$data = mysqli_query($link,"SELECT * FROM stripe_accounts WHERE id=".$id."") ;
								$fetch = mysqli_fetch_assoc($data);
								print_r(json_encode($fetch));
								exit;
							}
						}
					}
				//}
			}
		}
	} 	
}