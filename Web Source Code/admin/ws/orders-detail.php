<?php

/*
*	Order Detail
* 	URL: http://localhost:8080/wopadu/ws/orders-detail.php?ws=1&order_id=1&lang=hi
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "define.php";
require_once "functions.php";

if(isset($_REQUEST['lang'])) {
	$language = getLanguage($link, $_REQUEST['lang']);
}

if(!isset($_REQUEST['order_id']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$order_id = mysqli_real_escape_string($link, $_REQUEST['order_id']);
	
	$lang_sql = "";
	if(isset($language)) {
		$lang_sql = ", S.store_name_".$language['language_lc'].", S.description_".$language['language_lc']."";
	}
	
	$result = mysqli_query($link, "SELECT O.*, S.store_name, S.store_branch, S.address, S.description, S.tax_invoice, S.abn_number, S.image".$lang_sql." FROM orders as O INNER JOIN stores as S ON O.store_id = S.id WHERE O.id = '$order_id'");

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
			
			if(isset($language))
			{
				$store_name 		= $row['store_name'];
				$description 		= $row['description'];
				$store_name_lang 	= $row['store_name_'.$language['language_lc']];
				$description_lang 	= $row['description_'.$language['language_lc']];
				
				if($store_name_lang != "")
				{
					$row['store_name'] = $store_name_lang;
				}
				if($description_lang != "")
				{
					$row['description'] = $description_lang;
				}
				unset($row['store_name_'.$language['language_lc']]);
				unset($row['description_'.$language['language_lc']]);
				
			}
			
			$row['status'] = order_status($row['status']);
			if($row['image'] != ""){
				$row['image'] = $store_image.$row['image'];
			}

			$lang_sql = "";
			if(isset($language)) {
				$lang_sql = ", I.item_name_".$language['language_lc'];
			}
			
			$res_order_details = mysqli_query($link, "SELECT O.*, I.item_name".$lang_sql." FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = '".$row['id']."'");
			
			//$res_order_details = mysqli_query($link, "SELECT O.*, I.item_name FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = '".$row['id']."'");
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
						if(isset($language))
						{
							$item_name 				= $row_order_detail['item_name'];
							$item_name_lang 		= $row_order_detail['item_name_'.$language['language_lc']];
							
							if($item_name_lang != "")
							{
								$row_order_detail['item_name'] = $item_name_lang;
							}
							unset($row_order_detail['item_name_'.$language['language_lc']]);
						}
						
						$item_options = $row_order_detail['item_options_id'];
						$item_variety_id = $row_order_detail['item_variety_id'];
						
						if($item_options != "")
						{
							//$ex_options = explode(",", $item_options);
							//$qqq = "SELECT id, option_name, description, amount FROM item_options WHERE item_id = '".$row_order_detail['item_id']."' and id IN ($item_options)";
							
							//$qqq = "SELECT  IOM.id as item_main_id, option_name, IOS.id as item_option_sub_id, sub_name, sub_amount FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)";
							$lang_sql = "";
							if(isset($language)) {
								$lang_sql = ", option_name_".$language['language_lc'].", sub_name_".$language['language_lc'];
							}
						
							$qqq = "SELECT  IOM.id as item_main_id, option_name, IOS.id as item_option_sub_id, sub_name, sub_amount".$lang_sql." FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)";
							
							$res_option = mysqli_query($link, $qqq);
							if(!$res_option)
							{
								// do not give error
							}
							else
							{
								$options = array();
								while($row_option = mysqli_fetch_assoc($res_option))
								{
									if(isset($language))
									{
										$option_name 		= $row_option['option_name'];
										$sub_name 			= $row_option['sub_name'];
										$option_name_lang 	= $row_option['option_name_'.$language['language_lc']];
										$sub_name_lang 		= $row_option['sub_name_'.$language['language_lc']];
										
										if($option_name_lang != "")
										{
											$row_option['option_name'] = $option_name_lang;
										}
										if($sub_name_lang != "")
										{
											$row_option['sub_name'] = $sub_name_lang;
										}
										unset($row_option['option_name_'.$language['language_lc']]);
										unset($row_option['sub_name_'.$language['language_lc']]);
									}
									
									$options[] = $row_option;
								}
								$row_order_detail['item_options'] = $options;
							}							
						}
						
						if($item_variety_id != NULL)
						{
							//$qqq = "SELECT variety_name, variety_price FROM item_variety WHERE `id` = '".$item_variety_id."'";							
							$lang_sql = "";
							if(isset($language)) {
								$lang_sql = ", variety_name_".$language['language_lc'];
							}
							$qqq = "SELECT variety_name, variety_price".$lang_sql." FROM item_variety WHERE `id` = '".$item_variety_id."'";
							$item_variety_details = mysqli_query($link, $qqq);
							
							if(!$item_variety_details)
							{
								// do not give error
							}
							else
							{
								$row_option = mysqli_fetch_assoc($item_variety_details);
								$row_order_detail['item_variety_name'] = $row_option['variety_name'];
								$row_order_detail['item_amount'] = $row_option['variety_price'];
								if(isset($language))
								{
									if($row_option['variety_name_'.$language['language_lc']] != "")
									{
										$row_order_detail['item_variety_name'] = $row_option['variety_name_'.$language['language_lc']];
									}
									//$row_order_detail['item_variety_name_'.$language['language_lc']] = $row_option['variety_name_'.$language['language_lc']];
								}
							}
						}

						$items[] = $row_order_detail;
					}
					$row['items'] = $items;
				}
			}
			$row['invoice_number'] = "INV".$row['invoice_number'];
			$orders = $row;	// Orders details array

			//print_r(json_encode($orders));
			print_r(json_encode($orders, JSON_UNESCAPED_UNICODE));
		}
	}
}