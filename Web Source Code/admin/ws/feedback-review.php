<?php

/*
*	Feedback Review
* 	URL: http://localhost:8080/wopadu/ws/feedback-review.php?ws=1&user_id=1&content=this-is-the-message
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

include("config.php");

if(!isset($_REQUEST['ws']) || !isset($_REQUEST['user_id']) || !isset($_REQUEST['content']) )
{
	print_r('0');	// Variable not set
	exit;
}
else if($_REQUEST['user_id'] == "" || $_REQUEST['content'] == "")
{
	print_r('1'); 	//	Values can't be empty
	exit;
}
else
{
	$content = mysqli_real_escape_string($link, $_REQUEST['content']);
	$user_id = mysqli_real_escape_string($link, $_REQUEST['user_id']);
	
	$result = mysqli_query($link, "select id from users where id='$user_id'");
	
	if(!$result)
	{
		print_r('2');     // Something went wrong, query error
		exit;
	}
	else
	{
		if(mysqli_num_rows($result) == 0)
		{
			print_r('3');     // User id does not exists
			exit;
		}
		else
		{
			$added_datetime = date('Y-m-d H:i:s');
			$result = mysqli_query($link, "INSERT INTO `feedback_review`(`user_id`, `review`, `added_datetime`) VALUES ('$user_id', '$content', '$added_datetime')");
			
			if(!$result)
			{
				print_r('4');    // Something went wrong, query error
				exit;
			}
			else
			{
				print_r('OK');	//	Review has been added
				exit;
			}
		}
	}	
}