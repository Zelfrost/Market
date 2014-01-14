<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Connexion" />


<form id="conn" method="POST" action="j_security_check">
	<h3>Connexion :</h3>
	<span id="error" <% if(request.getParameter("error")!=null)out.print("style='display: inline-block;'"); %>>Erreur dans le login ou le mot de passe</span>

	<div>
		<label for="login">Login :</label>
		<input type="text" 		name="j_username" />
	</div>

	<div>
		<label for="pass">Mot de passe :</label>
		<input type="password" 	name="j_password" />
	</div>

	<input type="submit" 	value="Confirmer" />
</form>


<jsp:include page="footer.jsp" />
