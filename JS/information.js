$(document).ready( function(){
	var id 		= $('input#id').val();
	var choix 	= $('input#choix').val();
	$.getJSON(
		"/Market/Graphique", 
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
});