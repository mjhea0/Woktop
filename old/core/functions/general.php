<?php
	function sanitize($data) {
		return htmlentities(strip_tags(mysql_real_escape_string($data)));
	}
	
	function array_sanitize(&$data) {
		$data = htmlentities(strip_tags(mysql_real_escape_string($data)));
	}
	
	function flash_errors() {
		if(!empty($_SESSION['flash_errors'])) {
			echo "<ul class='flash errors'>";
			foreach($_SESSION['flash_errors'] as $error) {
				echo "<li>".$error."</li>";
			}
			echo "</ul>";
		}
			
		$current_file = explode("/", $_SERVER['SCRIPT_NAME']);
		$current_file = end($current_file);
		$redirect_url = trim($_SERVER['REDIRECT_URL'], "/");
		
		if($current_file !== "woktop.php" || user_exists($redirect_url))
			$_SESSION['flash_errors'] = "";
	}
	
	function flash_success() {
		if(!empty($_SESSION['flash_success'])) {
			echo "<ul class='flash success'>";
			echo "<li>".$_SESSION['flash_success']."</li>";
			echo "</ul>";
		}
		
		$current_file = explode("/", $_SERVER['SCRIPT_NAME']);
		$current_file = end($current_file);
		$redirect_url = trim($_SERVER['REDIRECT_URL'], "/");
		
		if($current_file !== "woktop.php" || user_exists($redirect_url))
			$_SESSION['flash_success'] = "";
	}
	
	function email($to, $subject, $body) {
		mail($to, $subject, $body, 'From: me@patrickcason.com');
	}
?>