$(document).ready( function() {
	refresh();
});

function refresh() {
	$.post( 
		"/Market/Notifications",
		function(res) {
			$("#notifs").html(res);
		},
		"html"
	)
	.done( function() {
		if($("#notifs").html() !== "")
			$("#notifs").animate({right: "10px"}, 'slow');
		setTimeout( function() {
			$("#notifs").fadeOut(400);
			setTimeout( function() {
				$("#notifs").css({right: "-255px"}).html("").css({display: "block"});
			}, 400);
		}, 5000);
	});

	setTimeout( "refresh()", 6000);
}
