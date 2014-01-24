$(document).ready( function(){
	new Morris.Line({
 		element: 'graphique',
		data: [{ jour: '21/01/2014', valeur: '1400' },{ jour: '22/01/2014', valeur: '2100' },{ jour: '23/01/2014', valeur: '600' }],
		xkey: 'jour',
		ykeys: ['valeur'],
		labels: ['Total']
	});
});