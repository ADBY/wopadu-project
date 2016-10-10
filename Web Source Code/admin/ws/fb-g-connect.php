<?php

/*
*	Facebook - Google - Connect
*	URL:
http://localhost:8080/wopadu/ws/fb-g-connect.php?first_name=Shirish&last_name=Makwana&email=shirishm.makwana@gmail.com&connect=fb

connect = t (Twitter)
*
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";

if(!isset($_REQUEST["first_name"]) || !isset($_REQUEST["last_name"]) || !isset($_REQUEST["email"]) || !isset($_REQUEST["connect"]))
{
	print_r('0');	//	Variables not set
	exit;
}
else
{
	$first_name 	= mysqli_real_escape_string($link, $_REQUEST['first_name']);
	$last_name	 	= mysqli_real_escape_string($link, $_REQUEST['last_name']);
	$email 			= mysqli_real_escape_string($link, $_REQUEST['email']);
	$connect 		= strtolower(mysqli_real_escape_string($link, $_REQUEST['connect']));

	$reg_datetime	= currentTime();
    $status			= 1;
	
	if($first_name == "" || $email == "" || $connect == "")
	{
		print_r('1');   // Please insert all details
		exit;
	}
	else if($connect != "fb" && $connect != "g" && $connect != "t")
	{
		print_r('2');   // Connection is invalid
		exit;
	}
	else
	{
		$sql = "SELECT * FROM users WHERE email='$email'";
		
		$data = mysqli_query($link, $sql);
		
		if($data)
		{
			if(mysqli_num_rows($data) > 0)
			{
				$fetch = mysqli_fetch_assoc($data);
				
				$user_id = $fetch['id'];
				
				if($connect == "fb" && $fetch['facebook_connect'] == 0)
				{
					if($fetch['verif_account'] == 0) {
					$res = mysqli_query($link, "UPDATE users set `verif_account` = 1, `verif_code` = NULL, `verif_code_exp_datetime` = NULL, `verif_datetime` = '$reg_datetime', `facebook_connect` = 1, `fb_reg_datetime` = '$reg_datetime' WHERE id = $user_id");
					} else {
						$res = mysqli_query($link, "UPDATE users set `verif_code` = NULL, `verif_code_exp_datetime` = NULL, `facebook_connect` = 1, `fb_reg_datetime` = '$reg_datetime' WHERE id = $user_id");
					}
					$fetch['facebook_connect'] = 1;
					$fetch['fb_reg_datetime'] = $reg_datetime;
				}
				if($connect == "g" && $fetch['google_connect'] == 0)
				{
					if($fetch['verif_account'] == 0) {
					$res = mysqli_query($link, "UPDATE users set `verif_account` = 1, `verif_code` = NULL, `verif_code_exp_datetime` = NULL, `verif_datetime` = '$reg_datetime', `google_connect` = 1, `g_reg_datetime` = '$reg_datetime' WHERE id = $user_id");
					} else {
						$res = mysqli_query($link, "UPDATE users set `verif_code` = NULL, `verif_code_exp_datetime` = NULL, `google_connect` = 1, `g_reg_datetime` = '$reg_datetime' WHERE id = $user_id");
					}
					
					$fetch['google_connect'] = 1;
					$fetch['g_reg_datetime'] = $reg_datetime;
				}
				if($connect == "t" && $fetch['t_connect'] == 0)
				{
					if($fetch['verif_account'] == 0) {
					$res = mysqli_query($link, "UPDATE users set `verif_account` = 1, `verif_code` = NULL, `verif_code_exp_datetime` = NULL, `verif_datetime` = '$reg_datetime', `t_connect` = 1, `t_reg_datetime` = '$reg_datetime' WHERE id = $user_id");
					} else {
						$res = mysqli_query($link, "UPDATE users set `verif_code` = NULL, `verif_code_exp_datetime` = NULL, `t_connect` = 1, `t_reg_datetime` = '$reg_datetime' WHERE id = $user_id");
					}
					
					$fetch['t_connect'] = 1;
					$fetch['t_reg_datetime'] = $reg_datetime;
				}
				
				if($fetch['pin_number'] != NULL)
				{
					$fetch['pin_number'] = sprintf("%04d", $fetch['pin_number']);;
				}
					
				print_r(json_encode($fetch));
			}
			else
			{
				$rand_password = rand(1000, 9999).rand(10, 99);
				$password 	= md5($rand_password);
				
				if($connect == "fb")
				{
					$sql = "INSERT INTO `users`(`first_name`, `last_name`, `email`, `password`, `verif_account`, `verif_datetime`, `facebook_connect`, `fb_reg_datetime`, `status`) VALUES ('$first_name', '$last_name', '$email', '$password', '1', '$reg_datetime', '1', '$reg_datetime', '$status')";
				}
				if($connect == "g")
				{
					$sql = "INSERT INTO `users`(`first_name`, `last_name`, `email`, `password`, `verif_account`, `verif_datetime`, `google_connect`, `g_reg_datetime`, `status`) VALUES ('$first_name', '$last_name', '$email', '$password', '1', '$reg_datetime', '1', '$reg_datetime', '$status')";
				}
				if($connect == "t")
				{
					$sql = "INSERT INTO `users`(`first_name`, `last_name`, `email`, `password`, `verif_account`, `verif_datetime`, `t_connect`, `t_reg_datetime`, `status`) VALUES ('$first_name', '$last_name', '$email', '$password', '1', '$reg_datetime', '1', '$reg_datetime', '$status')";
				}
				
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
						<title>Account created | Wopadu</title>
						</head>
						
						<body>
						<table dir="ltr">
							<tbody>
								<tr>
									<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#75522D">Wopadu account</td>
								</tr>
								<tr>
									<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#18633A">Your password for wopadu account has been generated.</td>
								</tr>
								<tr>
									<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Please use your email at Wopadu account to login <a dir="ltr" style="color:#2672ec;text-decoration:none" href="mailto:'.$email.'" target="_blank">'.$email.'</a>.</td>
								</tr>
								<tr>
									<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Here is your password: <span style="font-family:\'Segoe UI Bold\',\'Segoe UI Semibold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:14px;font-weight:bold;color:#2a2a2a">'.$rand_password.'</span></td>
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
					
					if($fetch['pin_number'] != NULL)
					{
						$fetch['pin_number'] = sprintf("%04d", $fetch['pin_number']);;
					}
						
					print_r(json_encode($fetch));
				}
				else
				{
					 print_r('4');	//Something went wrong, Query error
					 exit;
				}			 
			}
		}
		else
		{
			print_r('3');   // Something went wrong, Query Error
			exit;
		}
	}
}