<?php

/*
*	Get menu items of store
* 	URL: http://localhost:8080/wopadu/ws/store-items.php?ws=1&category_id=7
*/

header("Content-type: text/plain");		//Convert to plain text

require_once "config.php";
require_once "define.php";

$curr_date = date('Y-m-d H:i:s');
$curr_time = date("H:i:s");

if(!isset($_REQUEST['ws']) || !isset($_REQUEST['category_id']))
{
	print_r('0');	//	Variables not set
	exit;
}
else
{
	$category_id = $_REQUEST['category_id'];
	
	if($category_id == "")
	{
		print_r('1');	//	Category id can't be empty
		exit;
	}
	else
	{
		$result = mysqli_query($link, "SELECT * from items WHERE category_id = '$category_id' and status = 1");
		
		if(!$result)
		{
			print_r('2');	// Something went wrong, Please try again
			exit;
		}
		else
		{
			if(mysqli_num_rows($result) == 0)
			{
				print_r('3');	// No items found
				exit;
			}
			else
			{
				$items = array();
				
				
				/******** Check category discount starts **********/
				
				$category_discount = [];
				
				$cat_res_d1 = mysqli_query($link, "SELECT * FROM category_discount WHERE category_id = '$category_id'");
				if(mysqli_num_rows($cat_res_d1) > 0)
				{
					
					while($cat_row_d1 = mysqli_fetch_assoc($cat_res_d1))
					{
						
						$discount_id 			= $cat_row_d1['discount_id'];
						$promotion_main_type 	= $cat_row_d1['promotion_main_type'];
						
						if($promotion_main_type == 1)
						{
							$cat_res_d2 = mysqli_query($link, "SELECT * FROM `cat_discount_daterange` WHERE id = $discount_id and ('$curr_date' BETWEEN start_date and end_date)");
							
							if(mysqli_num_rows($cat_res_d2) > 0)
							{
								
								$cat_row_d1['discount'] = 'YES';
								$cat_row_d1['discount_main_type'] = 'Based on Daterange';
								
								$cat_row_d2 = mysqli_fetch_assoc($cat_res_d2);
								
								$cat_row_d1['start_date'] 	= $cat_row_d2['start_date'];
								$cat_row_d1['end_date'] 	= $cat_row_d2['end_date'];
								
								$promotion_sub 			= $cat_row_d2['promotion_sub'];
								$promotion_sub_value 	= $cat_row_d2['promotion_sub_value'];
																
								if($promotion_sub == 1)
								{
									$cat_row_d1['discount_type'] = "Discount Percentage";
								}
								if($promotion_sub == 2)
								{
									$cat_row_d1['discount_type'] = "Fixed Price";
								}
								
								$cat_row_d1['discount_value'] = $promotion_sub_value;
							}
							else
							{
								$cat_row_d1['discount'] = 'NO';
							}
						}
						else if($promotion_main_type == 2)
						{
							$cat_res_d2 = mysqli_query($link, "SELECT * FROM `cat_discount_days` WHERE id = $discount_id and day like '%,".date('N').",%'");
							if(mysqli_num_rows($cat_res_d2) > 0)
							{
								$cat_row_d1['discount'] = 'YES';
								$cat_row_d1['discount_main_type'] = 'Based on Days';
								$cat_row_d2 = mysqli_fetch_assoc($cat_res_d2);
								
								$all_day 				= $cat_row_d2['all_day'];
								$time_start 			= $cat_row_d2['time_start'];
								$time_end 				= $cat_row_d2['time_end'];
								$promotion_sub 			= $cat_row_d2['promotion_sub'];
								$promotion_sub_value 	= $cat_row_d2['promotion_sub_value'];
								
								if($all_day == 0)
								{
									$cat_row_d1['is_all_day_discount'] = "NO";
									$cat_row_d1['discount_start_time'] = $time_start;
									$cat_row_d1['discount_end_time'] 	= $time_end;									
								}
								else if($all_day == 1)
								{
									$cat_row_d1['is_all_day_discount'] = "YES";
								}
				
								if($promotion_sub == 1)
								{
									$cat_row_d1['discount_type'] = "Discount Percentage";
								}
								if($promotion_sub == 2)
								{
									$cat_row_d1['discount_type'] = "Fixed Price";
								}
								
								$cat_row_d1['discount_value'] = $promotion_sub_value;
							}
							else
							{
								$cat_row_d1['discount'] = 'NO';
							}
						}						
						$category_discount[] = $cat_row_d1;
					}
				
				
					if($category_discount) 
					{
					
					$cat_promotion_main_type_date = [];
					$cat_promotion_main_type_days = [];
					
					foreach($category_discount as $cd)
					{
						if($cd['discount'] == 'YES' && $cd['promotion_main_type'] == 1)
						{
							$cat_promotion_main_type_date[] = $cd;
						}
						else if($cd['discount'] == 'YES' && $cd['promotion_main_type'] == 2)
						{
							$cat_promotion_main_type_days[] = $cd;
						}
					}
					
					$cat_promotion_main_type_date = end($cat_promotion_main_type_date);
					
					$ij = 0;
					
					$str_curr_time = strtotime($curr_time);
					foreach($cat_promotion_main_type_days as $cd)
					{
						if($cd['is_all_day_discount'] == "NO")
						{
							
							$str_start_time = strtotime($cd['discount_start_time']);
							$str_end_time = strtotime($cd['discount_end_time']);
							
							if(($str_curr_time >= $str_start_time) && ($str_curr_time <= $str_end_time))
							{
							}
							else
							{
								unset($cat_promotion_main_type_days[$ij]);
							}
						}
						$ij++;
					}
					$cat_promotion_main_type_days = array_values($cat_promotion_main_type_days);
					$cat_promotion_main_type_days = end($cat_promotion_main_type_days);
					
					$cat_discount_type_fixed = FALSE;
					$cat_discount_type_percentage = FALSE;
					
					if($cat_promotion_main_type_date || $cat_promotion_main_type_days)
					{
						$cat_discount_finale = "YES";
					} else {
						$cat_discount_finale = "NO";
					}
					
					if($cat_promotion_main_type_date)
					{	
						if($cat_promotion_main_type_date['discount_type'] == "Fixed Price") {
							$cat_discount_type_fixed = TRUE;
						} else if($cat_promotion_main_type_date['discount_type'] == "Discount Percentage") {
							$cat_discount_type_percentage = TRUE;
						}
					}
					
					if($cat_promotion_main_type_days)
					{	
						if($cat_promotion_main_type_days['discount_type'] == "Fixed Price") {
							$cat_discount_type_fixed = TRUE;
						} else if($cat_promotion_main_type_days['discount_type'] == "Discount Percentage") {
							$cat_discount_type_percentage = TRUE;
						}
					}
					
					if($cat_promotion_main_type_date && $cat_promotion_main_type_days)
					{
						if($cat_discount_type_fixed == TRUE && $cat_discount_type_percentage == TRUE) {
							if($cat_promotion_main_type_date['discount_type'] == "Fixed Price") {
								$discount_value_fixed = $cat_promotion_main_type_date['discount_value'];
							} else if($cat_promotion_main_type_days['discount_type'] == "Fixed Price") {
								$discount_value_fixed = $cat_promotion_main_type_days['discount_value'];
							}
							
							if($cat_promotion_main_type_date['discount_type'] == "Discount Percentage") {
								$discount_value_percentage = $cat_promotion_main_type_date['discount_value'];
							} else if($cat_promotion_main_type_days['discount_type'] == "Discount Percentage") {
								$discount_value_percentage = $cat_promotion_main_type_days['discount_value'];
							}
							
							$cat_discount_finale_type = "Fixed Price";
							$cat_discount_finale_value = $discount_value_fixed - (($discount_value_fixed * $discount_value_percentage) / 100);
							
						} else if($cat_discount_type_fixed == TRUE) {
							$discount_value_fixed_on_date = $cat_promotion_main_type_date['discount_value'];
							$discount_value_fixed_on_days = $cat_promotion_main_type_days['discount_value'];
							
							$cat_discount_finale_type = "Fixed Price";
							if($discount_value_fixed_on_date > $discount_value_fixed_on_days) {
								$cat_discount_finale_value = $discount_value_fixed_on_date;
							} else {
								$cat_discount_finale_value = $discount_value_fixed_on_days;
							}
							
						} else if($cat_discount_type_percentage == TRUE) {
							
							$discount_value_percentage_on_date = $cat_promotion_main_type_date['discount_value'];
							$discount_value_percentage_on_days = $cat_promotion_main_type_days['discount_value'];
							
							$cat_discount_finale_type = "Discount Percentage";
							if($discount_value_percentage_on_date > $discount_value_percentage_on_days) {
								$cat_discount_finale_value = $discount_value_percentage_on_date;
							} else {
								$cat_discount_finale_value = $discount_value_percentage_on_days;
							}
						}
					}
					else if($cat_promotion_main_type_date)
					{
						if($cat_discount_type_fixed == TRUE) {
							$discount_value_fixed_on_date = $cat_promotion_main_type_date['discount_value'];
							
							$cat_discount_finale_type = "Fixed Price";
							$cat_discount_finale_value = $discount_value_fixed_on_date;
							
						} else if($cat_discount_type_percentage == TRUE) {
							
							$discount_value_percentage_on_date = $cat_promotion_main_type_date['discount_value'];
							
							$cat_discount_finale_type = "Discount Percentage";
							$cat_discount_finale_value = $discount_value_percentage_on_date;
							
						}
					}
					else if($cat_promotion_main_type_days)
					{
						if($cat_discount_type_fixed == TRUE) {
							$discount_value_fixed_on_days = $cat_promotion_main_type_days['discount_value'];
							
							$cat_discount_finale_type = "Fixed Price";
							$cat_discount_finale_value = $discount_value_fixed_on_days;
							
						} else if($cat_discount_type_percentage == TRUE) {
							
							$discount_value_percentage_on_days = $cat_promotion_main_type_days['discount_value'];
							
							$cat_discount_finale_type = "Discount Percentage";
							$cat_discount_finale_value = $discount_value_percentage_on_days;
	
						}
					}
					
					/*echo "<pre>";
					print_r($cat_promotion_main_type_date);
					print_r($cat_promotion_main_type_days);
					print_r("Finle Type ".$cat_discount_finale_type);
					print_r("<br />Value ".$cat_discount_finale_value);
					echo "</pre>";
					exit;*/
					
					}
					else 
					{
						$cat_discount_finale = "NO";
					}
					
				}
				
				
				if($category_discount && $cat_discount_finale == "YES")
				{
					//print_r("Finle Type: ".$cat_discount_finale_type);
					//print_r("<br />Value: ".$cat_discount_finale_value);
				}
				else
				{
					$cat_discount_finale = "NO";
				}
				
				/******** Check category discount ends **********/
				
				while($row = mysqli_fetch_assoc($result))
				{
					$item_id = $row['id'];
					
					if($row['no_of_option'] != 0)
					{	
						$res_option = mysqli_query($link, "SELECT option_main_id FROM item_option WHERE item_id = '$item_id'");
						if(mysqli_num_rows($res_option) > 0)
						{
							$options = array();
							$temp_1 = 0;
							while($row_option = mysqli_fetch_assoc($res_option))
							{
								$res_main_sub_option = mysqli_query($link, "SELECT IOM.id as item_option_main_id, IOS.id as item_option_sub_id, IOM.option_name, IOS.sub_name, IOS.sub_amount FROM item_option_main as IOM INNER JOIN item_option_sub as IOS ON IOS.option_id = IOM.id WHERE IOM.id = ".$row_option['option_main_id']);
								if(mysqli_num_rows($res_main_sub_option) > 0)
								{
									while($row_main_sub_option = mysqli_fetch_assoc($res_main_sub_option))
									{
										$options[$temp_1][] = $row_main_sub_option;
									}
								}
								$temp_1++;
							}
							
							$new = [];
							
							foreach($options as $m)
							{
								$sub = [];
								
								foreach($m as $n)
								{
									$item_option_main_id = $n['item_option_main_id'];
									$item_option_main_name = $n['option_name'];
									
									$sub[] = 
										[
											'item_option_sub_id' => $n['item_option_sub_id'],
											'sub_name' => $n['sub_name'],
											'sub_amount' => $n['sub_amount'], 
										];
								}
								$new[] = 
									[
										'item_option_main_id' => $m[0]['item_option_main_id'],
										'item_option_main_name' => $m[0]['option_name'],
										'options' => $sub,
									];
							}

							$row['options'] = $new;
						}
					}
					
					/******** Item discount Old Starts ***********/
					/*$res_d1 = mysqli_query($link, "SELECT * FROM item_discount WHERE item_id = ".$row['id']);
					if(mysqli_num_rows($res_d1) > 0)
					{
						$row_d1 = mysqli_fetch_assoc($res_d1);
						
						$discount_id 			= $row_d1['discount_id'];
						$promotion_main_type 	= $row_d1['promotion_main_type'];
						
						if($promotion_main_type == 1)
						{

							$res_d2 = mysqli_query($link, "SELECT * FROM `item_discount_daterange` WHERE id = $discount_id and ('$curr_date' BETWEEN start_date and end_date)");
							
							if(mysqli_num_rows($res_d2) > 0)
							{
								$row['discount'] = 'YES';
								$row['discount_main_type'] = 'Based on Daterange';
								$row_d2 = mysqli_fetch_assoc($res_d2);
								
								$promotion_sub 			= $row_d2['promotion_sub'];
								$promotion_sub_value 	= $row_d2['promotion_sub_value'];
																
								if($promotion_sub == 1)
								{
									$row['discount_type'] = "Discount Percentage";
								}
								if($promotion_sub == 2)
								{
									$row['discount_type'] = "Fixed Price";
								}
								
								$row['discount_value'] = $promotion_sub_value;
							}
							else
							{
								$row['discount'] = 'NO';
							}
						}
						else if($promotion_main_type == 2)
						{
							$res_d2 = mysqli_query($link, "SELECT * FROM `item_discount_days` WHERE id = $discount_id and day like '%,".date('N').",%'");
							if(mysqli_num_rows($res_d2) > 0)
							{
								$row['discount'] = 'YES';
								$row['discount_main_type'] = 'Based on Days';
								$row_d2 = mysqli_fetch_assoc($res_d2);
								
								$all_day 				= $row_d2['all_day'];
								$time_start 			= $row_d2['time_start'];
								$time_end 				= $row_d2['time_end'];
								$promotion_sub 			= $row_d2['promotion_sub'];
								$promotion_sub_value 	= $row_d2['promotion_sub_value'];
								
								if($all_day == 0)
								{
									$row['is_all_day_discount'] = "NO";
									$row['discount_start_time'] = $time_start;
									$row['discount_end_time'] 	= $time_end;									
								}
								else if($all_day == 1)
								{
									$row['is_all_day_discount'] = "YES";
								}
														
								if($promotion_sub == 1)
								{
									$row['discount_type'] = "Discount Percentage";
								}
								if($promotion_sub == 2)
								{
									$row['discount_type'] = "Fixed Price";
								}
								
								$row['discount_value'] = $promotion_sub_value;
							}
							else
							{
								$row['discount'] = 'NO';
							}
						}
					}
					else
					{
						$row['discount'] = 'NO';
					}*/
					/******** Item discount Old Ends ***********/
					
					
					/******** Item discount New Starts ***********/
					
					$item_discount = [];
				
					$item_res_d1 = mysqli_query($link, "SELECT * FROM item_discount WHERE item_id = ".$row['id']);
					if(mysqli_num_rows($item_res_d1) > 0)
					{
						
						while($item_row_d1 = mysqli_fetch_assoc($item_res_d1))
						{
							
							$discount_id 			= $item_row_d1['discount_id'];
							$promotion_main_type 	= $item_row_d1['promotion_main_type'];
							
							if($promotion_main_type == 1)
							{
								$item_res_d2 = mysqli_query($link, "SELECT * FROM `item_discount_daterange` WHERE id = $discount_id and ('$curr_date' BETWEEN start_date and end_date)");
								
								if(mysqli_num_rows($item_res_d2) > 0)
								{
									
									$item_row_d1['discount'] = 'YES';
									$item_row_d1['discount_main_type'] = 'Based on Daterange';
									
									$item_row_d2 = mysqli_fetch_assoc($item_res_d2);
									
									$item_row_d1['start_date'] 	= $item_row_d2['start_date'];
									$item_row_d1['end_date'] 	= $item_row_d2['end_date'];
									
									$promotion_sub 			= $item_row_d2['promotion_sub'];
									$promotion_sub_value 	= $item_row_d2['promotion_sub_value'];
																	
									if($promotion_sub == 1)
									{
										$item_row_d1['discount_type'] = "Discount Percentage";
									}
									if($promotion_sub == 2)
									{
										$item_row_d1['discount_type'] = "Fixed Price";
									}
									
									$item_row_d1['discount_value'] = $promotion_sub_value;
								}
								else
								{
									$item_row_d1['discount'] = 'NO';
								}
							}
							else if($promotion_main_type == 2)
							{
								$item_res_d2 = mysqli_query($link, "SELECT * FROM `item_discount_days` WHERE id = $discount_id and day like '%,".date('N').",%'");
								if(mysqli_num_rows($item_res_d2) > 0)
								{
									$item_row_d1['discount'] = 'YES';
									$item_row_d1['discount_main_type'] = 'Based on Days';
									$item_row_d2 = mysqli_fetch_assoc($item_res_d2);
									
									$all_day 				= $item_row_d2['all_day'];
									$time_start 			= $item_row_d2['time_start'];
									$time_end 				= $item_row_d2['time_end'];
									$promotion_sub 			= $item_row_d2['promotion_sub'];
									$promotion_sub_value 	= $item_row_d2['promotion_sub_value'];
									
									if($all_day == 0)
									{
										$item_row_d1['is_all_day_discount'] = "NO";
										$item_row_d1['discount_start_time'] = $time_start;
										$item_row_d1['discount_end_time'] 	= $time_end;									
									}
									else if($all_day == 1)
									{
										$item_row_d1['is_all_day_discount'] = "YES";
									}
					
									if($promotion_sub == 1)
									{
										$item_row_d1['discount_type'] = "Discount Percentage";
									}
									if($promotion_sub == 2)
									{
										$item_row_d1['discount_type'] = "Fixed Price";
									}
									
									$item_row_d1['discount_value'] = $promotion_sub_value;
								}
								else
								{
									$item_row_d1['discount'] = 'NO';
								}
							}						
							$item_discount[] = $item_row_d1;
						}
					
					
						if($item_discount)
						{
							
							$item_promotion_main_type_date = [];
							$item_promotion_main_type_days = [];
							
							foreach($item_discount as $cd)
							{
								if($cd['discount'] == 'YES' && $cd['promotion_main_type'] == 1)
								{
									$item_promotion_main_type_date[] = $cd;
								}
								else if($cd['discount'] == 'YES' && $cd['promotion_main_type'] == 2)
								{
									$item_promotion_main_type_days[] = $cd;
								}
							}
							
							$item_promotion_main_type_date = end($item_promotion_main_type_date);
							
							$ij = 0;
							
							$str_curr_time = strtotime($curr_time);
							foreach($item_promotion_main_type_days as $cd)
							{
								if($cd['is_all_day_discount'] == "NO")
								{
									
									$str_start_time = strtotime($cd['discount_start_time']);
									$str_end_time = strtotime($cd['discount_end_time']);
									
									if(($str_curr_time >= $str_start_time) && ($str_curr_time <= $str_end_time))
									{
									}
									else
									{
										unset($item_promotion_main_type_days[$ij]);
									}
								}
								$ij++;
							}
							$item_promotion_main_type_days = array_values($item_promotion_main_type_days);
							$item_promotion_main_type_days = end($item_promotion_main_type_days);
							
							$item_discount_type_fixed = FALSE;
							$item_discount_type_percentage = FALSE;
							
							if($item_promotion_main_type_date || $item_promotion_main_type_days)
							{
								$item_discount_finale = "YES";
							} else {
								$item_discount_finale = "NO";
							}
							
							if($item_promotion_main_type_date)
							{	
								if($item_promotion_main_type_date['discount_type'] == "Fixed Price") {
									$item_discount_type_fixed = TRUE;
								} else if($item_promotion_main_type_date['discount_type'] == "Discount Percentage") {
									$item_discount_type_percentage = TRUE;
								}
							}
							
							if($item_promotion_main_type_days)
							{	
								if($item_promotion_main_type_days['discount_type'] == "Fixed Price") {
									$item_discount_type_fixed = TRUE;
								} else if($item_promotion_main_type_days['discount_type'] == "Discount Percentage") {
									$item_discount_type_percentage = TRUE;
								}
							}
							
							if($item_promotion_main_type_date && $item_promotion_main_type_days)
							{
								if($item_discount_type_fixed == TRUE && $item_discount_type_percentage == TRUE) {
									if($item_promotion_main_type_date['discount_type'] == "Fixed Price") {
										$discount_value_fixed = $item_promotion_main_type_date['discount_value'];
									} else if($item_promotion_main_type_days['discount_type'] == "Fixed Price") {
										$discount_value_fixed = $item_promotion_main_type_days['discount_value'];
									}
									
									if($item_promotion_main_type_date['discount_type'] == "Discount Percentage") {
										$discount_value_percentage = $item_promotion_main_type_date['discount_value'];
									} else if($item_promotion_main_type_days['discount_type'] == "Discount Percentage") {
										$discount_value_percentage = $item_promotion_main_type_days['discount_value'];
									}
									
									$item_discount_finale_type = "Fixed Price";
									$item_discount_finale_value = ($discount_value_fixed * $discount_value_percentage) / 100;
									
								} else if($item_discount_type_fixed == TRUE) {
									$discount_value_fixed_on_date = $item_promotion_main_type_date['discount_value'];
									$discount_value_fixed_on_days = $item_promotion_main_type_days['discount_value'];
									
									$item_discount_finale_type = "Fixed Price";
									if($discount_value_fixed_on_date > $discount_value_fixed_on_days) {
										$item_discount_finale_value = $discount_value_fixed_on_date;
									} else {
										$item_discount_finale_value = $discount_value_fixed_on_days;
									}
									
								} else if($item_discount_type_percentage == TRUE) {
									
									$discount_value_percentage_on_date = $item_promotion_main_type_date['discount_value'];
									$discount_value_percentage_on_days = $item_promotion_main_type_days['discount_value'];
									
									$item_discount_finale_type = "Discount Percentage";
									if($discount_value_percentage_on_date > $discount_value_percentage_on_days) {
										$item_discount_finale_value = $discount_value_percentage_on_date;
									} else {
										$item_discount_finale_value = $discount_value_percentage_on_days;
									}
								}
							}
							else if($item_promotion_main_type_date)
							{
								if($item_discount_type_fixed == TRUE) {
									$discount_value_fixed_on_date = $item_promotion_main_type_date['discount_value'];
									
									$item_discount_finale_type = "Fixed Price";
									$item_discount_finale_value = $discount_value_fixed_on_date;
									
								} else if($item_discount_type_percentage == TRUE) {
									
									$discount_value_percentage_on_date = $item_promotion_main_type_date['discount_value'];
									
									$item_discount_finale_type = "Discount Percentage";
									$item_discount_finale_value = $discount_value_percentage_on_date;
									
								}
							}
							else if($item_promotion_main_type_days)
							{
								if($item_discount_type_fixed == TRUE) {
									
									$discount_value_fixed_on_days = $item_promotion_main_type_days['discount_value'];
									$item_discount_finale_type = "Fixed Price";
									$item_discount_finale_value = $discount_value_fixed_on_days;
									
								} else if($item_discount_type_percentage == TRUE) {
									
									$discount_value_percentage_on_days = $item_promotion_main_type_days['discount_value'];
									$item_discount_finale_type = "Discount Percentage";
									$item_discount_finale_value = $discount_value_percentage_on_days;
			
								}
							}
							
							/*echo "<pre>";
							print_r($item_promotion_main_type_date);
							print_r($item_promotion_main_type_days);
							print_r("Finle Type ".$item_discount_finale_type);
							print_r("<br />Value ".$item_discount_finale_value);
							echo "</pre>";
							exit;*/
							
						}
						else 
						{
							$item_discount_finale = "NO";
						}
						
					}
					if($item_discount && $item_discount_finale == "YES")
					{
						//$row['item_discount_finale_type'] = $item_discount_finale_type;
						//$row['item_discount_finale_value'] = $item_discount_finale_value;
						//$row['item_discount'] = "YES";
						$row['discount_applicable'] = "ITEM";
						
						if($item_discount_finale_type == "Fixed Price")
						{
							$row['discounted_price'] = $item_discount_finale_value;
						}
						
						if($item_discount_finale_type == "Discount Percentage")
						{
							$row['discounted_price'] = ($row['price'] - (($row['price'] * $item_discount_finale_value) / 100));
						}
						
					}
					else
					{
						//$row['item_discount'] = "NO";
						
						if($category_discount && $cat_discount_finale == "YES")
						{
							//$row['category_discount'] = "YES";
							$row['discount_applicable'] = "CATEGORY";
							if($cat_discount_finale_type == "Fixed Price")
							{
								$row['discounted_price'] = $cat_discount_finale_value;
							}
							
							if($cat_discount_finale_type == "Discount Percentage")
							{
								$row['discounted_price'] = $row['price'] - (($row['price'] * $cat_discount_finale_value) / 100);
							}
						}
						else 
						{
							$row['discount_applicable'] = "NO";
						}
					}
					
					if($row['has_variety'] != 0)
					{	
						$res_variety = mysqli_query($link, "SELECT id, variety_name, variety_price FROM item_variety WHERE item_id = '$item_id'");
						if(mysqli_num_rows($res_variety) > 0)
						{
							$varieties = array();
							while($row_variety = mysqli_fetch_assoc($res_variety))
							{
								if($item_discount && $item_discount_finale == "YES")
								{
									if($item_discount_finale_type == "Fixed Price") {
										$row_variety['discounted_variety_price'] = $item_discount_finale_value;
									}
									if($item_discount_finale_type == "Discount Percentage")
									{
										$row_variety['discounted_variety_price'] = $row_variety['variety_price'] - (($row_variety['variety_price'] * $item_discount_finale_value) / 100);
									}
									
								}
								else
								{
									if($category_discount && $cat_discount_finale == "YES")
									{
										if($cat_discount_finale_type == "Fixed Price")
										{
											$row_variety['discounted_variety_price'] = $cat_discount_finale_value;
										}
										if($cat_discount_finale_type == "Discount Percentage")
										{
											$row_variety['discounted_variety_price'] = $row_variety['variety_price'] - (($row_variety['variety_price'] * $cat_discount_finale_value) / 100);
										}
									}
								}
					
								$varieties[] = $row_variety;
							}
							$row['varieties'] = $varieties;
						}
					}
					
					/******** Item discount New Ends ***********/
										
					if($row['images'] != "")
					{
						$row['images'] = $item_image.$row['images'];
					}
					
					/********** Is new item check new starts  ***********/
					if($row['discount_applicable'] == "NO") {
						$row['is_new'] = "0";
					} else {
						$row['is_new'] = "1";
					}
					
					
					$items[] = $row;
				}
																
				/*echo "<pre>";
				print_r($items);
				echo "</pre>";*/
				
				print_r(utf8_encode(json_encode($items)));	//	Items list array with options
				
			}
		}
	}
}
