<?php

/*
*	Website - About Us
*	URL: http://localhost:8080/wopadu/ws/site-about-us.php?lang=hi
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

require_once "config.php";
require_once "define.php";
require_once "functions.php";

if(isset($_REQUEST['lang'])) {
	$language = getLanguage($link, $_REQUEST['lang']);
}

$lang_sql = "";
if(isset($language)) {
	$lang_sql = ", `value_".$language['language_lc']."`";
}
		
$result = mysqli_query($link, "SELECT id, title, value".$lang_sql." FROM site_content where id = 1");

if(mysqli_num_rows($result) == 0)
{
	print_r('0');	// No Result found
}
else
{	
	$about_us = mysqli_fetch_assoc($result);
	
	if(isset($language))
	{
		$value 			= $about_us['value'];
		$value_lang 	= $about_us['value_'.$language['language_lc']];
		
		if($value_lang != "") {
			$about_us['value'] = $value_lang;
		}
		unset($about_us['value_'.$language['language_lc']]);
	}

	/*echo "<pre>";
	print_r($about_us);
	echo "</pre>";*/
			
	print_r(json_encode($about_us, JSON_UNESCAPED_UNICODE));
}