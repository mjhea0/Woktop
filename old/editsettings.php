<?php
	include 'core/init.php';
	
	if(empty($_POST) === false) {
		if(!empty($_POST['email'])) {
			if(filter_var($_POST['email'], FILTER_VALIDATE_EMAIL) === false)
				$woktopErrors[] = "Email is invalid";
			if(email_exists($_POST['email']) === true)
				$woktopErrors[] = "Email is already taken";
			else {
				$settings_data = array(
					'first_name' => $_POST['first_name'],
					'last_name' => $_POST['last_name'],
					'email' => $_POST['email']
				);
				$data = change_settings($user_data['user_id'], $settings_data);
				$_SESSION['flash_success'] = "Settings changed!";
				header("Location: index.php");
				exit();
			}
		}
		else {
			$settings_data = array(
				'first_name' => $_POST['first_name'],
				'last_name' => $_POST['last_name']
			);
			$data = change_settings($user_data['user_id'], $settings_data);
			$_SESSION['flash_success'] = "Settings changed!";
			header("Location: index.php");
			exit();
		}
		
		$_SESSION['flash_errors'] = $woktopErrors;
		header("Location: settings.php");
	}
	else
		header("Location: index.php");
?>