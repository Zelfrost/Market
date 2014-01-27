<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Connexion" />


<form id="conn" method="POST" action="j_security_check">
	<h3>Connexion :</h3>
	<%
		if(request.getParameter("error")!=null)
			out.println("<span id='error'>Erreur dans le login ou le mot de passe</span>");
		if(request.getParameter("success")!=null)
			out.println("<span id='success'>Vous voila inscrit. Lancez vous !</span>");
	%>

	<div class="label">
		<span>Login :</span><span><input type="text" 		id="j_username" name="j_username" placeholder="-" /></span>
	</div>

	<div class="label">
		<span>Mot de passe :</span><span><input type="password" 	id="j_password" name="j_password" placeholder="-" /></span>
	</div>

	<input type="submit" value="Confirmer" />

	<div>
		<a href='inscription' id='insc'>S'inscrire ?</a>
	</div>
</form>

<jsp:include page="footer.jsp" />
