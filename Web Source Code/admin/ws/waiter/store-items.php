<?php

/*
*	Get menu items of store
* 	URL: http://localhost:8080/wopadu/ws/waiter/store-items.php?ws=1&category_id=7
*/

header("Content-type: text/plain");		//Convert to plain text

require_once "../config.php";
require_once "../define.php";

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
					$res_d1 = mysqli_query($link, "SELECT * FROM item_discount WHERE item_id = ".$row['id']);
					if(mysqli_num_rows($res_d1) > 0)
					{
						$row['discount_flag'] = 'YES';
						
						$d_i = 0;
						
						while($row_d1 = mysqli_fetch_assoc($res_d1))
						{
						
							$discount_id 			= $row_d1['discount_id'];
							$promotion_main_type 	= $row_d1['promotion_main_type'];
							
							if($promotion_main_type == 1)
							{
	
								$res_d2 = mysqli_query($link, "SELECT * FROM `item_discount_daterange` WHERE id = $discount_id");
								
								if(mysqli_num_rows($res_d2) > 0)
								{
									//$row['discount'] = 'YES';
									$row_d1['discount_main_type'] = 'Based on Daterange';
									$row_d2 = mysqli_fetch_assoc($res_d2);
									
									$promotion_sub 			= $row_d2['promotion_sub'];
									$promotion_sub_value 	= $row_d2['promotion_sub_value'];
									
									$row_d1['start_date'] 	= $row_d2['start_date'];
									$row_d1['ended_date'] 	= $row_d2['end_date'];
																	
									if($promotion_sub == 1)
									{
										$row_d1['discount_type'] = "Discount Percentage";
									}
									if($promotion_sub == 2)
									{
										$row_d1['discount_type'] = "Fixed Price";
									}
									
									$row_d1['discount_value'] = $promotion_sub_value;
								}
							}
							else if($promotion_main_type == 2)
							{
								$res_d2 = mysqli_query($link, "SELECT * FROM `item_discount_days` WHERE id = $discount_id");
								if(mysqli_num_rows($res_d2) > 0)
								{
									//$row['discount'] = 'YES';
									$row_d1['discount_main_type'] = 'Based on Days';
									$row_d2 = mysqli_fetch_assoc($res_d2);
									
									$row_d1['day'] 			= trim($row_d2['day'], ",");
									
									$all_day 				= $row_d2['all_day'];
									$time_start 			= $row_d2['time_start'];
									$time_end 				= $row_d2['time_end'];
									$promotion_sub 			= $row_d2['promotion_sub'];
									$promotion_sub_value 	= $row_d2['promotion_sub_value'];
									
									if($all_day == 0)
									{
										$row_d1['is_all_day_discount'] = "NO";
										$row_d1['discount_start_time'] = $time_start;
										$row_d1['discount_end_time'] 	= $time_end;									
									}
									else if($all_day == 1)
									{
										$row_d1['is_all_day_discount'] = "YES";
									}
															
									if($promotion_sub == 1)
									{
										$row_d1['discount_type'] = "Discount Percentage";
									}
									if($promotion_sub == 2)
									{
										$row_d1['discount_type'] = "Fixed Price";
									}
									
									$row_d1['discount_value'] = $promotion_sub_value;
								}
							}
							
							$row['discount'][$d_i] = $row_d1;
								
							$d_i++;
							
						}
					}
					else
					{
						$row['discount_flag'] = 'NO';
					}
					/******** Item discount Old Ends ***********/
					
					
					/******** Item discount New Starts ***********/
					
					/*$item_discount = [];
				
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
					}*/
					
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
					
					/*$row['discount'] = $item_discount;*/
					
					/******** Item discount New Ends ***********/
										
					if($row['images'] != "")
					{
						$row['images'] = $item_image.$row['images'];
					}
					
					/********** Is new item check new starts  ***********/
					/*if($row['discount_applicable'] == "NO") {
						$row['is_new'] = "0";
					} else {
						$row['is_new'] = "1";
					}*/
					
					
					
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
