<?php

/*
*	Share Wopadu Application
* 	URL: http://localhost:8080/wopadu/ws/share-app.php?user_id=1&email=shirishm.makwana@gmail.com&desc=Hellloooooooooo
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";
require_once "define.php";

if(!isset($_REQUEST["user_id"]) || !isset($_REQUEST["email"]) || !isset($_REQUEST["desc"]))
{
	print_r('0'); //Variables not set
	exit;	
}
else
{
	$user_id 			= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$shared_to_email	= mysqli_real_escape_string($link, $_REQUEST['email']);
	$desc 				= mysqli_real_escape_string($link, $_REQUEST['desc']);
		
	if($user_id == "" || $shared_to_email == "")
	{
		 print_r('1');   // Please insert all details
		 exit;
	}
	else if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i", $shared_to_email))
	{
		print_r('2');   //Email-ID is invalid
		exit;
	}
	else
	{
		$sql = "SELECT id, first_name, email FROM users WHERE id = '" . $user_id . "'";
		$result = mysqli_query($link, $sql);
		if(!$result)
		{
			print_r('3');   // Something went wrong, Query Error
			exit;
		}
		else
		{		
			if(mysqli_num_rows($result) == 0)
			{
				print_r('4');	// User id does not found
				exit;
			}
			else
			{						
				$row_user = mysqli_fetch_assoc($result);

				$user_first_name = $row_user['first_name'];
				$user_email = $row_user['email'];
				
				$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
				$row_email = mysqli_fetch_assoc($res_email);
				
				$admin_email = $row_email['value'];
			
				
				$to 		= $shared_to_email;
				
				$subject 	= "Wopadu - Your friend has invited you";
				
				$message 	= '
				<!doctype html>

				<head>
				<meta charset="utf-8">
				<title>Wopadu - Invitation</title>
				</head>
				
				<body>
				<div>
					<table dir="ltr">
						<tbody>
							<tr>
								<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#551570">Wopadu account</td>
							</tr>
							<tr>
								<td style="padding:10px 0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#CE1764">'. $user_first_name.' has sent an invitation to you.</td>
							</tr>
							<tr>
								<td style="padding:10px 0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;">Dear '.$shared_to_email.',</td>
							</tr>
							<tr>
								<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Email address of your friend is <a dir="ltr" style="text-decoration:none" href="mailto:'.strtolower($user_email).'" target="_blank">'.strtolower($user_email).'</a>.</td>
							</tr>';
								
								if($desc != "")
								{
									$message .= '<tr>
								<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">'.$desc.'</td>
							</tr>';
								}
								
					$e_check = mysqli_query($link, "SELECT id, email from users WHERE email = '".$shared_to_email."'");
					if($e_check)
					{

						if(mysqli_num_rows($e_check) == 0)
						{
							$message .=
								'<tr>
									<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Download Wopadu application <span style="color:#ff9000;text-decoration:none" href="#" target="_blank">here</span>.</td>
								</tr>
								<tr>
									<td>
										<table width="" border="0" cellpadding="3" cellspacing="0" style="">
											<tbody>
												<tr>
													<td colspan="1" height="10" style="font-size:10px;line-height:10px">&nbsp;</td>
												</tr>
												<tr>
													<td align="right" valign="center">
														<a href="http://www.google.com" style="text-decoration:none" target="_blank">
															<table height="40" width="125" border="0" cellpadding="0" cellspacing="0" style="background-color:#666666;border-collapse:collapse;border-radius:3px;border-color:#666666;margin-left:auto;margin-right:auto;line-height:1">
																<tbody>
																	<tr>
																		<td width="36" height="36" align="center" valign="center">
																			<img width="25" height="25" src="'.$website_url.'/images/appstore.png" border="0" style="text-decoration:none;display:block;outline:none;border-radius:3px">
																		</td>
																		<td align="left" style="padding-left:0;font-family:helvetica,sans-serif;color:#ffffff;padding-top:5px;padding-bottom:5px">
																			<span style="font-size:10px;color:#c0c0c0">Available on the</span><br>
																			<b><span style="font-size:13px">App Store</span></b>
																		</td>
																	</tr>
																</tbody>
															</table>
														</a>
													</td>
													<td>
														<a href="http://www.google.com" style="text-decoration:none" target="_blank">
															<table height="40" width="125" border="0" cellpadding="0" cellspacing="0" style="background-color:#666666;border-collapse:collapse;border-radius:3px;border-color:#666666;margin-left:auto;margin-right:auto;line-height:1">
																<tbody>
																	<tr>
																		<td width="36" height="36" align="center" valign="center">
																			<img width="25" height="25" src="'.$website_url.'/images/googleplay.png" border="0" style="text-decoration:none;display:block;outline:none;border-radius:3px">
																		</td>
																		<td align="left" style="padding-left:0;font-family:helvetica,sans-serif;color:#ffffff;padding-top:5px;padding-bottom:5px">
																			<span style="font-size:10px;color:#c0c0c0">Available on</span><br>
																			<b><span style="font-size:13px">Google Play</span></b>
																		</td>
																	</tr>
																</tbody>
															</table>
														</a>
													</td>
												</tr>
												<tr>
													<td colspan="1" height="10" style="font-size:10px;line-height:10px">&nbsp;</td>
												</tr>
											</tbody>
					
										</table>
									</td>
								</tr>';
						}
					}
							$message 	.= '<tr>
											<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Thanks,</td>
									</tr>
									<tr>
											<td style="padding:0;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">The Wopadu team</td>
									</tr>
						</tbody>
					</table>
				</div>
				</body>
				</html>
				';
				
				//echo $message;
				//exit;          
				$header 	= "From:".$admin_email." \r\n";
				$header 	.= "MIME-Version: 1.0\r\n";
				$header 	.= "Content-type: text/html\r\n";
				
				$sentmail = mail($to, $subject, $message, $header);
				
				if(!$sentmail)
				{
					print_r('5');	//Error sending email
					exit;
				}
				else
				{
					print_r('OK');	//Application is shared successfully
					exit;
				}
			}
		}
	} 	
}

?>