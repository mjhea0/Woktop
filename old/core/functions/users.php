<?php
	function user_exists($username) {
		$username = sanitize($username);
		$query = mysql_query("SELECT user_id FROM users WHERE username = '$username'");
		return (mysql_result($query, 0)) ? true : false;
	}
	
	function user_active($username) {
		$username = sanitize($username);
		$query = mysql_query("SELECT user_id FROM users WHERE username = '$username' AND active = 1");
		return (mysql_result($query, 0)) ? true : false;
	}
	
	function user_id_from_username($username) {
		$username = sanitize($username);
		$query = mysql_query("SELECT user_id FROM users WHERE username = '$username'");
		return mysql_result($query, 0, 'user_id');
	}
	
	function user_id_from_email($email) {
		$email = sanitize($email);
		$query = mysql_query("SELECT user_id FROM users WHERE email = '$email'");
		return mysql_result($query, 0, 'user_id');
	}
	
	function login($username, $password) {
		$user_id = user_id_from_username($username);
		$username = sanitize($username);
		$password = md5($password);
		
		$query = mysql_query("SELECT user_id FROM users WHERE username = '$username' AND password = '$password'");
		return (mysql_result($query, 0)) ? $user_id : false;
	}
	
	function logged_in() {
		return (isset($_SESSION['user_id'])) ? true : false;
	}
	
	function user_data($user_id) {
		$data = array();
		$user_id = (int)$user_id;
		
		$func_num_args = func_num_args();
		$func_get_args = func_get_args();
		
		if($func_num_args > 1) {
			unset($func_get_args[0]);
			
			$fields = '`' . implode('`, `', $func_get_args) . '`';
			$data = mysql_fetch_assoc(mysql_query("SELECT $fields FROM users WHERE user_id = '$user_id'"));
			return $data;
		}
	}
	
	function users_count() {
		$query = mysql_query("SELECT user_id from users WHERE active = 1");
		return mysql_num_rows($query);
	}
	
	function email_exists($email) {
		$email = sanitize($email);
		$query = mysql_query("SELECT user_id FROM users WHERE email = '$email'");
		return (mysql_result($query, 0)) ? true : false;
	}
	
	function register_user($register_data) {
		array_walk($register_data, 'array_sanitize');
		$register_data['password'] = md5($register_data['password']);
		$fields = '`' . implode('`, `', array_keys($register_data)) . '`';
		$data = '\'' . implode('\', \'', $register_data) . '\'';
		
		mysql_query("INSERT INTO users ($fields) VALUES ($data)");
		
		email($register_data['email'], "Activate your account", "Hello " . $register_data['username'] . "!\n\nYou need to activate your account, please click or copy and paste the link below:\n\nhttp://www.woktop.com/activate.php?email=" . $register_data['email'] . "&confirmation_code=" . $register_data['email_code'] . "\n\nLove,\nThe Woktop Team");
	}
	
	function protected_page() {
		if(logged_in() === false)
			header("Location: index.php");
	}
	
	function logged_in_redirect() {
		if(logged_in() === true)
			header("Location: index.php");
	}
	
	function admin_protect() {
		if(is_admin() === false)
			header("Location: index.php");
	}
	
	function is_admin() {
		if(logged_in() === true) {
			if($user_data['type'] == 1)
				return true;
			else
				return false;
		}
	}
	
	function user_page_exists($username) {
		if(user_exists($username) === false)
			header("Location: index.php");
	}
	
	function change_password($user_id, $password) {
		$user_id = (int)$user_id;
		$password = md5($password);
		
		mysql_query("UPDATE users SET password = '$password', password_recover = 0 WHERE user_id = '$user_id'");
	}
	
	function activate($email, $confirmation_code) {
		$email = sanitize($email);
		$confirmation_code = sanitize($confirmation_code);
		
		$query = mysql_query("SELECT user_id FROM users WHERE email = '$email' AND email_code = '$confirmation_code'");
		
		return (mysql_result($query, 0)) ? true : false;
	}
	
	function change_settings($user_id, $settings_data) {
		array_walk($settings_data, 'array_sanitize');
		$data = "";
		
		foreach($settings_data as $key => $value) {
			if(!empty($value))
				$data .= $key . " = '" . $value . "', ";
		}
		
		$data = substr($data, 0, -2);
		
		mysql_query("UPDATE users SET $data WHERE user_id = '$user_id'");
	}
	
	function recover($mode, $email) {
		$mode = sanitize($mode);
		$email = sanitize($email);
		
		$user_data = user_data(user_id_from_email($email), 'user_id', 'first_name', 'username');
		
		if($mode == "username")
			email($email, "Woktop - Recover Username", "Greetings ".$user_data['first_name'].",\n\nRecently you requested to recover your username on Woktop.  Here it is:\n\n\t".$user_data['username']."\n\nLove,\nThe Woktop Team");
		elseif($mode == "password") {
			$generated_password = substr(md5(rand(999, 999999)), 0, 8);
			change_password($user_data['user_id'], $generated_password);
			change_settings($user_data['user_id'], array('password_recover' => 1));
			email($email, "Woktop - Recover Password", "Greetings ".$user_data['first_name'].",\n\nRecently you requested to recover your password on Woktop.  We've temporarily reset the password to the following:\n\n\t".$generated_password."\n\nLove,\nThe Woktop Team");
		}
	}
?>