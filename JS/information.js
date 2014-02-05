$(document).ready( function() {
	var id 		= $('input#id').val();
	var choix 	= $('input#choix').val();
	$.getJSON(
		"/MarketDev/Graphique", 
		{
			"id": id,
			"choix": choix
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

	raffr();
});

function raffr() {
	var id 		= $('input#id').val();

	var choix 	= $('input#choix').val();

	$("table.rouge tbody").load(
		"/MarketDev/MarcheQuery", 
		{
			"id": id,
			"choix": ((choix==1)?0:1),
			"prix": 1
		}
	);
	
	$("table.vert tbody").load(
		"/MarketDev/MarcheQuery", 
		{
			"id": id,
			"choix": choix,
			"prix": 0
		}
	);

	setTimeout("raffr()", 5000);
}