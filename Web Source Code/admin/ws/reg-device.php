<?php

/*
*	Register User Device
*	URL: http://localhost:8080/wopadu/ws/reg-device.php?user_id=1&device_id=AjksUhdYEwsd1SD2KsMS&notif_id=213465fgsfkhsgdhg&type=1&action=login
*	Type: 
*	1. iOs
*	2. Android
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";

if(!isset($_REQUEST['action']) || !isset($_REQUEST["user_id"]) || !isset($_REQUEST["device_id"]) || !isset($_REQUEST["notif_id"]) || !isset($_REQUEST["type"]))
{
	print_r('0');	//	Variables not set
	exit;	
}
else if($_REQUEST['action'] == "login")
{
	$user_id 		= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$device_id 		= mysqli_real_escape_string($link, $_REQUEST['device_id']);
	$notif_id 		= mysqli_real_escape_string($link, $_REQUEST['notif_id']);
	$type 			= mysqli_real_escape_string($link, $_REQUEST['type']);
	$reg_datetime	= currentTime();
	$status			= 1;
	
	if($user_id == "" || $device_id == "" || $notif_id == "" || $type == "")
	{
		print_r('1');   // Please insert all details
		exit;
	}
	else
	{
		$check_user = mysqli_query($link, "SELECT id FROM users WHERE id = '$user_id'");
		
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
				$check_device = mysqli_query($link, "SELECT * FROM device_registered WHERE user_id = '$user_id' and device_id = '$device_id' and type = '$type'");
		
				if(!$check_device)
				{
					print_r('4');   // Something went wrong, Query Error
					exit;
				}
				else
				{
					if(mysqli_num_rows($check_device) > 0)
					{
						$fetch = mysqli_fetch_assoc($check_device);						
						
						$reg_id = $fetch['id'];
						
						if($fetch['notif_id'] == $notif_id)
						{
							$fetch['type'] = getDeviceType($fetch['type']);
							print_r(json_encode($fetch));
							//echo 1;
							exit;
						}
						else
						{
							$up_device = mysqli_query($link, "UPDATE device_registered SET notif_id = '$notif_id' WHERE id = $reg_id");
							$fetch['notif_id'] = $notif_id;
							print_r(json_encode($fetch));
							//echo 2;
							exit;
						}
					}
					else
					{
						$sql = "INSERT INTO `device_registered`(`user_id`, `device_id`, `notif_id`, `type`, `reg_datetime`, `status`) VALUES ('$user_id', '$device_id', '$notif_id', '$type', '$reg_datetime', '$status')";
						
						if(!mysqli_query($link, $sql))
						{
							print_r('5'); // Something went wrong, Query error
							exit;
						}
						else
						{
							$id = mysqli_insert_id($link);
							
							$data = mysqli_query($link,"SELECT * FROM device_registered WHERE id=".$id."") ;
							$fetch = mysqli_fetch_assoc($data);
							
							$fetch['type'] = getDeviceType($fetch['type']);
							print_r(json_encode($fetch));
							//echo 3;
							exit;
						}
					}
				}
			}
		}
	} 	
}

else if($_REQUEST['action'] == "logout")
{
	$user_id 		= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$device_id 		= mysqli_real_escape_string($link, $_REQUEST['device_id']);
	$notif_id 		= mysqli_real_escape_string($link, $_REQUEST['notif_id']);
	$type 			= mysqli_real_escape_string($link, $_REQUEST['type']);
	
	if($user_id == "" || $device_id == "" || $notif_id == "" || $type == "")
	{
		print_r('1');   // Please insert all details
		exit;
	}
	else
	{
		$check_device = mysqli_query($link, "SELECT id FROM device_registered WHERE user_id = '$user_id' and device_id = '$device_id' and notif_id = '$notif_id' and type = '$type'");

		if(!$check_device)
		{
			print_r('2');   // Something went wrong, Query Error
			exit;
		}
		else
		{
			if(mysqli_num_rows($check_device) > 0)
			{
				$fetch = mysqli_fetch_assoc($check_device);						
				
				$reg_id = $fetch['id'];
								
				$up_device = mysqli_query($link, "DELETE FROM `device_registered` WHERE id = $reg_id");
				if(!$up_device)
				{
					print_r('3');   // Something went wrong, Query Error
					exit;
				}
				else
				{
					print_r("DELETED");
					exit;
				}			
			}
			else
			{				
				print_r("NOT-FOUND");
				exit;
			}
		}
	} 	
}
?>