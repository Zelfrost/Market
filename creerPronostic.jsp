<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Création" />


<script src="JS/jquery-1.9.1.js"></script>
<script src="JS/jquery-ui.js"></script>
<script>
	function sub(){
		$( "#datepicker").val(
			$.datepicker.formatDate(
				"dd/mm/yy", 
				new Date($( "#datepicker" ).val())
			)
		);
	}

	$(function() {
		$( "#datepicker" ).datepicker();
	});
</script>

<a id="prev" href='marches'>Retour aux marchés</a>

<h3>Création d'un Pronostic</h3>

<form accept-charset="ISO-8859-1" id="pronostic" method="POST" action="AjoutPronostic">

<%
	if(request.getParameter("succes")!=null)
		out.println("<span id='success'>L'ajout s'est bien déroulé</span>");
%>

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
	<input type="text" id="datepicker" name="dateFin" onchange="sub();" />
</div>

<input type="submit" value="Valider" />

</form>


<jsp:include page="footer.jsp" />