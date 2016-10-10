<?php

/*
*	Get details of store using beacon Id
* 	URL: http://localhost:8080/wopadu/ws/store-locator.php?map_latitude=22.2873441&map_longitude=70.8046398&lang=hi
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "define.php";
require_once "functions.php";

if(isset($_REQUEST['lang'])) {
	$language = getLanguage($link, $_REQUEST['lang']);
}

if(!isset($_REQUEST['map_latitude']) || !isset($_REQUEST['map_longitude']))
{
	print_r('0');  //	Variables not set
	exit;
}
else
{
	$map_latitude = $_REQUEST['map_latitude'];
	$map_longitude = $_REQUEST['map_longitude'];
	$radius = 800;		// 800 Miles
	
	$lang_sql = "";
	if(isset($language)) {
		$lang_sql = ", store_name_".$language['language_lc'].", description_".$language['language_lc']."";
	}
	
	// use 	3959 for Miles and 6371 for Kilometers
	
	$sql = "SELECT id, store_name, store_branch, address, image, description, map_latitude, map_longitude, ( 3959 * acos( cos( radians(".$map_latitude.") ) * cos( radians( map_latitude ) ) * cos( radians( map_longitude ) - radians(".$map_longitude.") ) + sin( radians(".$map_latitude.") ) * sin( radians( map_latitude ) ) ) ) AS distance".$lang_sql." FROM stores WHERE status = 1 HAVING distance < $radius ORDER BY distance LIMIT 0 , 20";
	
	//echo $sql;
	
	$res = mysqli_query($link, $sql);
	
	if($res)
	{
		if(mysqli_num_rows($res) > 0)
		{
		
			$stores_array = [];
			
			while($row = mysqli_fetch_assoc($res))
			{
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
				if($row['image'] != "")
				{
					$row['image'] = $store_image.$row['image'];
				}
				
				$stores_array[] = $row;
			}
			print_r(json_encode($stores_array, JSON_UNESCAPED_UNICODE));	// Categories array
			
		}
		else
		{
			print "2";	// No stores found
		}
	}
	else
	{
		print "1";	// Something went wrong, Query Error
	}
}