<?php

/*
*	Get details of store using beacon Id
* 	URL: http://localhost:8080/wopadu/ws/store-find.php?beacon_major=1&lang=hi
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
require_once "define.php";
require_once "functions.php";

if(isset($_REQUEST['lang'])) {
	$language = getLanguage($link, $_REQUEST['lang']);
}

if(!isset($_REQUEST['beacon_major']))
{
	print_r('0');  //	Variables not set
	exit;
}
else
{
	$beacon_major = $_REQUEST['beacon_major'];
	
	if($beacon_major == 52528)
	{
		$beacon_major = 13;
	}
	
	if($beacon_major == "")
	{
		print_r('1');	//	Beacon major can't be empty
		exit;
	}
	else
	{
		
		$result_store = mysqli_query($link, "SELECT store_id from beacons WHERE beacon_major = '$beacon_major' LIMIT 1");
			
		if(!$result_store)
		{
			print_r('2');	// Something went wrong, Please try again
			exit;
		}
		else
		{
			if(mysqli_num_rows($result_store) == 0)
			{
				print_r('3');	// Store Id doesn't found
				exit;
			}
			else
			{
				$row_store = mysqli_fetch_assoc($result_store);
				$store_id = $row_store['store_id'];
				
				//$q = "SELECT S.*, A.account_name from stores as S INNER JOIN accounts as A ON A.id = S.account_id WHERE S.id = '$store_id' LIMIT 1";
				
				$lang_sql = "";
				if(isset($language)) {
					$lang_sql = ", S.store_name_".$language['language_lc'].", S.description_".$language['language_lc']."";
				}
				
				$q = "SELECT S.id, S.account_id, S.store_name, S.store_branch, S.address, S.description, S.tax_invoice, S.abn_number, S.image, S.welcome_notif, S.received_notif, S.ready_notif, S.display_note, S.secret_key, S.publishable_key, S.map_latitude, S.map_longitude, S.status, A.account_name".$lang_sql." from stores as S INNER JOIN accounts as A ON A.id = S.account_id WHERE S.id = '$store_id' and S.status = 1";
				
				$result = mysqli_query($link, $q);
		
				if(!$result)
				{
					print_r('4');	// Something went wrong, Please try again
					exit;
				}
				else
				{
					if(mysqli_num_rows($result) == 0)
					{
						print_r('5');	// Store doesn't found
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
						
						//print_r(json_encode($row));	// Store Details array
						print_r(json_encode($row, JSON_UNESCAPED_UNICODE));	// Categories array
					}
				}
			}
		}
		
	}
}