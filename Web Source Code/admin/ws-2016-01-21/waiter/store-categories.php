<?php

/*
*	Get menu categories of store
* 	URL: http://localhost:8080/wopado/ws/store-categories.php?ws=1&store_id=1
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "../config.php";
require_once "../define.php";

if(!isset($_REQUEST['ws']) || !isset($_REQUEST['store_id']))
{
	print_r('0');  //	Variables not set
	exit;
}
else
{
	$store_id = $_REQUEST['store_id'];
	
	if($store_id == "")
	{
		print_r('1');	//	Store id can't be empty
		exit;
	}
	else
	{
		$result = mysqli_query($link, "SELECT * from categories WHERE store_id = '$store_id' and status = 1");
		
		if(!$result)
		{
			print_r('2');	// Something went wrong, Please try again
			exit;
		}
		else
		{
			if(mysqli_num_rows($result) == 0)
			{
				print_r('3');	// No categories found
				exit;
			}
			else
			{
				$rows = array();
				while($row = mysqli_fetch_assoc($result))
				{
					$res_d1 = mysqli_query($link, "SELECT * FROM category_discount WHERE category_id = ".$row['id']);
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
								$res_d2 = mysqli_query($link, "SELECT * FROM `cat_discount_daterange` WHERE id = $discount_id");
								
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
								$res_d2 = mysqli_query($link, "SELECT * FROM `cat_discount_days` WHERE id = $discount_id");
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
										$row_d1['discount_ended_time'] 	= $time_end;									
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
					
					
					
					
					/* New Item check new starts */
					$res_d1 = mysqli_query($link, "SELECT * FROM category_discount WHERE category_id = ".$row['id']);
					if(mysqli_num_rows($res_d1) > 0)
					{
						$row['new_items'] = "YES";
					}
					else
					{
						$row['new_items'] = "NO";
					}
					/* New Item check new ends */
					
					
					if($row['parent_id'] == 0)
					{				
						if($row['images'] != "")
						{
							$ex_img = explode(",", $row['images']);
							$count_img = count($ex_img);
							
							if($count_img == 1) { $row['images'] = ["image_1" => $category_image.$ex_img[0], "image_2" => "", "image_3" => ""]; }
							else if($count_img == 2) { $row['images'] = ["image_1" => $category_image.$ex_img[0], "image_2" => $category_image.$ex_img[1], "image_3" => ""]; }
							else if($count_img == 3) { $row['images'] = ["image_1" => $category_image.$ex_img[0], "image_2" => $category_image.$ex_img[1], "image_3" => $category_image.$ex_img[2]]; }
							//$row['images'] = $category_image.$row['images'];
							
						}
						else
						{
							$row['images'] = ["image_1" => "", "image_2" => "", "image_3" => ""];
						}
					}
					else
					{
						if($row['images'] != "")
						{
							$row['images'] = $category_image.$row['images'];
						}
					}
					$rows[] = $row;
				}
					
				/*echo "<pre>";
				print_r($rows);
				echo "</pre>";*/
						
				$items = $rows;
				$id = '';
				$categories = array();
				
				function sub($items, $id)
				{
					$output = array();
					foreach($items as $item)
					{
						if($item['parent_id'] == $id)
						{
							$item['sub_menu'] = sub($items, $item['id']);
							$output[] = $item;
						}
						//$output[] = $item;
					}
					return $output;
				}
				
				foreach($items as $item)
				{	
					if($item['parent_id'] == 0)
					{
						$id = $item['id'];
						$item['sub_menu'] = sub($items, $id);
						$categories[] = $item;
					}
				}
								
				/*echo "<pre>";
				print_r($categories);
				echo "</pre>";*/
				
				print_r(json_encode($categories));	// Categories array
			}
		}
	}
}
