<?php

/*
*	Feedback Email
* 	URL: http://localhost:8080/wopadu/ws/feedback-email.php?ws=1&user_id=1&content=this-is-the-message
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

include("config.php");

if(!isset($_REQUEST['ws']) || !isset($_REQUEST['user_id']) || !isset($_REQUEST['content']) )
{
	print_r('0');	// Variable not set
	exit;
}
else if($_REQUEST['user_id'] == "" || $_REQUEST['content'] == "")
{
	print_r('1'); 	//	Values can't be empty
	exit;
}
else
{
	$content = mysqli_real_escape_string($link, $_REQUEST['content']);
	$user_id = mysqli_real_escape_string($link, $_REQUEST['user_id']);
	
	$result = mysqli_query($link, "select id, first_name, last_name, email from users where id='$user_id'");
	
	if(!$result)
	{
		print_r('2');     // Something went wrong, query error
		exit;
	}
	else
	{
		if(mysqli_num_rows($result) == 0)
		{
			print_r('3');     // User id does not exists
			exit;
		}
		else
		{	
			$row_user = mysqli_fetch_assoc($result);
			
			$user_email = $row_user['email'];
			$user_first_name = $row_user['first_name'];
			$user_last_name = $row_user['last_name'];
			
			$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
			$row_email = mysqli_fetch_assoc($res_email);
			
			$to = $row_email['value'];
					
			$subject 	= "Wopadu - Feedback from App";
			
			$message 	= '
				<!doctype html>
				<head>
				<meta charset="utf-8">
				<title>Feedback from App</title>
				</head>
				
				<body>
				<table dir="ltr">
				<tbody>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#551570">Wopadu Application</td>
					</tr>
					<tr>
						<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#CE1764">Feedback Email</td>
					</tr>
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Name : <br />'.$user_first_name.' '.$user_last_name.'</td>
					</tr>
					<tr>
						<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Message: <br />'.$content.'</td>
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
			
			//echo $message;
					
			$header 	= "From:".$user_email." \r\n";
			$header 	.= "MIME-Version: 1.0\r\n";
			$header 	.= "Content-type: text/html\r\n";
			
			$sentmail = mail ($to, $subject, $message, $header);
			print_r('OK');	//	Email has been sent
			exit;
		}
	}
	
}