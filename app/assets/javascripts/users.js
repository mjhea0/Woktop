// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var app = angular.module('woktop', []);

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
});

function sortTables() {
	//Load in table sorting
	$('.table.woktopFilesList').stupidtable({
		"filename" : function(a, b) {
    		a = a.toLowerCase();
			b = b.toLowerCase();
			
			if (a<b) return -1; if (a>b) return +1; return 0;
    	},
		"filesize" : function(a, b) {
			if(typeof a === "string") {
				if(a.indexOf("-") != -1)
					a = 0.0;
				else if(a.indexOf("KB") != -1)
					a = parseFloat(a)*1000;
				else if(a.indexOf("MB") != -1)
					a = parseFloat(a)*1000000;
				else if(a.indexOf("GB") != -1)
					a = parseFloat(a)*1000000000;
			}
			
			if(typeof b === "string") {
				if(b.indexOf("-") != -1)
					b = 0.0;
				else if(b.indexOf("KB") != -1)
					b = parseFloat(b)*1000;
				else if(b.indexOf("MB") != -1)
					b = parseFloat(b)*1000000;
				else if(b.indexOf("GB") != -1)
					b = parseFloat(b)*1000000000;
			}
			
			return a - b;
		}
	}).bind('aftertablesort', function (event, data) {
		var th = $(this).find("th");
		th.find(".downArrow, .upArrow, .leftArrow, .rightArrow").remove();
		var arrow = data.direction === "asc" ? "up" : "down";
		th.eq(data.column).append('<span class="' + arrow + 'Arrow"></span>');
	});
}

function animateProgressBars() {
	$(".progressBar").each(function() {
		var theDesc = $(this).find('.desc1');
		var theBar = $(this).find('.progress');
		var theAmount = theDesc.text();
	
		if(parseInt(theAmount.slice(0, -1)) > 2) {
			theDesc.text('0%');
			theBar.css('width', '0%').delay(500).animate({
				width: theAmount
			}, { duration: 1000, step: function(now) {
				theDesc.text(parseInt(now) + "%");
			}});
		}
	});
}

$(document).ready(function() {
	var $infiniteLoader = $(".infiniteLoader");
	var $files = $(".files");
	var $additional = $("#title, #footer");
	var theUIDS = $infiniteLoader.attr('data-dropbox-uids').split(',');
	
	//Kill inactive buttons
	$(document).on('click', '.inactive', function(event) { event.preventDefault(); });
	
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
	
	//Handle Dropbox account removal
	$("button[name=dropboxRemove]").on('click', function() {
		var theUID = $(this).parents('.window').attr('data-dropbox-uid');
		
		$.get('/dropbox/accounts/delete', { uid: theUID }, function(data) {
			if(data.uid = theUID)
				location.reload();
		});
	});
	
	//Handle file click
	$(document).on('click', '.file a', function(event) {
		event.preventDefault();
		var theUID = $(this).parents('.woktopFilesList').attr('data-dropbox-uid');
		
		if($(this).attr('data-dropbox-directory') == "true") {
			alert("This is a directory!");
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
				$theDialog = $(".window[data-form-type=editFileDropbox]");
				var theAccount = $(this).parents('.fileAccount');
				
				$theDialog.attr('data-dropbox-uid', theAccount.attr('data-dropbox-uid')).fadeIn(250).next().fadeIn(250);
				$theDialog.find('#dropbox_user_name').val(theAccount.find('h2').text());
				$theDialog.find('#dropbox_user_uid').val(theAccount.attr('data-dropbox-uid'));
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
	
	//Handle renaming of Dropbox account
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
	});
	
	//Prepare different views
	$("#organizeNav a.btnIcon").on('click', function(e) {
		e.preventDefault();
		
		var theIcon = $(this).find('span').attr('class');
		
		$(this).parents("#organizeNav").find("a").each(function() {
			$(this).removeClass("selected");
		});
		
		$(this).addClass("selected");
		
		$files.each(function() {
			$(this).hide();
		});
		
		if(theIcon == "icon-list") 
			$(".files.listView").fadeIn(500);
		else if(theIcon == "icon-layout")
			$(".files.thumbnailView").fadeIn(500);
		else
			$(".files.desktopView").fadeIn(500);
	});
	
	$("#nav, #organizeNav").css('top', -36).delay(1000).animate({top: 0}, 250);
	$("#organizeNav a.btnIcon:first").trigger('click');
});