<?php
$api_key = 'AIzaSyAbp2EI7GsTTKzcqU9LPctBMRrf3eRG_uw';
$text = 'How are you';
$source="en";
$target="fr";
 
$obj = translate($api_key,$text,$target,$source);
if($obj != null)
{
    if(isset($obj['error']))
    {
        echo "Error is : ".$obj['error']['message'];
    }
    else
    {
        echo "Translsated Text: ".$obj['data']['translations'][0]['translatedText']."n";
        if(isset($obj['data']['translations'][0]['detectedSourceLanguage'])) //this is set if only source is not available.
            echo "Detecte Source Languge : ".$obj['data']['translations'][0]['detectedSourceLanguage']."n";     
    }
}
else
    echo "UNKNOW ERROR";
 
function translate($api_key,$text,$target,$source=false)
{
    $url = 'https://www.googleapis.com/language/translate/v2?key=' . $api_key . '&q=' . rawurlencode($text);
    $url .= '&target='.$target;
    if($source)
     $url .= '&source='.$source;
 
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);                 
    curl_close($ch);
 
    $obj =json_decode($response,true); //true converts stdClass to associative array.
    return $obj;
}   
 
?>