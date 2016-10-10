<?php

## http://localhost:8080/wopado/ws/profile-pic-remove.php?ws=1&user_id=1

header("Content-type: text/plain"); //makes sure entities are not interpreted

require_once "config.php";

if(!isset($_REQUEST['ws']) || !isset($_REQUEST['user_id']))
{
	print_r("0");	//	Variables not set
	exit;
}
else
{
	$id = mysqli_real_escape_string($link, $_REQUEST['user_id']);
	
	if($id == "")
	{
		print_r("1");  // User Id can't be empty
		exit;		
	}
	else
	{	
		$result =  "SELECT image FROM users WHERE id = '".$id."' ";
		$data = mysqli_query($link,$result);
		
		if(!$data)
		{
			print_r("2");  // Something went wrong, Query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($data) == 0)
			{
				print_r("3");	// User id does not exist
				exit;
			}
			else
			{
				$row = mysqli_fetch_assoc($data);
				
				$file = $row['image'];
				
				if($file == "")
				{
					print_r("OK"); // Profile picture removed successfully
					exit;
				}
				else
				{	
					if(file_exists("../images/users/".$file))
					{
						unlink ("../images/users/".$file);
					}
					
					$sql = "UPDATE `users` SET `image` = '' WHERE id= '$id'";
					if( mysqli_query($link, $sql))
					{
						print_r("OK");	// Profile picture removed successfully
						exit;
					}
					else
					{
						print_r("4");	// Something went wrong, Query error
						exit;
					}				
				}
			}
		}
	}	
}