<?php
	include 'core/init.php';
	require 'core/libraries/google/Google_Client.php';
	
	$type = $_GET['state'];
	$auth_code = $_GET['code'];
	$user_id = $user_data['user_id'];
	
	if($type == "drive") {
		$googleClient = new Google_Client();
		
		if(isset($auth_code)) {
			$googleClient->authenticate($auth_code);
			$returned_token = json_decode($googleClient->getAccessToken());
			
			$access_token = $returned_token->access_token;
			$refresh_token = $returned_token->refresh_token;
		}
		
		$query = mysql_query("SELECT auth_code FROM driveAccounts WHERE auth_code='$auth_code'");
		
		if(mysql_result($query, 0) == false && $refresh_token != "") {
			$insert = mysql_query("INSERT INTO driveAccounts (`access_token`, `refresh_token`, `auth_code`, `user_id`) VALUES ('$access_token', '$refresh_token', '$auth_code', '$user_id')");
			
			if(mysql_result($insert, 0)) {
				$_SESSION['flash_success'] = "Account added!";
				header("Location: woktop.php");
				exit();
			}
			else
				$woktopErrors[] = "There was a problem adding this account, please contact support";
		}
		else
			$woktopErrors[] = "This account has already been linked";
		
		$_SESSION['flash_errors'] = $woktopErrors;
		header("Location: woktop.php");
	}
?>