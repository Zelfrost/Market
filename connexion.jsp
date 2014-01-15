<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Connexion" />


<form id="conn" method="POST" action="j_security_check">
	<h3>Connexion :</h3>
	<%
		if(request.getParameter("error")!=null)
			out.println("<span id='error'>Erreur dans le login ou le mot de passe</span>");
	%>

	<div>
		<label for="username">Login :</label>
		<input type="text" 		id="j_username" name="j_username" />
	</div>

	<div>
		<label for="password">Mot de passe :</label>
		<input type="password" 	id="j_password" name="j_password" />
	</div>

	<input type="submit" 	value="Confirmer" />
</form>


<jsp:include page="footer.jsp" />
