// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

/*var app = angular.module('woktop', []);

app.controller('DropboxCtrl', function($scope, dropbox) {
  	$scope.dropboxAccounts = dropbox.getAccounts();
	$scope.dropboxFiles = dropbox.getRoot();
	
	$scope.$watch(function() {
	    sortTables();
	
		var $infiniteLoader = $(".infiniteLoader");
		var theUIDS = $infiniteLoader.attr('data-dropbox-uids').split(',');
		var $files = $(".files");
		var $additional = $("#title, #footer");
	
		//$infiniteLoader.stop(true, true).fadeOut(250);
		$additional.fadeIn(500);
		$files.each(function() {
			if($(this).hasClass('listView'))
				$(this).fadeIn(500);
		});
		//animateProgressBars();
	});

	$scope.getPercent = function(theDropbox) {
		return parseInt(parseFloat((theDropbox.quota_normal + theDropbox.quota_shared)/theDropbox.quota_total)*100);
	}
	
	$scope.getIcon = function(theFile) {
		return theFile.fileType.split(' ').join('-').toLowerCase();
	}
});

app.factory('dropbox', function($http, $q) {
	var $infiniteLoader = $(".infiniteLoader");
	var theUIDS = $infiniteLoader.attr('data-dropbox-uids').split(',');
	var $files = $(".files");
	var $additional = $("#title, #footer");
	
	$files.hide();
	$additional.hide();
	//$infiniteLoader.stop(true, true).fadeIn(250);
	
	return {
		getAccounts: function() {
			var promises = [];

			for(i = 0; i < theUIDS.length; i++) {
				promises.push($http({
					url: '/dropbox/accounts/get', 
		  			method: "GET",
		  			params: { uid: theUIDS[i] }
				}));
			}

			return $q.all(promises);
		},
		getRoot: function() {
			var promises = [];

			for(i = 0; i < theUIDS.length; i++) {
				promises.push($http({
					url: '/dropbox/root/get', 
		  			method: "GET",
		  			params: { uid: theUIDS[i] }
				}));
			}

			return $q.all(promises);
		}
	}
});*/

$(document).ready(function() {
	var $infiniteLoader = $(".infiniteLoader");
	var $files = $(".files");
	var $additional = $("#title, #footer");
	var theUIDS = $infiniteLoader.attr('data-dropbox-uids').split(',');
	var theContent = [];
	
	//Load information
	for(i = 0; i < theUIDS.length; i++) {
		var temp = [];
		
		//Get account
		$.get('/dropbox/accounts/get', { uid: theUIDS[i] }, function(data) {
			temp.push(data);
		});
		
		//Get root
		$.get('/dropbox/root/get', { uid: theUIDS[i] }, function(data) {
			//THIS WON'T WORK YET
			theContent += data;
		});
		
		theContent.push(temp);
	}
	
	$(document).ajaxStop(function() {
		for(index in theContent) {
			var theString = "";
			var theAccount = theContent[index][0];
			var theRoot = theContent[index][1];
			
			if(theAccount.name == null)
				var name = "Dropbox #" + theAccount.uid;
			else
				var name = theAccount.name;
				
			var percent = parseInt(parseFloat((theAccount.quota_normal + theAccount.quota_shared)/theAccount.quota_total)*100);
			
			/*
			<table class='small-12 large-12 woktopFilesList' data-dropbox-uid='UID'>
				<thead>
					<th width="100" class='fileType'><span>Type</span></th>
					<th class='fileName'><span>Name</span></th>
					<th width="100" class='fileSize'><span>Size</span></th>
				</thead>
				<tbody>
					<tr class="file" data-dropbox-id="FILE-ID" data-dropbox-directory="DIRECTORY" data-dropbox-type="TYPE" data-dropbox-rev="REV" data-dropbox-size="SIZE" data-dropbox-path="PATH">
						<td class='fileType'><div class="app-icon THE-ICON">TYPE</div></td>
						<td class='fileName'><a href="#" data-dropbox-directory="DIRECTORY" data-dropbox-id="FILE-ID">NAME</a></td>
						<td class='fileSize'>SIZE</td>
					</tr>
				</tbody>
			</table>
			*/
			
			theString += '<div class="small-12 large-12 columns fileAccount" data-dropbox-uid="' + theAccount.uid + '">\n<div class="row">';
			theString += '<h3 class="hide-for-small subheader large-4 columns">' + name + '</h3>\n<h3 class="show-for-small small-12 text-center">' + name + '</h3>';
			theString += '<div class="small-7 large-6 columns progressBar">\n<div class="progress"><span class="meter" style="width: ' + percent + '%;">' + percent + '%</span></div>\n</div>';
			theString += '<ul class="inline-list small-5 large-2 columns dropboxTools">\n<li><a href="#"><span aria-hidden="true" class="icon-upload"></span></a></li>\n<li><a href="#"><span aria-hidden="true" class="icon-search"></span></a></li>\n<li><a href="#"><span aria-hidden="true" class="icon-tools"></span></a></li>\n<li><a href="#" class="inactive"><span aria-hidden="true" class="icon-trash"></span></a></li>\n</ul>';
			theString += '</div>';
			theString += "TABLE";
			
			for(index in theRoot) {
				//Handle file manipulation here
			}
			
			theString += '</div>';
			
			$files.append(theString);
		}
	});
	
	//Animate progress bars
	$(".meter").each(function() {
		var theAmount = $(this).text();
	
		if(parseInt(theAmount.slice(0, -1)) > 2) {
			$(this).text('0%');
			$(this).css('width', '0%').delay(250).animate({
				width: theAmount
			}, { duration: 1000, step: function(now) {
				$(this).text(parseInt(now) + "%");
			}});
		}
	});
	
	//Add file selection
	$(document).on('click', '.file', function(event) {
		var whichUID = $(this).parents('.woktopFilesList').attr('data-dropbox-uid');
		var myLoop = $(".woktopFilesList[data-dropbox-uid=" + whichUID + "] .file");
		
		if(event.shiftKey) {
			var theIndex = $(this).index();
			var anySelected = -1;
			
			myLoop.each(function() {
				if($(this).hasClass('selected'))
					anySelected = $(this).index();
			});
			
			if(anySelected != -1) {
				myLoop.each(function() {
					var myIndex = $(this).index();
					if((myIndex >= theIndex && myIndex <= anySelected) || (myIndex <= theIndex && myIndex >= anySelected))
						$(this).addClass('selected');
				});
			}
			else
				$(this).addClass('selected');
		}
		else if(event.ctrlKey || event.metaKey) {
			$(this).toggleClass('selected');
		}
		else {
			if(!$(this).hasClass('selected')) {
				myLoop.each(function() { $(this).removeClass('selected'); });
			
				$(this).addClass('selected');
			}
			else
				myLoop.each(function() { $(this).removeClass('selected'); });
		}
		
		var selections = false;
		
		myLoop.each(function() {
			if($(this).hasClass('selected'))
				selections = true;
		});
		
		if(selections)
			$(this).parents('.fileAccount').find('.icon-trash').parent().removeClass('inactive');
		else
			$(this).parents('.fileAccount').find('.icon-trash').parent().addClass('inactive');
	});
	
	/*//Handle Dropbox account removal
	$("button[name=dropboxRemove]").on('click', function() {
		var theUID = $(this).parents('.window').attr('data-dropbox-uid');
		
		$.get('/dropbox/accounts/delete', { uid: theUID }, function(data) {
			if(data.uid = theUID)
				location.reload();
		});
	});*/
	
	//Handle file click
    $(document).on('click', '.file a', function(event) {
     event.preventDefault();
     var theUID = $(this).parents('.woktopFilesList').attr('data-dropbox-uid');

     if($(this).attr('data-dropbox-directory') == "true") {
         $.get('/dropbox/files/get', { uid: theUID, path: $(this).parents('tr').attr('data-dropbox-path') }, function(data) {
      		alert(data);
     	});
     }
     else
         window.open('/dropbox/files/download?uid=' + theUID + '&fileid=' + $(this).attr('data-dropbox-id'));
    });
	
	//Handle Dropbox tools functions
	$(document).on('click', '.dropboxTools a', function(event) {
		event.preventDefault();
		
		if(!$(this).hasClass('inactive')) {
			var theType = $(this).find('span').attr('class');
			
			if(theType == "icon-upload")
				alert("Upload");
			else if(theType == "icon-search")
				alert("Search");
			else if(theType == "icon-tools") {
				//HANDLE THE DROPBOX SETTINGS
			}
			else {
				var theUID = $(this).parents('.fileAccount').attr('data-dropbox-uid');
				var fileIDS = "";
				
				$(this).parents('.fileAccount').find('.file').each(function() {
					if($(this).hasClass('selected'))
						fileIDS += $(this).attr('data-dropbox-id') + ",";
				});
				
				fileIDS = fileIDS.substring(0, fileIDS.length-1);
				
				$.get('/dropbox/files/delete', { uid: theUID, fileids: fileIDS }, function(data) {
					if(data != null || data != "")
						$.each(data, function(key) {
							$('.woktopFilesList[data-dropbox-uid=' + theUID + '] .file[data-dropbox-id=' + data[key] + ']').remove();
						});
				});
			}
		}
	});
	
	/*//Handle renaming of Dropbox account
	$(".window[data-form-type=nameDropbox] button").on('click', function() {
		$parent = $(this).parents('.window');
		
		if($parent.find("input[name=newDropboxName]").val() != "") {
			$.get('/dropbox/accounts/update', { uid: $parent.attr('data-dropbox-uid'), name: $parent.find("input[name=newDropboxName]").val() }, function(data) {
				$parent.fadeOut(250);
				$parent.next('.theOverlay').fadeOut(250);
				$('.fileAccount[data-dropbox-uid=' + $parent.attr('data-dropbox-uid') + '] h2').text(data);
				$infiniteLoader.attr('data-dropbox-uids', $parent.attr('data-dropbox-uid'));
			});
		}
	});*/
});