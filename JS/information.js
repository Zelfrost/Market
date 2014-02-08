function raffr() {
	var id 			= $('input#id').val();
	var idInverse	= $('input#idInverse').val();

	$("#graph").html("");

	$.getJSON(
		"/Market/Graphique", 
		{
			"id": id
		}, 
		function(res){
			$("#graph").css({height: "200px"});
			new Morris.Line({
		 		element: 'graph',
				data: res,
				xkey: 'jour',
				ykeys: ['valeur'],
				labels: ['Total (€) '],
				dateFormat: function(x) { return $.datepicker.formatDate("dd/mm/yy", new Date(x)); }
			});
		}
	)
	.fail( function() {
		$("#graph").css({height: "auto"});
		$("#graph").html("Aucune évolution actuellement");
	});

	$("table.rouge tbody").load(
		"/Market/MarcheQuery", 
		{
			"id": idInverse,
			"prix": 1
		}
	);
	
	$("table.vert tbody").load(
		"/Market/MarcheQuery", 
		{
			"id": id,
			"prix": 0
		}
	);

	setTimeout("raffr()", 5000);
}

$(document).ready( function() {
	raffr();
});