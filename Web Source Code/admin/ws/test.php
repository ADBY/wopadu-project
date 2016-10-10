<?php

header("Content-type: text/plain");	//Convert to plain text

require_once "config.php";

$up_card = mysqli_query($link, "UPDATE users SET pin_number = NULL, card_number = '', cvv_number = '', expiry_date_month = '', expiry_date_year = '' WHERE id = '2'");

if($up_card)
{
	echo 1;
	
}
else
{
	echo 2;
}

$up_card2 = mysqli_query($link, "DELETE FROM stripe_accounts WHERE user_id= 2");

if($up_card2)
{
	echo 1;
	
}
else
{
	echo 2;
}