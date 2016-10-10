<?php

/*
*	Change Password of User Account
* 	URL: http://localhost:8080/wopadu/ws/password-change.php?user_id=1&c_password=shirish&n_password=shirish&r_password=shirish
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

if(!isset($_REQUEST['user_id']) || !isset($_REQUEST['c_password']) || !isset($_REQUEST['n_password']) || !isset($_REQUEST['r_password']))
{
	print_r('0');	// Variables not set
	exit;
}
else
{
	$user_id 	= $_REQUEST['user_id'];
	$c_password = $_REQUEST['c_password'];
	$n_password = $_REQUEST['n_password'];
	$r_password = $_REQUEST['r_password'];
	
	if($user_id == "" || $c_password == "" || $n_password == "" || $r_password == "")
	{
		print_r('1');	// Please insert all field
		exit;
	}
	else
	{
		if(strlen($c_password) < 6)
		{
			print_r('2');	//	Please enter current password correctly
			exit;
		}
		else if(strlen($n_password) < 6)
		{
			print_r('3');	//	Password must be 6 character long
			exit;
		}
		else if($n_password != $r_password)
		{
			print_r('4');	//	Enter new password correctly two times
			exit;
		}
		else
		{
			$query = "SELECT id FROM users WHERE id = '".$user_id."' and password = '".md5($c_password)."'";
			
			$result_check = mysqli_query($link, $query);
			
			if(!$result_check)
			{
				print_r('5');	// Something went wrong, Query error
				exit;
			}
			else
			{
				if(mysqli_num_rows($result_check) == 0)
				{
					print_r('6');	// Please enter current password correctly
					exit;
				}
				else
				{
					$result = mysqli_query($link, "UPDATE users SET password = '".md5($n_password)."' WHERE id = '".$user_id."'");
					
					if(!$result)
					{
						print_r('7');	// Something went wrong, Query error
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