	<a href="#" id="showBeta">Find a bug? Report it!</a>
    <form id="beta" action="bugreport.php" method="post">
        <input type="text" name="username" placeholder="Name"<?php if($user_data['first_name'] != "" && $user_data['last_name'] != "") { echo ' value="'.$user_data['first_name'].' '.$user_data['last_name'].'"'; } ?>>
        <input type="text" name="email" placeholder="Email address" value="<?php echo $user_data['email']; ?>">
        <input type="text" name="error" placeholder="Error text">
        <textarea name="information" placeholder="More information"></textarea>
        <input type="hidden" name="from" value="<?php echo trim($_SERVER['REQUEST_URI'], "/"); ?>">
        <input type="submit" name="submit" value="Submit">
        <p class="alignCenter bugReportStatus"></p>
    </form>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
    <script src="includes/functions.js"></script>
</body>
</html>