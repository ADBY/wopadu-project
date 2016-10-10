<?php
    $apiKey = 'AIzaSyAbp2EI7GsTTKzcqU9LPctBMRrf3eRG_uw';
    $text = 'Hello world!';
    echo $url = 'https://www.googleapis.com/language/translate/v2?key=' . $apiKey . '&q=' . rawurlencode($text) . '&source=en&target=fr';

    $handle = curl_init($url);
    curl_setopt($handle, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($handle);                 
    $responseDecoded = json_decode($response, true);
    curl_close($handle);
	
	echo "<pre>";
	print_r($response);
	echo "<br>";
	print_r($responseDecoded);
	echo "<br>";

    echo 'Source: ' . $text . '<br>';
    echo 'Translation: ' . $responseDecoded['data']['translations'][0]['translatedText'];
	
	echo "</pre>";
	exit;

?>