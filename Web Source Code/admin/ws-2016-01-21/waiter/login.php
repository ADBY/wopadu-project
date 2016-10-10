<?php

/*
*	Login Waiter to Application
* 	URL: http://localhost:8080/wopado/ws/waiter/login.php?email=parth@gmail.com&password=shirish
*/

/*
$password = "shirishs";
$password_hash = crypt($password, 'asdfghjlk');

if(crypt('shirish', $password_hash) == $password_hash) {
    echo 'password is correct';
  }
  else
  {
	  echo "invald";
	 }

exit;*/

header("Content-type: text/plain");	//Convert to plain text

require_once "../config.php";

if(!isset($_REQUEST['email']) || !isset($_REQUEST['password']))
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
	 else
	 {
		$query = mysqli_query($link, "SELECT id, email, password FROM login_user WHERE email = '$email' and role = 4 LIMIT 1");
		
		if(!$query)
		{
			print_r('3');  // Something went wrong, Query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($query) == 0)
			{
				print_r('4');  //	Invalid username and Password
				exit;
			}
			else
			{
				$row = mysqli_fetch_assoc($query);
				
				$password_hash = $row['password'];
				
				if($row["password"] == md5($password))
				//if(crypt($password, $password_hash) != $password_hash)
				//if(compare($password, $password_hash))
				{
					$fetch_details_sql = mysqli_query($link, "SELECT store_id, emp_name FROM employee WHERE login_id = ".$row['id']);
					if(!$fetch_details_sql)
					{
						print_r('6');  // Something went wrong, Query error
						exit;
					}
					else
					{
						if(mysqli_num_rows($fetch_details_sql) == 0)
						{
							print_r('7');  //	Details not found
							exit;
						}
						else
						{
							$row_waiter = mysqli_fetch_assoc($fetch_details_sql);
							$row['store_id'] = $row_waiter['store_id'];
							$row['emp_name'] = $row_waiter['emp_name'];
							print_r(json_encode($row));		// Returns waiter details array
						}
					}
				}
				else
				{
					print_r('5');  // Please  insert correct password
					exit;
				}				
			}
		}
	 }
}
?>
