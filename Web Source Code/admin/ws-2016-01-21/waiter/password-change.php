<?php

/*
*	Change Password of Waiter
* 	URL: http://localhost:8080/wopado/ws/waiter/password-change.php?waiter_id=1&c_password=shirish&n_password=shirish&r_password=shirish
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "../config.php";

if(!isset($_REQUEST['waiter_id']) || !isset($_REQUEST['c_password']) || !isset($_REQUEST['n_password']) || !isset($_REQUEST['r_password']))
{
	print_r('0');	// Variables not set
	exit;
}
else
{
	$waiter_id 	= $_REQUEST['waiter_id'];
	$c_password = $_REQUEST['c_password'];
	$n_password = $_REQUEST['n_password'];
	$r_password = $_REQUEST['r_password'];
	
	if($waiter_id == "" || $c_password == "" || $n_password == "" || $r_password == "")
	{
		print_r('1');	// Please insert all field
		exit;
	}
	else
	{
		if($n_password != $r_password)
		{
			print_r('2');	//	Enter new password correctly two times
			exit;
		}
		else
		{
			$query = "SELECT id, email, password FROM login_user WHERE id = '".$waiter_id."' and role = 4 LIMIT 1";			
			$result_check = mysqli_query($link, $query);
			
			if(!$result_check)
			{
				print_r('3');	// Something went wrong, Query error
				exit;
			}
			else
			{
				if(mysqli_num_rows($result_check) == 0)
				{
					print_r('4');	// Waiter does not found
					exit;
				}				
				else
				{
					$row = mysqli_fetch_assoc($result_check);
					
					$fetch_passowrd_hash = $row['password'];
					
					if(md5($c_password) != $fetch_passowrd_hash)
					//if(crypt($c_password, $fetch_passowrd_hash) != $fetch_passowrd_hash)
					{
						print_r('5');	// Please enter current password correctly
						exit;
					}
					else
					{
						$gen_password = md5($n_password);
						$result = mysqli_query($link, "UPDATE login_user SET password = '".$gen_password."' WHERE id = '".$waiter_id."'");
						if(!$result)
						{
							print_r('6');	// Something went wrong, Query error
							exit;	
						}
						else
						{
							print_r('OK');	// Password updated successfully
							exit;
						}
					}
				}
			}
		}
	}	
}