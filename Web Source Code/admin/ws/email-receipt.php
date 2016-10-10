<?php
/*
*	Email Receipt
* 	URL: http://localhost:8080/wopadu/ws/email-receipt.php?ws=1&order_id=1
*/

//header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";
require_once "define.php";

if(!isset($_REQUEST['order_id']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$order_id = mysqli_real_escape_string($link, $_REQUEST['order_id']);
	
	$result = mysqli_query($link, "SELECT O.*, S.store_name, S.store_branch, S.address, S.tax_invoice, S.abn_number, S.image, U.email FROM orders as O INNER JOIN stores as S ON O.store_id = S.id INNER JOIN users as U ON U.id = O.user_id WHERE O.id = '$order_id'");
	
	if(!$result)
	{
		print_r('1'); 	// Something went wrong, Query error
		exit;
	}
	else
	{
		if(mysqli_num_rows($result) == 0)
		{
			print_r('2');	// No orders found
			exit;
		}
		else
		{
			$row = mysqli_fetch_assoc($result);
			
			$row['status'] = order_status($row['status']);
			if($row['image'] != ""){
				$row['image'] = $store_image.$row['image'];
			}
			
			$res_order_details = mysqli_query($link, "SELECT O.*, I.item_name FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = '".$row['id']."'");
			if(!$res_order_details)
			{
				print_r('3'); 	// Something went wrong, Query error
				exit;
			}
			else
			{
				if(mysqli_num_rows($res_order_details) == 0)
				{
					print_r('4'); 	// Order details not found
					exit;
				}
				else
				{
					$items = array();
					while($row_order_detail = mysqli_fetch_assoc($res_order_details))
					{
						$item_options = $row_order_detail['item_options_id'];
						
						if($item_options)
						{
							$options = mysqli_query($link, "SELECT  IOM.id as item_main_id, option_name, IOS.id as item_sub_id, sub_name, sub_amount FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)");
							if($options)
							{
								$temp_options = [];
								while($options_res = mysqli_fetch_assoc($options))
								{
									$temp_options[] = $options_res;
								}
								$row_order_detail['item_options'] = $temp_options;
							}
							else
							{
								$row_order_detail['item_options'] = array();
							}							
						}
						else
						{
							$row_order_detail['item_options'] = array();
						}
						
						$item_variety_id = $row_order_detail['item_variety_id'];
						
						if($item_variety_id != NULL)
						{
							$item_variety_details = mysqli_query($link, "SELECT variety_name, variety_price FROM item_variety WHERE `id` = '".$item_variety_id."' and item_id = '".$row_order_detail['item_id']."'");
							
							if($item_variety_details)
							{
								$res_item_variety_details = mysqli_fetch_assoc($item_variety_details);
								$row_order_detail['item_variety_name'] = $res_item_variety_details['variety_name'];
								//$order_details[$i]['item_variety_price'] = $res_item_variety_details['variety_price'];
								$row_order_detail['item_amount'] = $res_item_variety_details['variety_price'];
							}
						}
									
						$items[] = $row_order_detail;
					}
					$row['items'] = $items;
				}
			}

			$row['invoice_number'] = $row['invoice_number'];
			$orders = $row;	// Orders details array
			
			$res_email = mysqli_query($link, "SELECT value from site_info WHERE id = 1 and name = 'contact_email'");
			$row_email = mysqli_fetch_assoc($res_email);
			
			$res_user = mysqli_query($link, "SELECT id, first_name, last_name, email, mobile FROM users WHERE `id` ='".$row['user_id']."'");
			
			$row_user = mysqli_fetch_assoc($res_user);
			
			$admin_email = $row_email['value'];

			$to 		= $orders['email'];
			//$to 		= "shirishm.makwana@gmail.com";
			
			$subject 	= "Wopadu - Receipt Email";
			
			/* <table width="600" style="margin:0 auto; border:3px solid #000000;">*/
			
			$message = '
			
			<!doctype html>
			<html>
			<head>
			<meta charset="utf-8">
			<title>Receipt Email</title>
			</head>
			<body style="font-family:verdana; font-size:14px; margin-top:20px">
			<table style="margin:0 auto; border:3px solid #000000;">
				<tr>
					<td style="text-align:center"><strong>'.$orders['store_name'].'</strong> <br />
						'.$orders['store_branch'].', '.$orders['address'].' &nbsp;<br />
						Tax Invoice Number: '.$orders['invoice_number'].'<br />
						ABN: '.$orders['abn_number'].'<br />
						Order Number: '.$orders['order_number'].'<br />
						Date: '.date('d-m-Y h:i A', strtotime($orders['n_datetime'])).'<br />
						
					</td>
				</tr>
				<tr>
					<td>';
				$total_tax = 0;
                $message .= '<table style="width:100%;border: none;padding: 10px;margin: 4px;"><tbody>';
					
                $v = 1; foreach($orders['items'] as $item) {
                
					$message .='<tr>
                        	<td style="padding:5px" valign="top">'.$v.'.</td>
                            <td style="padding:5px">'.$item['quantity'].'<strong>x</strong> '.$item['item_name']. ' ($'.$item['item_amount'].')';
						
						foreach($item['item_options'] as $option_1)
						{
							$message .= '<p style="margin:5px 0 5px 20px">'.$option_1['option_name'].' '.$option_1['sub_name'].' ($'.$option_1['sub_amount'].')</p>';
						}
                        
						$tax_for_this_item = (($item['final_amount'] * $item['tax_percentage']) / 100);
						$total_tax += $tax_for_this_item;
						
						$message .= '<td style="padding:5px; text-align:right" valign="top">$'.number_format((float)$item['final_amount'], 2, '.', '').'</td>
                        </tr>';
                        $v++; } 
                $message .= '
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="3"><strong>Grand Total: </strong> <span style="float:right">$'.number_format((float)$orders['total_amount'], 2, '.', '').'</span></td>
					</tr>
					
					<tr>
						<td colspan="3"><strong>GST (included in total): </strong> <span style="float:right">$'.number_format((float)$total_tax, 2, '.', '').'</span></td>
					</tr>
				</tbody>
				</table>';
				
				$message .= '</td></tr>
					
					<tr><td style="padding-left: 20px;padding-bottom: 20px;">Thank You.</td></tr>
				
			</table>
			</body>
			</html>
			';
			
			//echo $message;
			
			$header 	= "From:".$admin_email." \r\n";
			$header 	.= "MIME-Version: 1.0\r\n";
			$header 	.= "Content-type: text/html\r\n";
			
			if(mail ($to, $subject, $message, $header))
			{
				print_r('OK');   // Email receipt is sent to you
				exit;
			}
			else
			{
				print_r('5');    // Email send error, Please retry
				exit;
			}
		}
	}
}