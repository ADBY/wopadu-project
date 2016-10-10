<?php

/*
*	Forgot Pin
* 	URL: 
*	http://localhost:8080/wopado/ws/forgot-pin.php?email=shirishm.makwana@gmail.com
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

include("config.php");

if(isset($_REQUEST['email']) )
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
		$result = mysqli_query($link, "select id, first_name, email, pin_number from users where email='$email'");
		
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
				$user_email = $row['email'];
				$user_name = $row['first_name'];
				$pin_number = $row['pin_number'];
				$pin_number = sprintf("%04d", $pin_number);
				
				$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
				$row_email = mysqli_fetch_assoc($res_email);
				
				$admin_email = $row_email['value'];
				
				$to 		= $user_email;
				
				$subject 	= "Wopado - Forgot Security Pin";
				
				$message 	= '
					<!doctype html>
					<head>
					<meta charset="utf-8">
					<title>Forgot Security Pin</title>
					</head>
					
					<body>
					<table dir="ltr">
					<tbody>
						<tr>
							<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#75522D">Wopado account</td>
						</tr>
						<tr>
							<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#C3C48D">Forgot Security Pin</td>
						</tr>
						<tr>
							<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Please use this pin for your Wopado account <a dir="ltr" style="color:#2672ec;text-decoration:none" href="mailto:'.$user_email.'" target="_blank">'.$user_email.'</a>.</td>
						</tr>
						<tr>
							<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Here is your security pin: <span style="font-family:\'Segoe UI Bold\',\'Segoe UI Semibold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:14px;font-weight:bold;color:#2a2a2a">'.$pin_number.'</span></td>
						</tr>
						<tr>
							<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Thanks,</td>
						</tr>
						<tr>
							<td style="padding:0;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">The Wopado team</td>
						</tr>
					</tbody>
					</table>
					</body>
					</html>';
								
				$header 	= "From:".$admin_email." \r\n";
				$header 	.= "MIME-Version: 1.0\r\n";
				$header 	.= "Content-type: text/html\r\n";
				
				$sentmail = mail ($to, $subject, $message, $header);
				print_r('OK');	//	Email has been sent with pin number.
				exit;
			}
		}
	}
}
else
{
	print_r('0');	//Variable not set
	exit;
}