// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
	var $infiniteLoader = $(".infiniteLoader");
	var $files = $(".files");
	var $additional = $("#title, #footer");
	var theUIDS = $infiniteLoader.attr('data-dropbox-uids').split(',');
	
	//Load in table sorting
	$('.woktopFilesList').stupidtable({
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
	
	//Kill inactive buttons
	$(document).on('click', '.inactive', function(event) { event.preventDefault(); });
	
	//Add table selection
	$(document).on('click', '.woktopFilesList tbody tr', function(event) {
		var whichUID = $(this).parents('.woktopFilesList').attr('data-dropbox-uid');
		var myLoop = $(".woktopFilesList[data-dropbox-uid=" + whichUID + "] tbody tr");
		
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
				
				$(this).parents('.fileAccount').find('.woktopFilesList tbody tr').each(function() {
					if($(this).hasClass('selected'))
						fileIDS += $(this).attr('data-dropbox-id') + ",";
				});
				
				fileIDS = fileIDS.substring(0, fileIDS.length-1);
				
				$.get('/dropbox/files/delete', { uid: theUID, fileids: fileIDS }, function(data) {
					if(data != null || data != "")
						$.each(data, function(key) {
							$('.woktopFilesList[data-dropbox-uid=' + theUID + '] tbody tr[data-dropbox-id=' + data[key] + ']').remove();
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
		
		if(theIcon == "icon-list")
			loadData('list');
		else if(theIcon == "icon-layout")
			loadData('layout');
		else
			loadData('desktop');
	});
	
	//Load in our data
	function loadData(whatView) {
		if($infiniteLoader.attr('data-dropbox-uids') != "") {
			$.each(theUIDS, function(key) {
				$theAccount = $(".fileAccount[data-dropbox-uid=" + theUIDS[key] + "]");
				
				$.get('/dropbox/files/get', { uid: theUIDS[key] }, function(data) {
					if(data != undefined) {
						var table = "";
				
						$.each(data, function(key) {
								table += "<tr" +
									" data-dropbox-id='" + data[key].id +
									"' data-dropbox-directory='" + data[key].directory +
									"' data-dropbox-type='" + data[key].fileType +
									"' data-dropbox-rev='" + data[key].rev +
									"' data-dropbox-size='" + data[key].size +
									"' data-dropbox-path='" + data[key].path + "'>";
							
								table += "<td class='fileType'><div class='app-icon " + data[key].fileType.split(' ').join('-').toLowerCase() + "'>" + data[key].name + "</div></td>";
								table += "<td class='fileName'>" + data[key].name + "</td>";
								table += "<td class='fileSize'>" + data[key].size + "</td>";
						
								table += "</tr>";
						});
				
						$theAccount.find('tbody').html(table);
					}
				});
				
				$.get('/dropbox/accounts/get', { uid: theUIDS[key] }, function(accountData) {
					if(accountData != undefined) {
						var percent = parseInt(parseFloat((accountData.quota_normal + accountData.quota_shared)/accountData.quota_total)*100);
						var theProgress = "";
					
						if(accountData.name == "" || accountData.name == null)
							$theAccount.find('h2').text("Dropbox " + theUIDS[key]);
						else
							$theAccount.find('h2').text(accountData.name);
						
						if(percent <= 2)
							theProgress += '<div class="progress" style="width: 2%; background-color: #FAFAFA;"><span class="desc1" style="color: #000; padding-left: 5px;">' + percent + '%</span></div>';
						else
							theProgress += '<div class="progress" style="width: ' + percent + '%;"><span class="desc1">' + percent + '%</span></div>';
						
						theProgress += '<div class="remainder" style="width: ' + parseInt(100-percent) + '%;"></div>';
					
						$theAccount.find('.progressBar').html(theProgress);
					}
				});
			});
		}
		else
			$files.html('<h2 class="aligncenter">No accounts found... how strange, try adding one!</h2>');
	}
	
	//Hide files/show loader before AJAX starts
	$(document).ajaxStart(function() {
		$files.hide();
		$additional.hide();
		$infiniteLoader.stop(true, true).fadeIn(250);
	});
	
	//Hide loader/show files after AJAX stops
	$(document).ajaxStop(function() {
		$infiniteLoader.stop(true, true).fadeOut(250);
		$additional.fadeIn(500);
		$files.fadeIn(500);
		animateProgressBars();
	});
	
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
	
	$("#nav, #organizeNav").css('top', -36).delay(1000).animate({top: 0}, 250);
	$("#organizeNav a.btnIcon:first").trigger('click');
});