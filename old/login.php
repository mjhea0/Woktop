<?php
	include 'core/init.php';
	
	if(empty($_POST) === false) {
		$username = $_POST['username'];
		$password = $_POST['password'];
		
		if(empty($username) === true || empty($password) === true) {
			$woktopErrors[] = 'Username or password is blank';
		}
		else if(user_exists($username) === false) {
			$woktopErrors[] = 'Invalid username/password combination';
		}
		else if(user_active($username) === false) {
			$woktopErrors[] = 'Please activate your account first';
		}
		else {
			if(strlen($password) > 32)
				$woktopErrors[] = 'Password too long';
			
			$login = login($username, $password);
			
			if($login === false) {
				$woktopErrors[] = 'Invalid username/password combination';
			}
			else {
				$_SESSION['user_id'] = $login;
				$_SESSION['flash_success'] = "Welcome!";
				header("Location: $username");
				exit();
			}
		}
		
		$_SESSION['flash_errors'] = $woktopErrors;
		header("Location: index.php");
	}
	else
		header("Location: index.php");
?>