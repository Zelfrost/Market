<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Connexion" />


<form id="conn" method="POST" action="Inscrire">
	<h3>Inscription :</h3>
	<%
		if(request.getParameter("error")!=null) {
			if(request.getParameter("error").equals("1"))
				out.println("<span id='error'>Erreur, Vous avez oublié des informations</span>");
			else if(request.getParameter("error").equals("2"))
				out.println("<span id='error'>Erreur, les mots de passe ne sont les mêmes</span>");
			else
				out.println("<span id='error'>Erreur, ce login existe déjà</span>");
		}
	%>

	<div class="label">
		<span>Login :</span><span><input type="text" name="login" placeholder="-" /></span>
	</div>

	<div class="label">
		<span>Mot de passe :</span><span><input type="password" name="pass" placeholder="-" /></span>
	</div>

	<div class="label">
		<span>Confirmer le mot de passe :</span><span><input type="password" name="passConf" placeholder="-" /></span>
	</div>

	<div class="label">
		<span>Adresse mail :</span><span><input type="text" name="mail" placeholder="-" /></span>
	</div>

	<div class="label">
		<span>Nom :</span><span><input type="text" name="nom" placeholder="-" /></span>
	</div>

	<div class="label">
		<span>Prénom :</span><span><input type="text" name="prenom" placeholder="-" /></span>
	</div>

	<input type="submit" value="Confirmer" />

	<div>
		<a href='connexion' id='insc'>Connexion</a>
	</div>
</form>

<jsp:include page="footer.jsp" />
