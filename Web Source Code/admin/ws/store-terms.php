<?php

/*
*	Website - About Us
*	URL: http://localhost:8080/wopadu/ws/store-terms.php?ws=1&store_id=1
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

require "config.php";

$store_id = $_REQUEST['store_id'];

$result = mysqli_query($link, "SELECT terms FROM site_content where store_id = '$store_id'");

if(mysqli_num_rows($result) == 0)
{
	print_r('0');	// No Result found
}
else
{	
	$privacy = mysqli_fetch_assoc($result);
	
	/*echo "<pre>";
	print_r($privacy);
	echo "</pre>";*/
		
	print_r(json_encode($privacy));
}