<?php

/*
*	Find table number 
* 	URL: http://localhost:8080/wopado/ws/find-table.php?beacons=array
*
*	In the radius of 1 meter.
*	=> response in sorted beacon minor for beacon distances
*	=> The beacons with minimum distance
*	=> Number of beacons with same minimum distance
*	=> Select tables in the radius of minimum distance
*	=> table count - found multiple times
*	=> Sort with tables count desc
*
*/

header("Content-type: text/plain");	//Convert to plain text
require_once "config.php";

/*$beacons = 
[
	0 => [
		'beacon_major' => 1,
		'beacon_minor' => 1,
		'distance' => 3,
		],
	1 => [
		'beacon_major' => 1,
		'beacon_minor' => 2,
		'distance' => 3.2,
		],
	2 => [
		'beacon_major' => 1,
		'beacon_minor' => 3,
		'distance' => 0.5,
		],
	3 => [
		'beacon_major' => 1,
		'beacon_minor' => 4,
		'distance' => 3.2,
		],
	4 => [
		'beacon_major' => 1,
		'beacon_minor' => 4,
		'distance' => 3.3,
		],
];*/

/*echo "<pre>";
print_r(json_encode($beacons));
echo "</pre>";
exit;*/

if(isset($_REQUEST['beacons']))
{
	$beacons 				= json_decode($_REQUEST['beacons']);

	//$beacons = '[{"beacon_major":1,"beacon_minor":1,"distance":3},{"beacon_major":1,"beacon_minor":2,"distance":3.2},{"beacon_major":1,"beacon_minor":3,"distance":0.5},{"beacon_major":1,"beacon_minor":4,"distance":3.2},{"beacon_major":1,"beacon_minor":4,"distance":3.3}]';
	//$beacons 				= json_decode($beacons);
	
	/*echo "<pre>";
print_r($beacons);
echo "</pre>";
exit;*/


	//echo "Store Id: ".$store_id = $beacons[0]->beacon_major;
	//exit;
	if(isset($beacons[0]->beacon_major))
	{
		$store_id = $beacons[0]->beacon_major;
	}
	else
	{
		print_r("1");	// Something wrong in beacon distance array
		exit;
	}
	
	$q_s1 = "SELECT S.*, A.account_name from stores as S INNER JOIN accounts as A ON A.id = S.account_id WHERE S.id = '$store_id' LIMIT 1";
	$result_s1 = mysqli_query($link, $q_s1);

	if(!$result_s1)
	{
		print_r("2");	// Something went wrong, Please try again
		exit;
	}
	else
	{
		if(mysqli_num_rows($result_s1) == 0)
		{
			print_r("3");	// Store doesn't found
			exit;
		}
		else
		{
			$row_store = mysqli_fetch_assoc($result_s1);								
			//print_r(json_encode($row_store));	// Store Details array
		}
	}
	
	/*echo "<pre>";
	print_r($beacons);
	echo "</pre>";*/
	
	$min_distance = 0;
	$min_distance_beacon = [];
	$device_beacon_distance = [];
	
	foreach($beacons as $b)
	{
		if($min_distance == 0)
		{
			$min_distance = $b->distance;
		}
		if($b->distance < $min_distance)
		{
			$min_distance = $b->distance;
		}
		$device_beacon_distance[] = $b->distance;
	}
	
	//echo "<br />Min Distance Beacon - ". $min_distance;
	
	foreach($beacons as $b)
	{
		if($b->distance == $min_distance)
		{
			$min_distance_beacon[] = $b;
		}	
	}
	
	/*echo "<pre>";
	print_r($min_distance_beacon);
	echo "</pre>";
	exit;*/
	
	$sql_1 = "SELECT * FROM table_beacon WHERE store_id = $store_id and ";
	foreach($min_distance_beacon as $min_b)
	{
		$sql_1 .= "( beacon_major = ".$min_b->beacon_major." and beacon_minor = ".$min_b->beacon_minor." and distance <= ".(($min_b->distance) + 1).") or ";
	}
	
	$sql_1 = rtrim($sql_1, " or ");
	
	//echo $sql_1;
	$res_1 = mysqli_query($link, $sql_1);
	
	if($res_1)
	{
		if(mysqli_num_rows($res_1) > 0)
		{
			$output_1 = [];
			while($row_1 = mysqli_fetch_assoc($res_1))
			{
				$output_1[] = $row_1;
			}
			
			/*echo "<pre>";
			print_r($output_1);
			echo "</pre>";*/
			
			$tables_1 = [];
			foreach($output_1 as $op)
			{
				$tables_1[] = $op['table_id'];
			}
			
			/*echo "<pre>Tables Array:";
			print_r($tables_1);
			echo "</pre>";*/
			
			$array_count_values = array_count_values($tables_1);
			
			/*echo "<pre>array_count_values:";
			print_r($array_count_values);
			echo "</pre>";*/
			
			arsort($array_count_values);
			
			/*echo "<pre>Array Sort:";
			print_r($array_count_values);
			echo "</pre>";*/
			
			$count_1 = count($array_count_values);
			
			//$a = 0;
			//for($a = 0; $a < $count_1; $a++)
			foreach($array_count_values as $key=>$value)
			{
				$table_id = $key;
				
				$check_table = mysqli_query($link, "SELECT * FROM table_beacon WHERE store_id = $store_id and table_id = '".$table_id."' order by beacon_minor asc");
				if($check_table)
				{
					if(mysqli_num_rows($check_table) > 0)
					{
						$table_distance_beacon = [];
						while($row_2 = mysqli_fetch_assoc($check_table))
						{
							$table_distance_beacon[] = $row_2['distance'];
						}
						
						/*echo "<pre>table_distance_beacon: ";
						print_r($table_distance_beacon);
						echo "</pre>";
						echo "<pre>device_beacon_distance: ";
						print_r($device_beacon_distance);
						echo "</pre>";*/
						
						$count_2 = count($table_distance_beacon);
						
						$match_distance = true;
						
						for($c = 0; $c < $count_2; $c++)
						{
							if((($table_distance_beacon[$c] + 1) > $device_beacon_distance[$c])
							 && (($table_distance_beacon[$c]-1) < $device_beacon_distance[$c]))
							{
								
							}
							else
							{
								$match_distance = false;
							}
						}
						
						if($match_distance == true)
						{
							//echo "<br />Final Table Id: ".$table_id;
							//$result = ['table_id'=>$table_id];
							//print_r(json_encode($result));
							$row_store['table_id'] = $table_id;
							print_r(json_encode($row_store));	// Store Details array
							exit;
						}
						//exit;
					}
					else
					{
						$row_store['table_id'] = "error";
						$row_store['table_id_error_code'] = "8";
						print_r(json_encode($row_store));	// Store Details array
						exit;
					}
				}
				else
				{
					$row_store['table_id'] = "error";
					$row_store['table_id_error_code'] = "7";
					print_r(json_encode($row_store));	// Store Details array
					exit;
				}
			}
			
			$row_store['table_id'] = "error";
			$row_store['table_id_error_code'] = "6";
			print_r(json_encode($row_store));	// Store Details array
			exit;
		}
		else
		{
			$row_store['table_id'] = "error";
			$row_store['table_id_error_code'] = "5";
			print_r(json_encode($row_store));	// Store Details array
			exit;
		}
	}
	else
	{
		$row_store['table_id'] = "error";
		$row_store['table_id_error_code'] = "4";
		print_r(json_encode($row_store));	// Store Details array
		exit;
	}
	exit;
}
else
{
	print_r("0");exit;
}