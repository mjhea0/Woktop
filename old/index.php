<?php include 'core/init.php'; ?>
<?php
	if(logged_in() === true) {
		$username = $user_data['username'];
		header("Location: $username");
		exit();
	} else { ?>
<?php include 'includes/header.php'; ?>
<div id="wrap">
	<?php flash_success(); ?>
	<?php flash_errors(); ?>
    <div id="login">
        <h2 class="aligncenter">Woktop!</h2>
    	<form action="login.php" method="post">
        	<input type="text" name="username" placeholder="Username">
            <input type="password" name="password" placeholder="Password">
            <input type="submit" name="submit" value="Login">
        </form>
        <p class="small aligncenter">Forget your <a href="recover.php?mode=username">username</a> or <a href="recover.php?mode=password">password</a>?</p>
        <p class="small aligncenter"><a href="register.php">Don't have an account?</a></p>
    </div>
</div>
<?php include 'includes/footer.php'; ?>
<?php } ?>