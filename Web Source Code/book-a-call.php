<?php

$link = mysqli_connect("localhost", "root", "wopadoroot", "wopado");

if(mysqli_connect_errno()) 
{
 	echo "Something went wrong, Please try again later";
	exit;
}

if(isset($_POST['f']) && isset($_POST['e']) && isset($_POST['p']))
{
	$fname 		= $_POST['f'];
	$email 		= $_POST['e'];
	$phone 		= $_POST['p'];
	
	if($fname == "") 
	{
		$error = "Please enter first name";	
	}
	else if($email == "") 
	{
		$error = "Please enter email";	
	}
	else if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i", $email))
	{
      	$error = "Email is invalid!";	
	}
	else if($phone == "") 
	{
		$error = "Please enter phone number";	
	}
	else if(!preg_match("/^([0-9]{8,})$/i", $phone))
	{
      	$error = "Phone number is invalid!";	
	}
	else
	{
		
		$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
		$row_email = mysqli_fetch_assoc($res_email);
	
		$admin_email = $row_email['value'];		
		
		//$to 		= $admin_email;
		//$to = "shirishm.makwana@gmail.com";
		$to = "info@wopadu.com";
		
		$subject 	= "Contact from wopadu";
		
		$message 	= '

			<!doctype html>
			<html>
			<head>
			<meta charset="utf-8">
			<title>Wopadu</title>
			</head>	

			<body>
			<table dir="ltr">
				<tbody>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#551570">Wopadu</td>
					</tr>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#CE1764">Contact From Wopadu.com </td>
					</tr>							
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:18px;color:#2a2a2a">First Name : '.$fname.'</td>
					</tr>
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:18px;color:#2a2a2a">Email : <a dir="ltr" style="color:#2672ec;text-decoration:none" href="mailto:'.$_POST['email'].'" target="_blank">'.$email.'</a>.</td>
					</tr>
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:18px;color:#2a2a2a">Phone Number : '.$phone.'</td>
					</tr>
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">From,</td>
					</tr>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Wopadu Teams</td>
					</tr>
				</tbody>
			</table>
			</body>
			</html>';
			
		//echo $message;
		//exit;
		$header 	= "From:".$admin_email." \r\n";
		$header 	.= "MIME-Version: 1.0\r\n";
		$header 	.= "Content-type: text/html\r\n";
		
		$sentmail = mail ($to, $subject, $message, $header);				
		
		$error = 1;
	}
}
else
{
	$error = "Something went wrong, Please try again";
}

echo $error;
exit;