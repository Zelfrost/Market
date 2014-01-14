<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Les marchés" />


<form method="POST" action="servlet/Connexion">
	<span>
		Login : 
		<input type="text" 		name="login" 		/>
	</span>

	<span>
		Mot de passe : 
		<input type="password" 	name="pass" 		/>
	</span>

	<span>
		<input type="submit" 		value="Confirmer" 	/>
	</span>
</form>


<jsp:include page="footer.jsp" />