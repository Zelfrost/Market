<jsp:include page="header.jsp?titre=Retrouver son mot de passe" />


<form id="conn" method="POST" action="Pass">
	<h3>Retrouver son mot de passe</h3>

	<div class="label">
		<span>Adresse Mail :</span><input type="text" name="mail" placeholder="-" />
	</div>

	<input type="submit" value="confirmer" />
</form>


<jsp:include page="footer.jsp" />