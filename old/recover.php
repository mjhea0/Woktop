<?php
	$mode_allowed = array("username", "password");
	if(isset($_GET['mode']) && in_array($_GET['mode'], $mode_allowed)) {
?>

<?php include 'core/init.php'; ?>
<?php logged_in_redirect(); ?>
<?php include 'includes/header.php'; ?>
<div id="wrap">
	<?php flash_success(); ?>
	<?php flash_errors(); ?>
    <div id="recover">
        <h2 class="aligncenter">Woktop!</h2>
    	<form action="forgotten.php?mode=<?php echo $_GET['mode']; ?>" method="post">
        	<input type="text" name="email" placeholder="Email address">
            <input type="submit" name="submit" value="Recover">
        </form>
    </div>
</div>
<?php include 'includes/footer.php'; ?>

<?php
	}
	else {
		header("Location: index.php");
		exit();
	}
?>