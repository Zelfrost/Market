<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Connexion" />


<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.inscription", loc);
%>


<form id="conn" method="POST" action="Inscrire">
	<h3>Inscription :</h3>
	<%
		if(request.getParameter("error")!=null) {
			if(request.getParameter("error").equals("1"))
				out.println("<span id='error'>" + res.getString("erreur1") + "</span>");
			else if(request.getParameter("error").equals("2"))
				out.println("<span id='error'>" + res.getString("erreur2") + "</span>");
			else
				out.println("<span id='error'>" + res.getString("erreur3") + "</span>");
		}
	%>

	<div class="label">
		<span><%= res.getString("login") %> :</span><span><input type="text" name="login" placeholder="-" /></span>
	</div>

	<div class="label">
		<span><%= res.getString("pass") %> :</span><span><input type="password" name="pass" placeholder="-" /></span>
	</div>

	<div class="label">
		<span><%= res.getString("repetPass") %> :</span><span><input type="password" name="passConf" placeholder="-" /></span>
	</div>

	<div class="label">
		<span><%= res.getString("mail") %> :</span><span><input type="text" name="mail" placeholder="-" /></span>
	</div>

	<div class="label">
		<span><%= res.getString("nom") %> :</span><span><input type="text" name="nom" placeholder="-" /></span>
	</div>

	<div class="label">
		<span><%= res.getString("prenom") %> :</span><span><input type="text" name="prenom" placeholder="-" /></span>
	</div>

	<input type="submit" value="<%= res.getString("conf") %>" />

	<div>
		<a href='connexion' id='insc'><%= res.getString("conn") %> ?</a>
	</div>
</form>

<jsp:include page="footer.jsp" />
