$(document).ready( function() {
	$('td.invest').hover( 
		function() {
			var x = $(this).position().top;
			var y = $(this).position().left;
			$('.info').css({display: "block", top: x+"px", left: y+"px"});
		},
		function() {
			$('.info').css({display: "none"});
		}
	);
});