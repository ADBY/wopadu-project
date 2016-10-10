<?php

/*
*	Website - Website Terms
*	URL: http://localhost:8080/wopadu/ws/site-terms.php?lang=hi
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
		
$result = mysqli_query($link, "SELECT id, title, value".$lang_sql." FROM site_content where id = 2");

if(mysqli_num_rows($result) == 0)
{
	print_r('0');	// No Result found
}
else
{	
	$privacy = mysqli_fetch_assoc($result);
	
	if(isset($language))
	{
		$value 			= $privacy['value'];
		$value_lang 	= $privacy['value_'.$language['language_lc']];
		
		if($value_lang != "") {
			$privacy['value'] = $value_lang;
		}
		unset($privacy['value_'.$language['language_lc']]);
	}
	
	/*echo "<pre>";
	print_r($privacy);
	echo "</pre>";*/
		
	//print_r(json_encode($privacy));
	print_r(json_encode($privacy, JSON_UNESCAPED_UNICODE));
}