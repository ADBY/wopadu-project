<?php

/*
*	Register User
*	URL:
http://localhost:8080/wopadu/ws/register.php?ws=1&first_name=Shirish&last_name=Makwana&email=shirishm.makwana@gmail.com&password=shirish&mobile=9924400799
*
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";

if(!isset($_REQUEST["ws"]) || !isset($_REQUEST["first_name"]) || !isset($_REQUEST["last_name"]) || !isset($_REQUEST["email"]) || !isset($_REQUEST["password"]) || !isset($_REQUEST["mobile"]))
{
	print_r('0');	//	Variables not set
	exit;
}
else
{
	$first_name 	= mysqli_real_escape_string($link, $_REQUEST['first_name']);
	$last_name 		= mysqli_real_escape_string($link, $_REQUEST['last_name']);
	$email 			= mysqli_real_escape_string($link, $_REQUEST['email']);
	$password 		= mysqli_real_escape_string($link, $_REQUEST['password']);
	$mobile 		= mysqli_real_escape_string($link, $_REQUEST['mobile']);
	
	$verif_code		= verifCodeGenNum();
	$reg_datetime	= currentTime();
    $exp_time       = date('Y-m-d H:i:s', strtotime("+12 hours"));
        
	$status			= 1;
	
	if($first_name == "" || $email == "" || $password == "" || $mobile == "")
	{
		print_r('1');   // Please insert all details
		exit;
	}
	else if(!preg_match("/^[A-Z a-z]+$/",$first_name))
	{
		print_r('2');   //First name is invalid, Contains only alphabets and space
		exit;
	}
	/*else if(!preg_match("/^[A-Z a-z]+$/",$last_name))
	{
		print_r('3');   //Last name is invalid, Contains only alphabets and space
		exit;
	}*/
	else if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i", $email))
	{
        print_r('4');   //Email-ID is invalid
		exit;
    }
	else if(strlen($password) < 6)
	{
		print_r('5');    //Minimum 6 char required in password
		exit;
	}
	/*else if(strlen($pin_number) != 4)
	{
		print_r('6');    //Pin number must be of 4 character
		exit;
	}*/
	else
	{
		$sql = "SELECT * FROM users WHERE email='$email'";
		$data = mysqli_query($link, $sql);
		
		if(mysqli_num_rows($data) > 0)
		{
			 print_r('7');     //Email already exist
			 exit;			
		}
		else
		{
			$password 	= md5($password);
			
			$sql = "INSERT INTO `users`(`first_name`, `last_name`, `email`, `password`, `mobile`, `reg_datetime`, `verif_account`, `verif_code`, `verif_code_exp_datetime`, `verif_datetime`, `status`) VALUES ('$first_name' , '$last_name', '$email', '$password', '$mobile', '$reg_datetime', '0', '$verif_code', '$exp_time', NULL, '$status')";
			
			if(mysqli_query($link, $sql))
			{				
				$id = mysqli_insert_id($link);	
				
				$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
				$row_email = mysqli_fetch_assoc($res_email);
				
				$admin_email = $row_email['value'];
				
				$to 		= $email;
				
				$subject 	= "Wopadu - Verify your email";
				
				$message 	= '
					<!doctype html>
					<html>
					<head>
					<meta charset="utf-8">
					<title>Verify Account | Wopadu</title>
					</head>
					
					<body>
					<table dir="ltr">
						<tbody>
							<tr>
								<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#551570">Wopadu account</td>
							</tr>
							<tr>
								<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#CE1764">Account verification code</td>
							</tr>
							<tr>
								<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Please use this code to verify your email at Wopadu account <a dir="ltr" style="color:#2672ec;text-decoration:none" href="mailto:'.$email.'" target="_blank">'.$email.'</a>.</td>
							</tr>
							<tr>
								<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Here is your code: <span style="font-family:\'Segoe UI Bold\',\'Segoe UI Semibold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:14px;font-weight:bold;color:#2a2a2a">'.$verif_code.'</span></td>
							</tr>
							<tr>
								<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Thanks,</td>
							</tr>
							<tr>
								<td style="padding:0;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">The Wopadu team</td>
							</tr>
						</tbody>
					</table>
					</body>
					</html>';
				$header 	= "From:".$admin_email." \r\n";
				$header 	.= "MIME-Version: 1.0\r\n";
				$header 	.= "Content-type: text/html\r\n";
				
				$sentmail = mail ($to, $subject, $message, $header);
				
				$data = mysqli_query($link,"SELECT * FROM users WHERE id=".$id."") ;
				$fetch = mysqli_fetch_assoc($data);
				
				print_r(json_encode($fetch));
			}
			else
			{
				 print_r('8');	//Something went wrong, Query error
				 exit;
			}			 
		}
	} 	
}