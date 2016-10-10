<?php

/*
*	Get details of store using beacon Id
* 	URL: http://localhost:8080/wopadu/ws/store-details.php?ws=1&beacon_major=1&beacon_minor=1
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";
	  
if(!isset($_REQUEST['ws']) || !isset($_REQUEST['beacon_major']) || !isset($_REQUEST['beacon_minor']))
{
	print_r('0');  //	Variables not set
	exit;
}
else
{
	$beacon_major = $_REQUEST['beacon_major'];
	$beacon_minor = $_REQUEST['beacon_minor'];
	
	if($beacon_major == "" || $beacon_minor == "")
	{
		print_r('1');	//	Beacon id can't be empty
		exit;
	}
	else
	{
		$result_store = mysqli_query($link, "SELECT store_id from beacons WHERE beacon_major = '$beacon_major' and beacon_minor = '$beacon_minor' LIMIT 1");
		
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
				
				$q = "SELECT S.*, A.account_name from stores as S INNER JOIN accounts as A ON A.id = S.account_id WHERE S.id = '$store_id' LIMIT 1";
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
						print_r(json_encode($row));	// Store Details array
					}
				}
			}
		}
	}
}