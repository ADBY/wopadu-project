<?php

/*
*	Website - Privacy Policy
*	URL: http://localhost:8080/wopadu/ws/site-policy.php
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

require "config.php";

$result = mysqli_query($link, "SELECT * FROM site_content where id = 4");

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