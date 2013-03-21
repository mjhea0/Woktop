<?php
	include 'core/init.php';
	
	$mode = $_GET['mode'];
	
	if(empty($_POST) === false) {
		if($mode == "username") {
			if(email_exists($_POST['email']) === true) {
				recover($_GET['mode'], $_POST['email']);
				$_SESSION['flash_success'] = "Email sent with your username!";
				header("Location: login.php");
				exit();
			}
			else
				$woktopErrors[] = "Please enter a valid email";
			
			$_SESSION['flash_errors'] = $woktopErrors;
			header("Location: recover.php?mode=username");
		}
		elseif($mode == "password") {
			if(email_exists($_POST['email']) === true) {
				recover($_GET['mode'], $_POST['email']);
				$_SESSION['flash_success'] = "Email sent with your password!";
				header("Location: login.php");
				exit();
			}
			else
				$woktopErrors[] = "Please enter a valid email address";
			
			$_SESSION['flash_errors'] = $woktopErrors;
			header("Location: recover.php?mode=password");
		}
		else {
			header("Location: index.php");
			exit();
		}
	}
	else {
		header("Location: index.php");
		exit();
	}
?>