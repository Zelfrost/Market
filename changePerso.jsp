<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Page personnelle" />


<form method="POST" action="changerPerso" id="changePerso">
	<%
		
	    Context initCtx = new InitialContext();
	    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
	    DataSource ds   = (DataSource) envCtx.lookup("base");
	    Connection con  = ds.getConnection();

	    Statement st    = con.createStatement();
		ResultSet rs 	= st.executeQuery("SELECT nom, prenom, mail, argent FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
		rs.next();
	%>
	<h2 id="perso"><%= rs.getString("prenom") + " " + rs.getString("nom") %></h2><input type="submit" value="Valider" />
	<%
		if(request.getParameter("error")!=null) {
			out.println("<span id='error'>");
			if(request.getParameter("error").equals("1"))
				out.println("Votre mot de passe actuel ne correspond pas");
			else if(request.getParameter("error").equals("2"))
				out.println("Les deux nouveaux mots de passe ne correspondent pas");
			else
				out.println("L'adresse mail n'est pas valide");
			out.println("</span>");
		}
	%>

	<div class="label">
		<span>Ancien mot de passe : </span><span><input type="password" name="ancienPass" placeholder="******" /></span/>
	</div>

	<div class="label">
		<span>Nouveau mot de passe : </span><span><input type="password" name="nouveauPass" placeholder="******"/></span/>
	</div>

	<div class="label">
		<span>Répéter le mot de passe : </span><span><input type="password" name="repetePass" placeholder="******"/></span/>
	</div>

	<div class="label">
		<span>Adresse Mail : </span><span><input type="text" name="mail" value="<%= rs.getString("mail") %>" /></span>
	</div>
</form>
<%
    con.close();
%>

<jsp:include page="footer.jsp" />