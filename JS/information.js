$(document).ready(function(event) {

    $('form#acheter').submit(function(event){
    	var nbBons 		= $("input[type='number'].first").val();
    	var prixBons 	= $("input[type='number'].second").val();
		$.post('acheterBonsQuery', {
				"nbBons": nbBons,
				"prixBons": prixBons
			}, function(data) {
		    	var tr 	= "<tr class='info last'>";
		    	var td1 = "<td><div></div></td>";
		    	var td2 = "<td><div></div></td>";
		    	var td3 = "<td><div></div></td>";
		    	var ftr = "</tr>";

				if(data == "success") {

				} else {

				}
		});


    	$('.vert tr.info:last').after(tr + td1 + td2 + td3 + ftr);
    	$('.vert tr.info.last').find('td').slideDown(300);
    	$('.vert tr.info.last').find('td div').animate({left: "0"}, 500);
    	$('.vert tr.info.last').removeClass("last");
    	return false;
    });
});