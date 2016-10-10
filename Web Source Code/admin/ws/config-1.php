<?php

$link = mysqli_connect("localhost", "root", "shirish", "wopado") or die('Database connection error '. mysqli_error);
mysqli_query ($link, "set character_set_client='utf8'"); 
mysqli_query ($link, "set character_set_results='utf8'"); 
mysqli_query ($link, "set collation_connection='utf8_general_ci'"); 