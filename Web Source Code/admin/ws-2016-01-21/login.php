<?php

/*
*	Login User to Application
* 	URL: http://localhost:8080/wopado/ws/login.php?ws=1&email=shirishm.makwana@gmail.com&password=shirish
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
	  
if(!isset($_REQUEST['ws']) || !isset($_REQUEST['email']) || !isset($_REQUEST['password']))
{
	print_r('0');  //	Variables not set
	exit;
}
else
{
	$email 		= mysqli_real_escape_string($link, $_REQUEST['email']);
	$password 	= mysqli_real_escape_string($link, $_REQUEST['password']);
	
	 if($email == "" || $password == "")
	 {
		print_r('1');     //Please enter E-mail and Password
		exit;
	 }	
	 else if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i", $email))
	 {
		print_r('2');    //Email-ID is invalid!
		exit;
	 }
	 else if(strlen($password) < 6)
	 {
		print_r('3');    //Minimum 6 char required in password - Incorrect Password
		exit;
	 }
	 else
	 {
		$query = mysqli_query($link, "SELECT * FROM users WHERE email = '$email' LIMIT 1");
		
		if(!$query)
		{
			print_r('4');  // Something went wrong, Query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($query) == 0)
			{
				print_r('5');  //	Invalid username and Password
				exit;
			}
			else
			{
				$row = mysqli_fetch_assoc($query);
				if($row["password"] != md5($password))
				{
					print_r('6');  // Please  insert correct password
					exit;
				}
				else
				{
					if($row['verif_account'] == 0)
					{
						print_r('7');  //Account is not verified
						exit;
					}
					else if($row['status'] == 0)
					{
						print_r('8');  //Account is deactivated
						exit;
					}
					else
					{
						/*echo "<pre>";
						print_r($row);
						echo "</pre>";*/
						if($row['pin_number'] != NULL)
						{
							$row['pin_number'] = sprintf("%04d", $row['pin_number']);;
						}
						print_r(json_encode($row));		// Returns user details array
					}
				}
			
			}
		}
	 }
}
?>
