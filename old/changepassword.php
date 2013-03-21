<?php
	include 'core/init.php';
	
	if(empty($_POST) === false) {
		$required_fields = array('password_old', 'password', 'password_again');
		
		foreach($_POST as $key => $value) {
			if(empty($value) && in_array($key, $required_fields) === true) {
				if(strstr($key, "_") === false)
					$woktopErrors[] = ucfirst($key) . " is required";
				else
					$woktopErrors[] = ucfirst(str_replace("_", " ", $key)) . " is required";
			}
		}
		
		if(md5($_POST['password_old']) === $user_data['password']) {
			if(trim($_POST['password']) != trim($_POST['password_again']))
				$woktopErrors[] = "New passwords do not match";
			else if(strlen(trim($_POST['password'])) <= 6)
				$woktopErrors[] = "New password must be at least six characters";
			else {
				change_password($user_data['user_id'], $_POST['password']);
				$_SESSION['flash_success'] = "Password changed!";
				header("Location: index.php");
				exit();
			}
		}
		else
			$woktopErrors[] = "Old password is incorrect";
		
		$_SESSION['flash_errors'] = $woktopErrors;
		header("Location: password.php");
	}
	else
		header("Location: index.php");
?>