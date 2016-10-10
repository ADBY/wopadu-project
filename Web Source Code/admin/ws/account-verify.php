<?php

// user id = user id or mayb email - 2016-09-30
/*
 *      Send Verify Account Email
 *      URL: http://localhost:8080/wopadu/ws/account-verify.php?ws=1&user_id=1&send_email=1
 * 
 *		Verify Account
 * 		URL: http://localhost:8080/wopadu/ws/account-verify.php?ws=1&user_id=1&verif_code=WIFX2Y
*/


header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";

if(isset($_REQUEST["user_id"]) && isset($_REQUEST["send_email"]) && $_REQUEST["send_email"] == 1)
{
    $user_id       = mysqli_real_escape_string($link, $_REQUEST['user_id']);

    if($user_id == "")
    {
        print_r('1');   // Please insert all details
        exit;
    }
    else
    {
		if(is_numeric($user_id))
		{
        	$sql = "select email, verif_code, verif_code_exp_datetime from users WHERE id='$user_id' ";
		}
		else
		{
			$sql = "select email, verif_code, verif_code_exp_datetime from users WHERE email='$user_id' ";
		}
		
        $result = mysqli_query($link, $sql);

        if(mysqli_num_rows($result) == 0)
        {
            print_r('2');     //User doesn't exists
            exit;
        }
        else
        {
            $row = mysqli_fetch_assoc($result);
            
            $email      = $row['email'];
            $verif_code = $row['verif_code'];
            $exp_time   = $row['verif_code_exp_datetime'];

            if($verif_code == ""  || $verif_code == NULL)
            {
                $verif_code	= verifCodeGenNum();
                $exp_time       = date('Y-m-d H:i:s', strtotime("+2 hours"));
            }
            else
            {
				if($exp_time > date('Y-m-d H:i:s'))
				{
					$exp_time       = date('Y-m-d H:i:s', strtotime("+2 hours"));
				}
				else
				{
					$verif_code	= verifCodeGenNum();
					$exp_time       = date('Y-m-d H:i:s', strtotime("+2 hours"));
				}
                
            }
            
            $sql ="UPDATE users SET verif_code = '$verif_code', verif_code_exp_datetime = '$exp_time' WHERE id='$user_id'";

            if(!mysqli_query($link, $sql))
            {
                print_r('3');	// Something went wrong, Query error
                exit;
            }
            else
            {				
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
                                                <td style="padding:0;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">This code will expire in 2 hours.</td>
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

                /*$header 	= "From:".$admin_email." \r\n";
                $header 	.= "MIME-Version: 1.0\r\n";
                $header 	.= "Content-type: text/html\r\n";*/
				
				$header = "MIME-Version: 1.0" . "\r\n";
				$header .= "Content-type: text/html; charset=iso-8859-1" . "\r\n";
				$header .= "From: Wopadu <".$admin_email. "> \r\n" .
				"Reply-To: Wopadu <".$admin_email. "> \r\n" .
				"X-Mailer: PHP/" . phpversion();

               if(mail ($to, $subject, $message, $header))
               {
                   print_r('OK');   // Mail sent 
				   exit;
               }
               else
               {
                   print_r('4');    // Email send error, Please retry
				   exit;
               }
            }
        }
    }
}
else if(isset($_REQUEST["user_id"]) && isset($_REQUEST["verif_code"]))
{
    $user_id       = mysqli_real_escape_string($link, $_REQUEST['user_id']);
    $verif_code    = mysqli_real_escape_string($link, $_REQUEST['verif_code']);

    if($user_id == "" || $verif_code == "")
    {
        print_r('1');   // Please insert all details
        exit;
    }
    else
    {
		if(is_numeric($user_id))
		{
        	$sql = "select id, email, verif_code, verif_code_exp_datetime from users WHERE id='$user_id' ";
		}
		else
		{
			$sql = "select id, email, verif_code, verif_code_exp_datetime from users WHERE email='$user_id' ";
		}

       // $sql = "select email, verif_account, verif_code, verif_code_exp_datetime from users WHERE id='$user_id' ";

        $result = mysqli_query($link, $sql);
		
		if(!$result)
		{
			print_r('2');     // Something went wrong, Query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($result) == 0)
			{
				print_r('3');     // User doesn't exists
				exit;
			}
			else
			{
				$row = mysqli_fetch_assoc($result);
				
				$user_id			= $row['id'];	
				$verif_account 		= $row['verif_account'];
				$exp_time 			= $row['verif_code_exp_datetime'];
	
				if($verif_account == 1)
				{
					print_r('4');	// User is already verified
					exit;
				}
				else
				{
					$email 		= $row['email'];
					$datetime 	= currentTime();
	
					if($verif_code != $row['verif_code'])
					{
						print_r('5');	// Verif code does not match
					}
					else if($exp_time < $datetime)
					{
						print_r('6');	// Verif code has been expired
					}
					else
					{
						$sql ="UPDATE users SET verif_account = 1, verif_code = NULL, verif_code_exp_datetime = NULL, verif_datetime = '$datetime' WHERE id='$user_id'";
	
						if(mysqli_query($link, $sql))
						{
							$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
							$row_email = mysqli_fetch_assoc($res_email);
							
							$admin_email = $row_email['value'];

							$to 		= $email;

							$subject 	= "Wopadu - Email is verified";

							$message 	= '
								<!doctype html>
									<head>
										<meta charset="utf-8">
										<title>Account Verified</title>
									</head>
									<body>
										<table dir="ltr">
											<tbody>
												<tr>
														<td style="padding:0;font-family:\'Segoe UI Semibold\',\'Segoe UI Bold\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:17px;color:#551570">Wopadu account</td>
												</tr>
												<tr>
														<td style="padding:0;font-family:\'Segoe UI Light\',\'Segoe UI\',\'Helvetica Neue Medium\',Arial,sans-serif;font-size:41px;color:#CE1764">Email has been verified successfully</td>
												</tr>
												<tr>
														<td style="padding:0;padding-top:25px;font-family:\'Segoe UI\',Tahoma,Verdana,Arial,sans-serif;font-size:14px;color:#2a2a2a">Your verified email is <a dir="ltr" style="color:#2672ec;text-decoration:none" href="mailto:'.$email.'" target="_blank">'.$email.'</a>.</td>
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
								</html>
								';
	
							/*$header 	= "From:".$admin_email." \r\n";
							$header 	.= "MIME-Version: 1.0\r\n";
							$header 	.= "Content-type: text/html\r\n";*/
							
							$header = "MIME-Version: 1.0" . "\r\n";
							$header .= "Content-type: text/html; charset=iso-8859-1" . "\r\n";
							$header .= "From: Wopadu <".$admin_email. "> \r\n" .
							"Reply-To: Wopadu <".$admin_email. "> \r\n" .
							"X-Mailer: PHP/" . phpversion();
	
							$sentmail = mail ($to, $subject, $message, $header);
							
							$result_data = json_encode(['flag' => 'OK', 'user_id' => $user_id]);
							print_r($result_data);	//Account is verified successfully
							exit;
						}
						else
						{
							print_r('7');	//Something went wrong, Query error
							exit;
						}
					}
				}
			}
		}
    } 	
}
else
{
    print_r('0'); // Variables not set
    exit;	
}
?>