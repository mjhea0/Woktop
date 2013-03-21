$(document).ready(function() {
	/* ----- SITE-WIDE ----- */
	$('.flash.success').delay(250).fadeIn(500).delay(5000).fadeOut(500);
	
	/* BUG REPORTS FOR BETA */
	$beta = $("#beta");
	
	$("#showBeta").on("click", function() {
		if($beta.css("bottom") == "-240px")
			$beta.animate({ bottom : 40 }, 250);
		else
			$beta.animate({ bottom : -240 }, 250);
			
		return false;
	});
	
	
	
	/* ----- APPLICATION ----- */
	var $driveFiles = $(".driveFiles");
	var xTile = 0;
	var yTile = 0;
	var windowWidth = $driveFiles.width();
	var windowHeight = $driveFiles.height();
	
	$(".driveFiles li").each(function() {
		if($(this).attr("data-xpos") && $(this).attr("data-ypos")) {
			$(this).css("left", ($(this).attr("data-xpos")/100)*windowWidth);
			$(this).css("top", ($(this).attr("data-ypos")/100)*windowHeight);
		}
		else {
			$(this).css("left", xTile);
			$(this).css("top", yTile);
			
			if(yTile+192 >= windowHeight) { //(76px + 10px margins) * 2
				xTile += 68; //48px + 10px margins
				yTile = 0;
			}
			else {
				yTile += 96; //76px + 10px margins
			}
		}
	});
	
	$(".driveFiles li").on("click", function(event) {
		event.stopPropagation();
		$(".driveFiles li").removeClass("highlight");
		$(this).addClass("highlight");
	}).on("dblclick", function() {
		window.open($(this).attr("data-alturl"));
	});
	
	$("html").on("click", function() {
		$(".driveFiles li").removeClass("highlight");
	});
	
	$(".file").draggable({ containment: ".driveFiles", scroll: false, cursor: "move" });
});