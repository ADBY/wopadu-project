<?php

require_once "config.php";

$path_full = '../images/users';

//$path_full = 'http://'.$_SERVER['HTTP_HOST'].'/meatonline/users';
//$path_full = 'http://bridgetechnocrats.in/meatonline/users';
//$path_full=Yii::app()->basePath.'/../upload/fault';
		
		
if (!function_exists('http_response_code'))
{
	function http_response_code($newcode = NULL)
	{
		static $code = 200;
		if($newcode !== NULL)
		{
			header('X-PHP-Response-Code: '.$newcode, true, $newcode);
			if(!headers_sent())
				$code = $newcode;
		}       
		return $code;
	}
}

// This is an arbitary limit.  Your PHP server has it's own limits, which may be more or 
// less than this limit.  Consider this an exercise in learning more about how your PHP
// server is configured.   If it allows less, then your script will fail.
//
// See: http://stackoverflow.com/questions/2184513/php-change-the-maximum-upload-file-size
// for more information on file size limits.

$MAX_FILESIZE = 5 * 1024 * 100;  // 500 Kb limit -- arbitrary value based on your needs

if ((isset($_SERVER["HTTP_FILENAME"])) && (isset($_SERVER["CONTENT_TYPE"])) && (isset($_SERVER["CONTENT_LENGTH"]))) {
	$filesize = $_SERVER["CONTENT_LENGTH"];
	// get the base name of the file.  This should remove any path information, but like anything
	// that writes to your file server, you may need to take extra steps to harden this to make sure
	// there are no path remnants in the file name.
	$filename = basename($_SERVER["HTTP_FILENAME"]);
	$filetype = $_SERVER["CONTENT_TYPE"];

	// enforce the arbirary file size limits here 
	if ($filesize > $MAX_FILESIZE) {
		http_response_code(413);
		echo("File too large");
		exit;
	}
	// Make sure the filename is unique.
	// This will cause files after 100 of the same name to overwrite each other.
	// And it won't notify you.  Don't depend on this logic for production.
	// You should code this to fit your needs.
	 
	/* PUT data comes in on the stdin stream */
	$putdata = fopen("php://input", "r");

	if ($putdata) {
		/* Open a file for writing */
		
		$fileArray=explode(".",$filename);
		
		$picId=$fileArray[0];
		
		if (!file_exists($path_full))
		{
			$oldmask = umask(0);
			mkdir($path_full, 0777);
			umask($oldmask);
		}
		
		$tmpfname = tempnam($path_full, "webservice");
		$fp = fopen($tmpfname, "w");
		if ($fp) {
			/* Read the data 1 KB at a time and write to the file */
			while ($data = fread($putdata, 1024)) {
				fwrite($fp, $data);
			}
			/* Close the streams */
			fclose($fp);
			fclose($putdata);
			
			$result = rename($tmpfname, $path_full."/" . $filename);
			
			if ($result) {
				http_response_code(201);
				chmod($path_full.'/'.$filename,0755);   // correct 

				/*$model=FaultReporting::model()->findByPk($picId);
				$model->fault_photo=$filename;
				$model->save();
				*/
				echo("File Created " . $filename);
				mysqli_query($link, "UPDATE users SET image = '$filename' WHERE id = '$picId'");
				
				
			} else {
				http_response_code(403);
				echo("Renaming file to upload/" . $filename . " failed.");
			}          
		} else {
			http_response_code(403);
			echo("Could not open tmp file " . $tmpfname);
		}
	} else {
		http_response_code(403);
		echo("Could not read upload stream.");
	}
} else {
	http_response_code(500);
	echo("Malformed Request");
}
exit;