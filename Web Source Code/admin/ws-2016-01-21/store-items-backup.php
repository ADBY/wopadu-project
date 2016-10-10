<?php

/*
*	Get menu items of store
* 	URL: http://localhost:8080/wopado/ws/store-items.php?ws=1&category_id=7
*/

header("Content-type: text/plain");		//Convert to plain text

require_once "config.php";

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
		$result = mysqli_query($link, "SELECT * from items WHERE category_id = '$category_id'");
		
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
					if($row['no_of_option'] != 0)
					{
						$item_id = $row['id'];
						
						$res_option = mysqli_query($link, "SELECT IOM.id as main_option_id, IOM.option_name as main_option_name, IOS.id as sub_option_id, IOS.sub_name, IOS.sub_amount FROM item_option_main as IOM INNER JOIN item_option_sub AS IOS ON IOS.option_id = IOM.id WHERE IOM.item_id = '$item_id'");
						if(!$res_option)
						{
							print_r('4');	// Something went wrong, Please try again
							exit;
						}
						else
						{
							if(mysqli_num_rows($res_option) == 0)
							{
								print_r('5');	// No options found
								exit;
							}
							else
							{
								$item_options = array();
								$op_id = array();
								while($row_option = mysqli_fetch_assoc($res_option))
								{
									$op_id[] = $row_option['main_option_id'];
									$item_options[] = $row_option;
								}
								
								$op_id = array_values(array_unique($op_id));
								
								$opt = array();
								foreach($op_id as $op)
								{
									$main = array();
									$main['main_option_id'] = $op;
									$main['sub_option'] = array();
									foreach($item_options as $option)
									{
										if($option['main_option_id'] == $op)
										{
											$main['sub_option'][] = array('sub_option_id' => $option['sub_option_id'], 'sub_name' => $option['sub_name'], 'sub_amount' => $option['sub_amount']);
											$main['main_option_name'] = $option['main_option_name'];
										}
									}
									$row['item_options'][] = $main;									
								}								
							}
						}
					}
					$items[] = $row;
				}
																
				/*echo "<pre>";
				print_r($items);
				echo "</pre>";*/
				
				print_r(json_encode($items));	//	Items list array with options
			}
		}
	}
}
