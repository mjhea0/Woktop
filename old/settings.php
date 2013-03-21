<?php include 'core/init.php'; ?>
<?php protected_page(); ?>
<?php include 'includes/header.php'; ?>
<div id="wrap">
	<?php flash_success(); ?>
	<?php flash_errors(); ?>
    <div id="settings">
        <h2 class="aligncenter">Woktop!</h2>
    	<form action="editsettings.php" method="post">
            <input type="text" name="first_name" placeholder="First Name" value="<?php echo $user_data['first_name']; ?>">
            <input type="text" name="last_name" placeholder="Last Name" value="<?php echo $user_data['last_name']; ?>">
            <input type="text" name="email" placeholder="Email address">
            <input type="submit" name="submit" value="Save Changes">
        </form>
        <a href="password.php" class="small aligncenter">Change Password</a>
    </div>
</div>
<?php include 'includes/footer.php'; ?>