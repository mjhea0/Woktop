<?php include 'core/init.php'; ?>
<?php logged_in_redirect(); ?>
<?php include 'includes/header.php'; ?>
<div id="wrap">
	<?php flash_success(); ?>
	<?php flash_errors(); ?>
    <div id="register">
        <h2 class="aligncenter">Woktop!</h2>
    	<form action="newuser.php" method="post">
        	<input type="text" name="email" placeholder="Email address">
        	<input type="text" name="username" placeholder="Username">
            <input type="password" name="password" placeholder="Password">
            <input type="password" name="password_again" placeholder="Confirm">
            <input type="submit" name="submit" value="Register">
        </form>
    </div>
</div>
<?php include 'includes/footer.php'; ?>