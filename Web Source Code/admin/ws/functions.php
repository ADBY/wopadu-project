<?php

/*
*	Current Time
*/
function currentTime()
{
    return date("Y-m-d H:i:s");
}

/*
*	Formated Date time
*/
function formatDate($date)
{
    if($date != NULL && $date != "0000-00-00 00:00:00")
    {
        return date('d-m-Y h:i a', strtotime($date));
    }
    else
    {
        return "-";
    }   
}

/*
 *      Get Yes or No String
 *
*/

function getYesOrNo($value)
{
    if($value == 1)
    {
        return "Yes";
    }
    else
    {
        return "No";
    }
}

/*
*	Random String Generator
*/
function generateRandomString($length = 10)
 {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) 
	{
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

/*
*	Verification Code Generator
*/
function verifCodeGen($length = 6)
 {
    $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) 
	{
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

/*
*	Verification Number Generator
*/
function verifCodeGenNum($length = 4)
 {
    $characters = '0123456789';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) 
	{
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

/*
*	Registered Device Type
*	Type: 
*	1. iOs
*	2. Android
*/

function getDeviceType($value)
{
    if($value == 1)
    {
            return "iOs";
    }
    else if($value == 2)
    {
            return "Android";
    }
}

/*
*	Main Promotion Type
*	1 = Promotion based on Date Range
*	2 = Promotion based on fixed days range
*/
function promotion_main($value)
{
	if($value == 1)
	{
		return "Date range";
	}
	else if($value == 2)
	{
		return "Fixed days";
	}
}

/*
*	Sub Promotion Type
*	1 = Discount Percentage
*	2 = Fixed Price
*/
function promotion_sub($value)
{
	if($value == 1)
	{
		return "Discount Percentage";
	}
	else if($value == 2)
	{
		return "Fixed Price";
	}
}

/*
*	Order Type
*	1 = Online
*	2 = Offline
*/
function order_type($value)
{
	if($value == 1)
	{
		return "Online";
	}
	else if($value == 2)
	{
		return "Offline";
	}
}


/*
*	Order Status
*	1 = Received   – Red color
*	2 = Processing – Orange color
*	3 = Ready to be collected – Green color
*	4 = Completed – Brown color
*	5 = Cancelled – Grey color
*/
function order_status($value)
{
	if($value == 1)
	{
		return "Received";
	}
	else if($value == 2)
	{
		return "Processing";
	}
	else if($value == 3)
	{
		return "Ready to be collected";
	}
	else if($value == 4)
	{
		return "Completed";
	}
	else
	{
		return "Cancelled";
	}
}

// Get languages function
function getLanguage($link, $lang_code)
{
	$lang_code = mysqli_real_escape_string($link, $lang_code);
	$res = mysqli_query($link, "SELECT * FROM languages WHERE `language_code` = '$lang_code' AND status = 1 LIMIT 1");
	if(!$res) {
		//return "LANG-E1";		// Something went wrong, Query Error
		echo "LANG-E1";;
		//die();
		exit;
	} else {
		if(mysqli_num_rows($res) == 0) {
			//return "LANG-E2";		// Language does not found
			echo "LANG-E2";
			//die();
			exit;
		} else {
			return mysqli_fetch_assoc($res);
		}
	}	
}