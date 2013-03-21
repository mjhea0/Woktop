<?php include 'core/init.php'; ?>
<?php if($_GET['refresh'] == true) { header("Location: woktop.php"); } ?>
<?php require 'core/libraries/google/Google_Client.php'; ?>
<?php require 'core/libraries/google/contrib/Google_DriveService.php'; ?>
<?php protected_page(); ?>
<?php $username = $_GET['username']; user_page_exists($username); ?>
<?php include 'includes/header.php'; ?>
<div id="wrap">
    <?php
		$googleClient = new Google_Client();
		$driveService = new Google_DriveService($googleClient);
		
		$user_id = $_SESSION['user_id'];
		$query = mysql_query("SELECT * FROM driveAccounts WHERE user_id = '$user_id'");
		
		if(mysql_num_rows($query) > 0) {
			while($row = mysql_fetch_assoc($query)) {
				$access_token = $row['access_token'];
				$req = new Google_HttpRequest("https://www.googleapis.com/oauth2/v1/userinfo?access_token=$access_token");
				$resp = json_decode($googleClient->getIo()->authenticatedRequest($req)->getResponseBody());
				$error = $resp->error->message;
				
				if($error == "Invalid Credentials" || $error == "Login Required") {
					$refresh_token = $row['refresh_token'];
					
					$refresh_the_token = $googleClient->refreshToken($refresh_token);
					$new_access_token = json_decode($googleClient->getAccessToken());
					$new_access_token = $new_access_token->access_token;
					
					$updateTokens = mysql_query("UPDATE driveAccounts SET access_token = '$new_access_token' WHERE user_id = '$user_id' AND refresh_token = '$refresh_token'");
					
					if(mysql_num_rows($updateTokens) == 0) {
						$woktopErrors[] = "We can't autheticate you on Google Drive, please try <a href='woktop.php'>refreshing</a>";
						$_SESSION['flash_errors'] = $woktopErrors;
						header("Location: woktop.php");
					}
					else {
						header("Location: woktop.php");
					}
				}
				else {
					echo "<div class='information'>";
					echo "<p>".$resp->email."</p>";
					echo "<p>".$resp->name."</p>";
					echo "</div>";
					
					$driveAccountID = $row['id'];
					
					$req = new Google_HttpRequest("https://www.googleapis.com/drive/v2/files?access_token=$access_token&fields=items(id,alternateLink,title,mimeType,labels,userPermission)");
					$resp = json_decode($googleClient->getIo()->authenticatedRequest($req)->getResponseBody());
					$error = $resp->error->message;
					
					if($error == "" && !empty($resp->items)) {
						echo '<ul class="driveFiles">';
						
						foreach($resp->items as $item) {
							if($item->labels->hidden != 1 && $item->labels->trashed != 1 && $item->labels->restricted != 1 && $item->userPermission->role == "owner") {
								$id = $item->id;
								$alternateLink = $item->alternateLink;
								$title = $item->title;
								$mimeType = $item->mimeType;
								
								if(strstr($mimeType, "google-apps.document") != false)
									$icon = "driveDocument";
								else if(strstr($mimeType, "google-apps.presentation") != false)
									$icon = "drivePresentation";
								else if(strstr($mimeType, "google-apps.spreadsheet") != false)
									$icon = "driveSpreadsheet";
								else if(strstr($mimeType, "google-apps.drawing") != false)
									$icon = "driveDrawing";
								else if(strstr($mimeType, "google-apps.photo") != false)
									$icon = "drivePhoto";
								else if(strstr($mimeType, "google-apps.audio") != false)
									$icon = "driveAudio";
								else if(strstr($mimeType, "google-apps.video") != false)
									$icon = "driveVideo";
								else if(strstr($mimeType, "google-apps.file") != false)
									$icon = "driveFile";
								else if(strstr($mimeType, "google-apps.folder") != false)
									$icon = "driveFolder";
								else if(strstr($mimeType, "google-apps.form") != false)
									$icon = "driveForm";
								else if(strstr($mimeType, "google-apps.fusion") != false)
									$icon = "driveFusion";
								else if(strstr($mimeType, "google-apps.sites") != false)
									$icon = "driveSite";
								else if(strstr($mimeType, "google-apps.chart") != false)
									$icon = "driveChart";
								else if(strstr($mimeType, "google-apps.archive") != false)
									$icon = "driveArchive";
								else if(strstr($mimeType, "excel") != false)
									$icon = "excel";
								else if(strstr($mimeType, "word") != false)
									$icon = "word";
								else if(strstr($mimeType, "powerpoint") != false)
									$icon = "powerpoint";
								else if(strstr($mimeType, "pdf") != false)
									$icon = "pdf";
								else
									$icon = "unknown";
								
								$checkFileQuery = mysql_query("SELECT * FROM driveFiles WHERE id = '$id'");
								
								while($fileData = mysql_fetch_assoc($checkFileQuery)) {
									$xpos = $fileData['x_pos'];
									$ypos = $fileData['y_pos'];
									$size = $fileData['size'];
								}
								
								if($size == 0)
									$size = 48;
									
								if(strpos($title, ".") != false)
									$title = strstr($title, ".", true);
									
								if($xpos == 0 && $ypos == 0)
									echo '<li class="file" data-id="'.$id.'" data-alturl="'.$alternateLink.'" style="width: '.$size.'px;"><p class="'.$icon.'">'.$title.'</p></li>';
								else
									echo '<li class="file" data-id="'.$id.'" data-alturl="'.$alternateLink.'" data-xpos="'.$xpos.'" data-ypos="'.$ypos.'" style="width: '.$size.'px;"><p class="'.$icon.'">'.$title.'</p></li>';
								
								if(mysql_num_rows($checkFileQuery) == 0)
									mysql_query("INSERT IGNORE INTO driveFiles (`id`, `alternate_link`, `title`, `mime_type`, `drive_account_id`) VALUES ('$id', '$alternateLink', '$title', '$mimeType', '$driveAccountID')");
								else
									mysql_query("UPDATE driveFiles SET alternate_link = '$alternateLink', title = '$title', mime_type = '$mimeType' WHERE id = '$id'");
							}
						}
						echo "</ul>";
					}
					else {
						$woktopErrors[] = "We can't load your Drive account, please try <a href='woktop.php'>refreshing</a>";
						$_SESSION['flash_errors'] = $woktopErrors;
						header("Location: woktop.php");
					}
				}
			}
		}
	?>
    <?php flash_success(); ?>
	<?php flash_errors(); ?>
    <div id="log"></div>
    <?php /*
    <div id="settings">
        <h2 class="aligncenter">Woktop!</h2>
        <p class="aligncenter">Welcome <?php echo $username; ?>!</p>
        <a href="https://accounts.google.com/o/oauth2/auth?
scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=drive&redirect_uri=http%3A%2F%2Fwww.woktop.com%2Fnewservice.php&response_type=code&client_id=889314330670.apps.googleusercontent.com&access_type=offline" class="aligncenter">Add a Google Drive account</a>
        <a href="settings.php" class="aligncenter">Edit Settings</a>
        <a href="logout.php" class="aligncenter">Logout</a>
    </div>
	*/ ?>
</div>
<?php include 'includes/footer.php'; ?>