<?php
	include 'core/init.php';
	$from = $_POST['from'];
	$username = $_POST['username'];
	$email = $_POST['email'];
	$error = $_POST['error'];
	$information = $_POST['information'];
	
	$body = "From: $from\nUsername: $username\nEmail: $email\nError: $error\nInformation: $information";
	email("me@patrickcason.com", "Woktop - Bug Report", $body);
	
	$_SESSION['flash_success'] = "Bug reported, thanks!";
	header("Location: $from");
	exit();
?>