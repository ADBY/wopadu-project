<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

function actionIpn($data)
{
	$deviceIds 		= $data['registrationIds'];
	$message 		= $data['message'];
	
	// set time limit to zero in order to avoid timeout
	set_time_limit(0);

	// charset header for output
	header('content-type: text/html; charset: utf-8');

	// this is the pass phrase you defined when creating the key
	$passphrase = '30091988';

	
	// load your device ids to an array
	/* $deviceIds = array(
	  'lh142lk3h1o2141p2y412d3yp1234y1p4y1d3j4u12p43131p4y1d3j4u12p4313',
	  'y1p4y1d3j4u12p43131p4y1d3j4u12p4313lh142lk3h1o2141p2y412d3yp1234'
	  ); */

	// this is where you can customize your notification
	//$payload = '{"aps":{"alert":"' . $message . '","sound":"default"}}';
	$payload = '{"aps":{"alert":"Order is ready", "custom":"' . $message . '","sound":"N_Sound.wav"}}';
	
	//echo $payload;
	//exit;
	
	$result = 'Start' . '<br />';

	////////////////////////////////////////////////////////////////////////////////
	// start to create connection
	$ctx = stream_context_create();
	stream_context_set_option($ctx, 'ssl', 'local_cert', 'WopaduShrFinal.pem');
	stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

	$op_msg = count($deviceIds) . ' devices will receive notifications.<br />';

	foreach ($deviceIds as $item) {
		// wait for some time
		sleep(1);

		// Open a connection to the APNS server			
		$fp = stream_socket_client('ssl://gateway.push.apple.com:2195', $err, $errstr, 60, STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT, $ctx);

		if (!$fp) {
			exit;
			//exit("Failed to connect: $err $errstr" . '<br />');
		} else {
			$op_msg .= 'Apple service is online. ' . '<br />';
		}

		// Build the binary notification
		$msg = chr(0) . pack('n', 32) . pack('H*', $item) . pack('n', strlen($payload)) . $payload;

		// Send it to the server
		$result = fwrite($fp, $msg, strlen($msg)); 

		if (!$result) {
			$op_msg .= 'Undelivered message count: ' . $item . '<br />';
		} else {
			$op_msg .= 'Delivered message count: ' . $item . '<br />';
		}

		if ($fp) {
			fclose($fp);
			$op_msg .= 'The connection has been closed by the client' . '<br />';
		}
	}

	$op_msg .= count($deviceIds) . ' devices have received notifications.<br />';

	// set time limit back to a normal value
	echo $op_msg;
	set_time_limit(30);
}

actionIpn(['registrationIds' => ['37c178d5feeb56f50dbe3c027de7c48ec3b455d5fc258759714ad7cdda4ec2d7'], 'message' => 'Hey You']);