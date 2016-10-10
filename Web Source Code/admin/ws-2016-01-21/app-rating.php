<?php

/*
*	Application Rating
*
*	My Rating:
*	URL: http://localhost:8080/wopado/ws/app-rating.php?action=view&user_id=1
*
*	Add/Update Rating
* 	URL: http://localhost:8080/wopado/ws/app-rating.php?action=add_update&user_id=1&rating=3&review=awesome...
*
*	All Ratings of Application:
*	URL: http://localhost:8080/wopado/ws/app-rating.php?action=all&page=1
*/

header("Content-type: text/plain"); //makes sure entities are not interpreted

include("config.php");

if(!isset($_REQUEST['action']))
{
	print_r('0');	// Variable not set
	exit;
}
else if($_REQUEST['action'] == "add_update")
{
	
	if(!isset($_REQUEST['user_id']) || !isset($_REQUEST['rating']) || !isset($_REQUEST['review']))
	{
		print_r('0');	// Variable not set
		exit;
	}
	else if($_REQUEST['user_id'] == "" || $_REQUEST['rating'] == "")
	{
		print_r('1'); 	//	User id and rating can't be empty
		exit;
	}
	else
	{
		$rating = mysqli_real_escape_string($link, $_REQUEST['rating']);
		$review = mysqli_real_escape_string($link, $_REQUEST['review']);
		$user_id = mysqli_real_escape_string($link, $_REQUEST['user_id']);
		
		$added_date = date('Y-m-d H:i:s');
		
		$result = mysqli_query($link, "select id from app_rating where user_id = '$user_id'");
		
		if(!$result)
		{
			print_r('2');     // Something went wrong, query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($result) > 0)
			{
				$result = mysqli_query($link, "UPDATE `app_rating` SET `user_id` = '$user_id', `rating` = '$rating', `review` = '$review', `added_date` = '$added_date' WHERE user_id = $user_id");
			}
			else
			{
				$result = mysqli_query($link, "INSERT INTO `app_rating`(`user_id`, `rating`, `review`, `added_date`) VALUES ('$user_id', '$rating', '$review', '$added_date')");
			}
			if(!$result)
			{
				print_r('3');    // Something went wrong, query error
				exit;
			}
			else
			{
				print_r('OK');	//	Rating has been added
				exit;
			}
		}	
	}
}
else if($_REQUEST['action'] == "view")
{
	
	if(!isset($_REQUEST['user_id']))
	{
		print_r('0');	// Variable not set
		exit;
	}
	else if($_REQUEST['user_id'] == "")
	{
		print_r('1'); 	//	User id can't be empty
		exit;
	}
	else
	{
		$user_id = mysqli_real_escape_string($link, $_REQUEST['user_id']);
		
		$result = mysqli_query($link, "select * from app_rating where user_id = '$user_id'");
		
		if(!$result)
		{
			print_r('2');     // Something went wrong, query error
			exit;
		}
		else
		{
			if(mysqli_num_rows($result) == 0)
			{
				print_r("NOT_REVIEWED");	// User has not reviewd yet.
				exit;
			}
			else
			{
				$row = mysqli_fetch_assoc($result);
				print_r(json_encode($row));	//	Rating details array
				exit;
			}
		}	
	}
}
else if($_REQUEST['action'] == "all")
{
	
	$limit = 20;
	if(!isset($_REQUEST['page']))
	{
		$page = 0;
		$offset = $page * $limit;
	}
	else
	{
		$page = $_REQUEST['page'];
		if($page > 0)
		{
			$page = ($page - 1);
		}
		$offset = $page * $limit;
	}
	
	$result = mysqli_query($link, "SELECT R.*, U.first_name, U.last_name FROM app_rating as R INNER JOIN users as U ON U.id = R.user_id order by R.id desc LIMIT $offset, $limit");
		
	if(!$result)
	{
		print_r('2');     // Something went wrong, query error
		exit;
	}
	else
	{
		if(mysqli_num_rows($result) == 0)
		{
			print_r("EMPTY");	// There is no reviews for application
			exit;
		}
		else
		{
			$output = [];
			
			while($row = mysqli_fetch_assoc($result))
			{
				$output[] = $row;
			}
			
			print_r(json_encode($output));	//	Rating details array
			exit;
		}
	}
}