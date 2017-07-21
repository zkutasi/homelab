<?php
/* This script makes it possible to send pushover messages from a Synology NAS
Requirements:
   - A Synology NAS
   - In Web Station, create a new Virtual Host, on port 88 (at least the same one you specified above),
     I had problems on port 80
   - Place this script under /volume1/web
   - In Control Panel -> Notifications -> SMS, set up a new SMS notificator
     > Give as URL this (Set your AppKey!):
     http://localhost:88/synology-pushover.php?userkey=username&pwd=password&appkey=APPKEY&to=1234&text=Hello+World
     > Pair the necessary variables, set the AppKey as "Other"
     > Fill in ONLY ONE SMS number, can be anything, it will not be used
     > Test it with the test message button, it should work
*/

/************************************/
/********** CONFING START ***********/

// Only allow request made by localhost?
// Set this to false if this script is not running on your synology webserver (less secure)
$localOnly = false;

/********** CONFING END *************/
/************************************/
echo time();
// Validate httpHost and/or remote addr?
if ($localOnly) {
  if ($_SERVER['HTTP_HOST'] != 'localhost') {
    echo 'Not locahost';
    die;
  }
}

// Set variables
$options = array(
  'message' => isset($_GET['text']) ? $_GET['text'] : false,
  'token' => isset($_GET['appkey']) ? $_GET['appkey'] : false,
  'user' => isset($_GET['userkey']) ? $_GET['userkey'] : false
);
// Remove empty values
$options = array_filter($options);

// Quit if not exactly 3 get values were found
//if (count($options) != 3) {
//  echo 'invalid options';
//  die;
//}

// Do Pushover curl
curl_setopt_array($ch = curl_init(), array(
  CURLOPT_URL => "https://api.pushover.net/1/messages.json",
  CURLOPT_POSTFIELDS => $options
));
curl_exec($ch);
curl_close($ch);
?>
