<?php

// Put your device token here (without spaces):
//$deviceToken = 'cd591070c8d603cfc1d10046be48d82b6c581742cccf2a1e2808145a54ccf6c3';
$iPhone5 = 'cd591070c8d603cfc1d10046be48d82b6c581742cccf2a1e2808145a54ccf6c3';
$iPhone6 = '30465565af89b7d114259f4749509c9f77c5309d4b68a710fbc9674aa76df3b9';

// Put your private key's passphrase here:
//$passphrase = 'marissa123';

// Put your alert message here:
//$message = 'My first push notification!';

$deviceToken = $_POST['deviceToken'];
$passphrase = $_POST['passphrase'];
$message = $_POST['message'];
$deliverToToken = 'cd591070c8d603cfc1d10046be48d82b6c581742cccf2a1e2808145a54ccf6c3'

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'apns-dev.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
stream_context_set_option($ctx, 'ssl', 'verify_peer', false);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$body['aps'] = array(
	'alert' => $message,
	'sound' => 'default'
	);

// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deliverToToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
