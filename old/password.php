<?php include 'core/init.php'; ?>
<?php protected_page(); ?>
<?php include 'includes/header.php'; ?>
<div id="wrap">
	<?php flash_success(); ?>
	<?php flash_errors(); ?>
    <div id="password">
        <h2 class="aligncenter">Woktop!</h2>
    	<form action="changepassword.php" method="post">
        	<input type="password" name="password_old" placeholder="Old password">
            <input type="password" name="password" placeholder="New password">
            <input type="password" name="password_again" placeholder="Confirm">
            <input type="submit" name="submit" value="Change Password">
        </form>
    </div>
</div>
<?php include 'includes/footer.php'; ?>