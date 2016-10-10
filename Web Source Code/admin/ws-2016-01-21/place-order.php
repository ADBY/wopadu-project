<?php

/*
*	Place Order
* 	URL: http://localhost:8080/wopado/ws/place-order.php?ws=1&user_id=1&store_id=1&items=JSON&table_location=2&grand_total=25&order_note=nops
*
*/

//header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "functions.php";
require_once "define.php";

$curr_date = date('Y-m-d H:i:s');
$curr_time = date("H:i:s");

if(!isset($_REQUEST['user_id']) || !isset($_REQUEST['store_id']) || !isset($_REQUEST['table_location']) || !isset($_REQUEST['grand_total']) || !isset($_REQUEST['order_note']))
{
	print_r('0'); 	// Variables not set
	exit;
}
else
{
	$user_id 			= mysqli_real_escape_string($link, $_REQUEST['user_id']);
	$store_id 			= mysqli_real_escape_string($link, $_REQUEST['store_id']);
	$table_location 	= mysqli_real_escape_string($link, $_REQUEST['table_location']);
	$grand_total 		= mysqli_real_escape_string($link, $_REQUEST['grand_total']);
	$order_note 		= mysqli_real_escape_string($link, $_REQUEST['order_note']);
	
	$items 				= json_decode($_REQUEST['items']);
	
	//$a = '[{"item_id":5,"kitchen_id":1,"item_options_id":"","item_variety_id":"5","item_quantity":1,"item_amount":"685.00","item_options_amount":"0.00","item_discount":"0.00","final_amount":"685.00","item_note":"extra spicy"}]';

	//$items = json_decode($a);

	if($user_id == "" || $store_id == "" || $table_location == "" || $grand_total == "")
	{
		print_r('1'); 	// User id, Store id, table location, grand total can't be empty
		exit;
	}
	else
	{		
		/********* Checking prices of item are valid starts **************/
		$temp_items = $items;

		$jkl = 0;
		foreach($items as $item)
		{
			$item_id 				= $item->item_id;
			$kitchen_id 			= $item->kitchen_id;
			$item_options_id 		= $item->item_options_id;
			$item_variety_id 		= $item->item_variety_id;
			$item_quantity 			= $item->item_quantity;
			$item_amount 			= $item->item_amount;
			$item_options_amount 	= $item->item_options_amount;
			$item_discount 			= $item->item_discount;
			$final_amount 			= $item->final_amount;
			$item_note 				= $item->item_note;
			
			$res_11 = mysqli_query($link, "SELECT id, category_id, price, tax_percentage FROM items WHERE id = ".$item_id);
			
			if($res_11)
			{
				if(mysqli_num_rows($res_11) > 0)
				{
					
					$row_11 		= mysqli_fetch_assoc($res_11);
					$category_id 	= $row_11['category_id'];
					$item_id 		= $row_11['id'];
					$item_price 	= $row_11['price'];
					$tax_percentage = $row_11['tax_percentage'];
					
					$items[$jkl]->tax_percentage = $tax_percentage;
					$items[$jkl]->item_new_price = $item_price;
					
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
										//$cat_discount_finale_value = $discount_value_fixed_on_days;
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
						}
						else 
						{
							$cat_discount_finale = "NO";
						}					
					}					
					
					if($category_discount && $cat_discount_finale == "YES")
					{
					}
					else
					{
						$cat_discount_finale = "NO";
					}
					
					/******** Item discount New Starts ***********/
					
					$item_discount = [];
				
					$item_res_d1 = mysqli_query($link, "SELECT * FROM item_discount WHERE item_id = $item_id");
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
					
					if($item_variety_id == "" && $item_discount && $item_discount_finale == "YES")
					{
						if($item_discount_finale_type == "Fixed Price")
						{
							$price_to_match = $item_discount_finale_value;
							$price_to_match = number_format((float)$price_to_match, 2, '.', '');
						}
						if($item_discount_finale_type == "Discount Percentage")
						{
							$price_to_match = $item_price - (($item_price * $item_discount_finale_value) / 100);
							$price_to_match = number_format((float)$price_to_match, 2, '.', '');
						}						
					}
					else
					{
						if($item_variety_id == "" && $category_discount && $cat_discount_finale == "YES")
						{
							if($cat_discount_finale_type == "Fixed Price")
							{
								$price_to_match = $cat_discount_finale_value;
								$price_to_match = number_format((float)$price_to_match, 2, '.', '');
							}
							
							if($cat_discount_finale_type == "Discount Percentage")
							{
								$price_to_match = $item_price - (($item_price * $cat_discount_finale_value) / 100);
								$price_to_match = number_format((float)$price_to_match, 2, '.', '');
							}
						}
					}
					
					if($item_variety_id != "")
					{	
						$res_variety = mysqli_query($link, "SELECT id, variety_name, variety_price FROM item_variety WHERE id = '$item_variety_id'");
						if(mysqli_num_rows($res_variety) > 0)
						{
							$row_variety = mysqli_fetch_assoc($res_variety);
							
							
							
							if($item_discount && $item_discount_finale == "YES")
							{
/*echo "<pre>";
echo "item_discount: ";
print_r($item_discount);
echo "<br />item_discount_finale: ";
print_r($item_discount_finale);
echo "<br />item_discount_finale_type: ";
print_r($item_discount_finale_type);
echo "<br />item_discount_finale_value: ";
print_r($item_discount_finale_value);
echo "</pre>";
exit;*/
		
								if($item_discount_finale_type == "Fixed Price")
								{
									$price_to_match = $item_discount_finale_value;
									$price_to_match = number_format((float)$price_to_match, 2, '.', '');
								}
								if($item_discount_finale_type == "Discount Percentage")
								{
									$price_to_match = $row_variety['variety_price'] - (($row_variety['variety_price'] * $item_discount_finale_value) / 100);
									$price_to_match = number_format((float)$price_to_match, 2, '.', '');
								}
/*echo "<pre>";
echo "<br />price_to_match: ";
print_r($price_to_match);
echo "</pre>";
exit;*/
							}
							else
							{
								if($category_discount && $cat_discount_finale == "YES")
								{
									if($cat_discount_finale_type == "Fixed Price")
									{
										$price_to_match = $cat_discount_finale_value;
										$price_to_match = number_format((float)$price_to_match, 2, '.', '');
									}
									if($cat_discount_finale_type == "Discount Percentage")
									{
										$price_to_match = $row_variety['variety_price'] - (($row_variety['variety_price'] * $cat_discount_finale_value) / 100);
										$price_to_match = number_format((float)$price_to_match, 2, '.', '');
									}
								}
								else
								{
									$price_to_match = $row_variety['variety_price'];
								}
							}
							//echo $price_to_match;
							//echo "variety";
							//exit;
						}
						else
						{
							print_r('6'); 	// item  variety not found
							exit;
						}
					}
					
					/******** Check category discount ends **********/
					
				}
				else
				{
					print_r('5'); 	// item  not found
					exit;
				}
			}
			else
			{
				print_r('4'); 	// Invalid item id 
				exit;
			}
			//echo $price_to_match;
				//exit;
			//if(isset($price_to_match) && $price_to_match != $item_amount)
			if(isset($price_to_match))
			{
				//echo $price_to_match;
				//exit;
				$temp_items[$jkl]->item_new_price = $price_to_match;
			}
			unset($price_to_match);
			$jkl++;
		}

		$changed_price = FALSE;
		
		foreach($temp_items as $xyz)
		{
			if(isset($xyz->item_new_price) && $xyz->item_amount != $xyz->item_new_price)
			{
				$changed_price = TRUE;
			}
		}
		
		if($changed_price == TRUE)
		{
			//echo "Changed";
			/*echo "<pre>";
			echo "TEMP ARRAY: <br />";
			print_r($temp_items);
			echo "</pre>";*/
			print_r(json_encode($temp_items));
			exit;
		}
		/*else
		{
			echo "Ok";
		}*/
		
		/*echo "<pre>";
		echo "TEMP ARRAY: <br />";
		print_r($temp_items);
		echo "<br />ITEM ARRAY: <br />";
		print_r($items);
		echo "</pre>";*/
		//exit;

		/********* Checking prices of item are valid ends **************/
		
		$res_order_number = mysqli_query($link, "SELECT order_number FROM orders WHERE store_id = '$store_id' and DATE(n_datetime) = DATE(NOW()) ORDER BY id DESC LIMIT 1");
		if(mysqli_num_rows($res_order_number) > 0)
		{
			$row_order_number = mysqli_fetch_assoc($res_order_number);
			$order_number = $row_order_number['order_number'] + 1;
		}
		else
		{
			$order_number = 1;
		}
		
		$res_inv_number = mysqli_query($link, "SELECT invoice_number FROM orders WHERE store_id = '$store_id' ORDER BY id DESC LIMIT 1");
		if(mysqli_num_rows($res_inv_number) > 0)
		{
			$row_inv_number = mysqli_fetch_assoc($res_inv_number);
			$inv = (int)$row_inv_number['invoice_number'];
			$invoice_number =  $inv + 1;
		}
		else
		{
			$invoice_number = "000001";
		}
		
		$order_type 	= 1; 			// 1 = Online, 2 = Offline
		$status 		= 1; 			// Received
		$n_datetime 	= date('Y-m-d H:i:s');
				
		$res_order = mysqli_query($link, "INSERT INTO `orders`(`user_id`, `store_id`, `order_number`, `invoice_number`, `order_type`, `table_location`, `total_amount`, `add_note`, `status`, `n_datetime`) VALUES ('$user_id', '$store_id', '$order_number', '$invoice_number', '$order_type', '$table_location', '$grand_total', '$order_note', '$status', '$n_datetime')");
		
		if(!$res_order)
		{
			print_r('2'); 	// Something went wrong, Query error
			exit;
		}
		else
		{
			$order_id = mysqli_insert_id($link);
			
			$item_status = 1;	// 1 = Received Order
				
			foreach($items as $item)
			{
				$item_id 				= $item->item_id;
				$kitchen_id 			= $item->kitchen_id;
				$item_options_id 		= $item->item_options_id;
				$item_variety_id 		= $item->item_variety_id;
				$item_quantity 			= $item->item_quantity;
				$item_amount 			= $item->item_amount;
				$item_options_amount 	= $item->item_options_amount;
				$item_discount 			= $item->item_discount;
				$tax_percentage			= $item->tax_percentage;
				$final_amount 			= $item->final_amount;
				$item_note 				= $item->item_note;

				if($item_variety_id == "") {
				$query = "INSERT INTO `order_details`(`order_id`, `item_id`, `kitchen_id`, `item_options_id`, `quantity`, `item_amount`, `item_options_amount`, `item_discount`, `tax_percentage`, `final_amount`, `add_note`, `status`) VALUES ('$order_id', '$item_id', '$kitchen_id', '$item_options_id', '$item_quantity', '$item_amount', '$item_options_amount', '$item_discount', '$tax_percentage', '$final_amount', '$item_note', '$item_status')";
				} else {
					$query = "INSERT INTO `order_details`(`order_id`, `item_id`, `kitchen_id`, `item_options_id`, `item_variety_id`, `quantity`, `item_amount`, `item_options_amount`, `item_discount`, `tax_percentage`, `final_amount`, `add_note`, `status`) VALUES ('$order_id', '$item_id', '$kitchen_id', '$item_options_id', '$item_variety_id ', '$item_quantity', '$item_amount', '$item_options_amount', '$item_discount', '$tax_percentage', '$final_amount', '$item_note', '$item_status')";
				}
				
				$res_order_detail = mysqli_query($link, $query);

				if(!$res_order_detail)
				{
					print_r('3'); 	// Something went wrong, Query error
					exit;
				}
			}
			
			$order_placed = ['order_id'=> $order_id];
			//print_r("OK/".$order_id);	// Order has been placed
			print_r(json_encode($order_placed));	// Order has been placed
			exit;			
		}
	}
}