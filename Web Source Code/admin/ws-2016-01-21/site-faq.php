<?php

/*
*	Website - FAQ
*	URL: http://localhost:8080/wopado/ws/site-faq.php
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

require "config.php";

$result = mysqli_query($link, "SELECT * FROM site_content where id = 3");

if(mysqli_num_rows($result) == 0)
{
	print_r('0');	// No Result found
}
else
{	
	$about_us = mysqli_fetch_assoc($result);
	
	/*echo "<pre>";
	print_r($about_us);
	echo "</pre>";*/
		
	print_r(json_encode($about_us));
}