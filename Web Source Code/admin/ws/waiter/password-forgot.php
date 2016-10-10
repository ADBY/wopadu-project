<?php

/*
*	Forgot Password Steps
* 	URL: 
*	Step - 1: http://localhost:8080/wopadu/ws/waiter/password-forgot.php?step=1&email=shirishm.makwana@gmail.com
*	Step - 2: http://localhost:8080/wopadu/ws/waiter/password-forgot.php?step=2&email=shirishm.makwana@gmail.com&verif_code=123456&n_password=shirish&r_password=shirish
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

include("../config.php");

if(isset($_REQUEST['step']) && $_REQUEST['step'] == 1 && isset($_REQUEST['email']) )
{
	$email = $_REQUEST['email'];
	
	if($email == "")
	{
		print_r('1'); //	Email can't be empty
		exit;
	}
	else if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i", $email))
	{
		print_r('2'); //	Invalid email format
		exit;
	}
	else
	{
		$result = mysqli_query($link, "select id from login_user where email='$email' and role = 4");

		if(!$result)
		{
			print_r('3');     //	Something went wrong, query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($result) == 0)
			{
				print_r('4');     //	Email does not associated with any account
				exit;
			}
			else
			{
				$row = mysqli_fetch_assoc($result);
				
				$user_id = $row['id'];
				
				$password_reset_token = mt_rand(1000, 9999).mt_rand(10, 99); 
				$verif_code_exp = date("Y-m-d H:i:s", strtotime("+2 hours"));
				
				$result_user =mysqli_query($link, "UPDATE login_user SET password_reset_token = '$password_reset_token', verif_code_exp = '$verif_code_exp' WHERE id ='$user_id'");
				
				$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
				$row_email = mysqli_fetch_assoc($res_email);
				
				$admin_email = $row_email['value'];
				
				$to 		= $email;
				//$to 		= "shirishm.makwana@gmail.com";
				
				$subject 	= "Wopadu - Forgot Password";
				
				$message 	= '
					<!doctype html>
					<head>
					<meta charset="utf-8">
					<title>Forgot Password</title>
					</head>
					
					<body>
					<table dir="ltr">
					<tbody>
						<tr>
							<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#551570">Wopadu account</td>
						</tr>
						<tr>
							<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#CE1764">Forgot Password</td>
						</tr>
						<tr>
							<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Please use this code to change your password at Wopadu account <a dir="ltr" style="color:#2672ec;text-decoration:none" href="mailto:'.$email.'" target="_blank">'.$email.'</a>.</td>
						</tr>
						<tr>
							<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Here is your code: <span style="font-family:\'Segoe UI Bold\',\'Segoe UI Semibold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:14px;font-weight:bold;color:#2a2a2a">'.$password_reset_token.'</span></td>
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
				print_r('OK');	//	Email has been sent with verification code.
				exit;
			}
		}
	}
}
else if(isset($_REQUEST['step']) && $_REQUEST['step'] == 2 && isset($_REQUEST['email']) && isset($_REQUEST['verif_code']) && isset($_REQUEST['n_password']) && isset($_REQUEST['r_password']) )
{
	$email 		= $_REQUEST['email'];
	$verif_code = $_REQUEST['verif_code'];
	$n_password = $_REQUEST['n_password'];
	$r_password = $_REQUEST['r_password'];
	
	if($email == "" || $verif_code == "" || $n_password == "" || $r_password == "")
	{
		print_r('1');	// Please insert all field
		exit;
	}
	else
	{	
		if($n_password != $r_password)
		{
			print_r('2');	//Enter new password correctly two times
			exit;
		}
		else
		{
			$query = "SELECT id, password_reset_token, verif_code_exp FROM login_user WHERE email = '".$email."'";
			
			$result_check = mysqli_query($link, $query);
			
			if(!$result_check)
			{
				print_r('3');     //	Something went wrong, query error
				exit;
			}
			else
			{
				if(mysqli_num_rows($result_check) == 0)
				{
					print_r('4');	// Email address is not addociated with any account
					exit;
				}
				else
				{
					$row_check = mysqli_fetch_array($result_check);
					
					$user_id = $row_check['id'];
					$cur_time = date("Y-m-d H:i:s");
					
					if($cur_time > $row_check['verif_code_exp'])
					{
						print_r('5');	// Verification code has been expired
						exit;
					}
					else
					{
						if($verif_code != $row_check['password_reset_token'])
						{
							print_r('6');	// Verification code does not match
							exit;
						}
						else
						{
							$result = mysqli_query($link, "UPDATE login_user SET password = '".md5($n_password)."', password_reset_token = NULL, verif_code_exp = NULL WHERE id = '".$user_id."'");
							
							if(!$result)
							{
								print_r('7');	// Something went wrong, query error
								exit;								
							}
							else
							{
								print_r('OK');	// Password changed successfully
								exit;
							}
						}
					}
				}
			}
		}
	}
}
else
{
	print_r('0');	//Variable not set
	exit;
}