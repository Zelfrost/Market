<%@ page import="tools.Personne" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Page personnelle" />


<%
	Personne util = (Personne)session.getAttribute("Personne");
%>

<h2 id="perso"><%= util.prenom() + " " + util.nom() %></h2>
<%
	if(request.getParameter("success")!=null)
		out.println("<span id='success'>Vos modifications ont bien été prises en compte.</span>");
%>

<div class="label">
	<span>Login : </span>
	<span><%= util.login() %></span/>
</div>

<div class="label">
	<span>Adresse Mail : </span>
	<span><%= util.mail() %></span>
</div>

<div class="label">
	<span>Argent restant : </span>
	<span><%= util.argentDispo() %>€</span>
</div>


<% 
	Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("base");
    Connection con  = ds.getConnection();

    Statement st 	= con.createStatement();
    ResultSet rs 	= st.executeQuery(	"SELECT " +
											"count(*) AS nb, " +
											"idMarket, " +
											"libelle " +
										"FROM markets " +
										"WHERE " +
											"markets.userID=" + util.id() + 
											" AND dateFin=DATE('now')" +
											" AND resultat=2 " +
										"GROUP BY " +
											"idMarket, " +
											"libelle " +
										"ORDER BY publication DESC;");
	if(rs.next() && rs.getInt("nb") != 0 ) {
%>

<h3>Marchés auxquels vous devez donner un résultat</h3>

<table>
	<tr class="th">
		<th>Libellé</th>
	</tr>
<%
		do {
			out.println("<tr>");
			out.println( "<td style='text-align: center;'><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></td>" );
			out.println("</tr>");
		} while(rs.next());

		con.close();
%>
</table>


<%
	}

    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.changeperso", loc);
%>

<div id='mod'><h5>Modifier mes infos</h5>

<form method="POST" action="ChangerPerso" id="changePerso">
	<%
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

</div>


<jsp:include page="footer.jsp" />


<script src="JS/jquery-1.9.1.js"></script>
<script src="JS/perso.js"></script>