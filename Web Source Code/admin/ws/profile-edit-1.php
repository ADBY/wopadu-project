<?php

/*
*	Edit Profile Details
* 	URL: http://localhost:8080/wopadu/ws/profile-edit.php?user_id=1&first_name=Shirish&last_name=Makwana&mobile=9924400799
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

if(!isset($_REQUEST["user_id"]) || !isset($_REQUEST["first_name"]) || !isset($_REQUEST["last_name"]) || !isset($_REQUEST["mobile"]))
{
	print_r('0');    // variables not set
	exit;
}
else
{
	$user_id 		= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$first_name 	= mysqli_real_escape_string($link, $_REQUEST['first_name']);
	$last_name 		= mysqli_real_escape_string($link, $_REQUEST['last_name']);
	$mobile 		= mysqli_real_escape_string($link, $_REQUEST['mobile']);
	
	if($user_id == "" || $first_name == "" || $mobile == "")
	{
		print_r('1');     // Please enter userid, first name, last name, mobile
		exit;
	}
	else if(!preg_match("/^[A-Z a-z]+$/",$first_name))
	{
		print_r('2');   // First name is invalid, Contains only alphabets and space
		exit;
	}
	/*else if(!preg_match("/^[A-Z a-z]+$/",$last_name))
	{
		print_r('3');   // Last name is invalid, Contains only alphabets and space
		exit;
	}*/
	else if(!preg_match("/^[0-9]+$/",$mobile))
	{
		print_r('4');   // Mobile number is invalid, Contains number only
		exit;
	}
	else
	{
		$check_user = mysqli_query($link, "SELECT id FROM users WHERE id = '$user_id'");
		
		if(!$check_user)
		{
			print_r('5'); // Something went wrong, Query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($check_user) == 0)
			{
				print_r('6');  // User id does not exist
				exit;
			}
			else
			{
				$sql = "UPDATE `users` SET `first_name` = '$first_name', `last_name` = '$last_name', `mobile` = '$mobile' WHERE id = '$user_id'";
			
				if( mysqli_query($link, $sql))
				{
					$data = mysqli_query($link, "SELECT * FROM users WHERE id=".$user_id."") ;
					$fetch = mysqli_fetch_assoc($data);
					print_r(json_encode($fetch));	// User details array				
				}
				else
				{
					print_r('7'); // Something went wrong, Query error
					exit;
				}
			}
		}
	}
}