<?php
	include 'core/init.php';
	logged_in_redirect();

	if(isset($_GET['email']) && isset($_GET['confirmation_code'])) {
		$email = trim($_GET['email']);
		$confirmation_code = trim($_GET['confirmation_code']);
		
		if(email_exists($email) === false)
			header("Location: index.php");
		
		$activation = activate($email, $confirmation_code);
		
		if($activation === true) {
			mysql_query("UPDATE users SET active = 1 WHERE email = '$email'");
			$_SESSION['flash_success'] = "Thanks for activating your account, you may now log in!";
			header("Location: index.php");
			exit();
		}
		else
			header("Location: index.php");
	}
	else
		header("Location: index.php");
?>