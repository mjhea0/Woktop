<?php
	include 'core/init.php';
	
	if(empty($_POST) === false) {
		$required_fields = array('email', 'username', 'password', 'password_again');
		
		foreach($_POST as $key => $value) {
			if(empty($value) && in_array($key, $required_fields) === true) {
				if(strstr($key, "_") === false)
					$woktopErrors[] = ucfirst($key) . " is required";
				else
					$woktopErrors[] = ucfirst(str_replace("_", " ", $key)) . " is required";
			}
		}
		
		if(empty($woktopErrors) === true) {
			if(user_exists($_POST['username']) === true)
				$woktopErrors[] = "Username is already taken";
			if(preg_match("/\\s/", $_POST['username']) == true)
				$woktopErrors[] = "Username can't contain spaces";
			if(strlen($_POST['password']) <= 6)
				$woktopErrors[] = "Password must be at least six characters";
			if($_POST['password'] != $_POST['password_again'])
				$woktopErrors[] = "Passwords do not match";
			if(filter_var($_POST['email'], FILTER_VALIDATE_EMAIL) === false)
				$woktopErrors[] = "Email is invalid";
			if(email_exists($_POST['email']) === true)
				$woktopErrors[] = "Email is already taken";
				
			if(empty($woktopErrors) === true) {
				$register_data = array(
					'email' => $_POST['email'],
					'email_code' => md5($_POST['username'] + microtime()),
					'username' => $_POST['username'],
					'password' => $_POST['password']
				);
				
				register_user($register_data);
				$_SESSION['flash_success'] = "Thanks for registering, please check your email to activate your account!";
				header("Location: index.php");
				exit();
			}
		}
		
		$_SESSION['flash_errors'] = $woktopErrors;
		header("Location: register.php");
	}
	else
		header("Location: register.php");
?>
