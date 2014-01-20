$(document).ready( function() {
	$('td.invest').hover( 
		function() {
			var x 		= $(this).position().top;
			var y 		= $(this).position().left;
			var width	= $(this).width();
			var height	= $(this).height();

			var hWidth	= width*0.3;
			var hHeight = height;
			var hX		= x;
			var hY		= y+width-hWidth;

			$('.info').css({display: "block", top: (hX-2)+"px", left: hY+"px", width: hWidth+"px", height: "auto", minHeight: hHeight+"px"});
		},
		function() {
			$('.info').css({display: "none"});
		}
	);
});