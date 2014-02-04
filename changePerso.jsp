<%@ page import="tools.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Page personnelle" />


<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.changeperso", loc);
%>


<form method="POST" action="ChangerPerso" id="changePerso">
	<%
		Personne util = (Personne)session.getAttribute("Personne");
		out.println("<h2 id='perso'>" + util.prenom() + " " + util.nom() + "</h2>");
		if(request.getParameter("error")!=null) {
			try {
				out.println("<span id='error'>" + res.getString("erreur"+request.getParameter("error")) + "</span>");
			} catch( Exception e ) { /* Ignored */ }
		}
	%>

	<div class="label">
		<span><%= res.getString("pass") %> : </span><span><input type="password" name="ancienPass" placeholder="******" /></span/>
	</div>

	<div class="label">
		<span><%= res.getString("nouvPass") %> : </span><span><input type="password" name="nouveauPass" placeholder="******"/></span/>
	</div>

	<div class="label">
		<span><%= res.getString("repeterPass") %> : </span><span><input type="password" name="repetePass" placeholder="******"/></span/>
	</div>

	<div class="label">
		<span><%= res.getString("mail") %> : </span><span><input type="text" name="mail" value="<%= util.mail() %>" /></span>
	</div>
	
	<input type="submit" value="<%= res.getString("valider") %>" />
</form>

<jsp:include page="footer.jsp" />