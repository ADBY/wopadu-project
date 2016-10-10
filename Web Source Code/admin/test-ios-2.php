<?php


//$deviceIds 		= $data['registrationIds'];
//$message 		= "Scratch has been added:scratch:47";

if(!isset($_REQUEST['id']))
{
	echo "add id to url";
	exit;
}
else
{
	$dev_id = $_REQUEST['id'];
}
$string = "Scratch has been added";
$type = "scratch";
$message = "47";

$final_message_1 = $string;
$final_message_2 = $type . ':' . $message;	
	
// tr_to_utf function needed to fix the Turkish characters
//$message	= tr_to_utf($message);

// set time limit to zero in order to avoid timeout
set_time_limit(0);

// charset header for output
header('content-type: text/html; charset: utf-8');

// this is the pass phrase you defined when creating the key
$passphrase = '30091988';

// load your device ids to an array
$deviceIds = array($dev_id);


// this is where you can customize your notification

//$payload = '{"aps":{"alert":"' . $message . '","sound":"default"}}';
//$payload = '{"aps":{"alert":"' . $final_message_1 . '", "custom":"' . $final_message_2 . '", "sound":"default"}}';
$payload = '{"aps":{"alert":"Alert Message", "custom":"Custom Message", "sound":"default"}}';

$result = 'Start' . '<br />';

////////////////////////////////////////////////////////////////////////////////
// start to create connection
$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'components/WopaduDist.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

echo count($deviceIds) . ' devices will receive notifications.<br />';

foreach ($deviceIds as $item) {
	// wait for some time
	sleep(1);

	// Open a connection to the APNS server
	//$fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $err, $errstr, 60, STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT, $ctx);
	
	$fp = stream_socket_client('ssl://gateway.push.apple.com:2195', $err, $errstr, 60, STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT, $ctx);

	if (!$fp) {
		exit("Failed to connect: $err $errstr" . '<br />');
	} else {
		echo 'Apple service is online. ' . '<br />';
	}

	// Build the binary notification
	$msg = chr(0) . pack('n', 32) . pack('H*', $item) . pack('n', strlen($payload)) . $payload;

	// Send it to the server
	$result = fwrite($fp, $msg, strlen($msg));

	if (!$result) {
		echo 'Undelivered message count: ' . $item . '<br />';
	} else {
		echo 'Delivered message count: ' . $item . '<br />';
	}

	if ($fp) {
		fclose($fp);
		echo 'The connection has been closed by the client' . '<br />';
	}
}

echo count($deviceIds) . ' devices have received notifications.<br />';

// set time limit back to a normal value
set_time_limit(30);