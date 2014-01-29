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
		
	    Context initCtx = new InitialContext();
	    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
	    DataSource ds   = (DataSource) envCtx.lookup("base");
	    Connection con  = ds.getConnection();

	    Statement st    = con.createStatement();
		ResultSet rs 	= st.executeQuery("SELECT nom, prenom, mail, argent FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
		rs.next();
	%>
	<h2 id="perso"><%= rs.getString("prenom") + " " + rs.getString("nom") %></h2>
	<%
		if(request.getParameter("error")!=null) {
			out.println("<span id='error'>");
			if(request.getParameter("error").equals("1"))
				out.println((String)res.getObject("erreur1"));
			else if(request.getParameter("error").equals("2"))
				out.println((String)res.getObject("erreur2"));
			else
				out.println((String)res.getObject("erreur3"));
			out.println("</span>");
		}
	%>

	<div class="label">
		<span><%= (String)res.getObject("pass") %> : </span><span><input type="password" name="ancienPass" placeholder="******" /></span/>
	</div>

	<div class="label">
		<span><%= (String)res.getObject("nouvPass") %> : </span><span><input type="password" name="nouveauPass" placeholder="******"/></span/>
	</div>

	<div class="label">
		<span><%= (String)res.getObject("repeterPass") %> : </span><span><input type="password" name="repetePass" placeholder="******"/></span/>
	</div>

	<div class="label">
		<span><%= (String)res.getObject("mail") %> : </span><span><input type="text" name="mail" value="<%= rs.getString("mail") %>" /></span>
	</div>
	
	<input type="submit" value="<%= (String)res.getObject("valider") %>" />
</form>
<%
    con.close();
%>

<jsp:include page="footer.jsp" />