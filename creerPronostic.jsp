<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Création" />


<script src="JS/jquery-1.9.1.js"></script>
<script src="JS/jquery-ui.js"></script>
<script>
	function sub(){
		$( "#datepicker").val(
			$.datepicker.formatDate(
				"yy-mm-dd", 
				new Date($( "#datepicker" ).val())
			)
		);
	}

	$(function() {
		$( "#datepicker" ).datepicker();
	});
</script>

<h3>Création d'un Pronostic</h3>

<form id="pronostic" method="POST" action="AjoutPronostic" onsubmit="sub();">

<div>
	<label for="libelle">Libellé :</label>
	<textarea name="libelle"></textarea>
</div>

<div>
	<label for="libelleInverse">Libellé Inverse :</label>
	<textarea name="libelleInverse"></textarea>
</div>

<div>
	<label for="dateFin">Date de fin :</label>
	<input type="text" id="datepicker" name="dateFin" />
</div>

<input type="submit" value="Valider" />

</form>


<jsp:include page="footer.jsp" />