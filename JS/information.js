$(document).ready( function() {
	raffr();
});

function raffr() {
	var id 			= $('input#id').val();
	var idInverse	= $('input#idInverse').val();

	$("#graphique").html("");

	$.getJSON(
		"/Market/Graphique", 
		{
			"id": id
		}, 
		function(res){
			new Morris.Line({
		 		element: 'graphique',
				data: res,
				xkey: 'jour',
				ykeys: ['valeur'],
				labels: ['Total (€) '],
				dateFormat: function(x) { return $.datepicker.formatDate("dd/mm/yy", new Date(x)); }
			});
		}
	)

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