<?php

header("Content-type: text/plain"); //makes sure entities are not interpreted

require "config.php";

$sql2 = "DELETE FROM `device_registered` WHERE user_id = 5";


if(mysqli_query($link, $sql2))
{
	echo "ok2";
	$sql1 = "DELETE FROM `orders` WHERE user_id = 5";
	
	if(mysqli_query($link, $sql1))
	{
		echo "ok1";
		$sql = "DELETE FROM users WHERE id = 5";
	
		if(mysqli_query($link, $sql))
		{
			echo "ok";
		}
		else
		{
		
			echo "err";
		}
	}
	else
	{
	
		echo "err1";
	}


}
else
{

	echo "err2";
}





?>