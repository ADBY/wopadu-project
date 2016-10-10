<?php

/*
*	Get list of Languages
* 	URL: http://localhost:8080/wopadu/ws-lang/languages.php
*/

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

$result_lang = mysqli_query($link, "SELECT id, language_name, language_name_2, language_code from languages WHERE status = 1");

if(!$result_lang)
{
	print_r('0');	// Something went wrong, Please try again
	exit;
}
else
{
	if(mysqli_num_rows($result_lang) == 0)
	{
		print_r('1');	// No languages found
		exit;
	}
	else
	{
		$languages = [];
		while($row_lang = mysqli_fetch_assoc($result_lang))
		{
			$languages[] = $row_lang;
		}
		//echo 1;
		//print_r(json_encode($languages));	// Languages Array
		print_r(json_encode($languages, JSON_UNESCAPED_UNICODE));
		exit;
	}
}