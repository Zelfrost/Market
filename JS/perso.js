$(document).ready( function() {
	$('td.invest').hover( 
		function() {
			var id 		= $(this).attr("id").split(":")[0];
			var choix	= $(this).attr("id").split(":")[1];

			var x 		= $(this).position().top;
			var y 		= $(this).position().left;
			var width	= $(this).width();
			var height	= $(this).height();

			var hWidth	= width*0.35;
			var hHeight = height;
			var hX		= x;
			var hY		= y+width-hWidth;

			$('.persoInfo').css({display: "block", top: (hX-2)+"px", left: hY+"px", width: hWidth+"px", height: "auto", minHeight: hHeight+"px"});

			$.post("PersoInfo", {"id": id, "choix": choix}, function(data) {
				if( data.split("|")[0].split(";")[0].split(":")[1] != "null" && data.split("|")[0].split(";")[0].split(":")[1] != "0" ) {
					$('div#achetes').css({display: "block"});
					$("span#nbA").html( data.split("|")[0].split(";")[0].split(":")[1] );
					$("span#prixA").html( data.split("|")[0].split(";")[1].split(":")[1] );
				}

				if( data.split("|")[1].split(";")[0].split(":")[1] != "null" && data.split("|")[1].split(";")[0].split(":")[1] != "0" ) {
					$('div#restants').css({display: "block"});
					$("span#nb").html( data.split("|")[1].split(";")[0].split(":")[1] );
					$("span#prix").html( data.split("|")[1].split(";")[1].split(":")[1] );
				}
			});
		},
		function() {
			$('.persoInfo div').css({display: "none"});
			$('.persoInfo').css({display: "none"});
		}
	);
});