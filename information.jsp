<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
	int id 			= 	Integer.parseInt(request.getParameter("id"));
	int choix 		= 	(request.getParameter("choix")!=null)
						?Integer.parseInt(request.getParameter("choix"))
						:0;
	
    Context initCtx 	= 	new InitialContext();
    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
    DataSource ds 	= 	(DataSource) envCtx.lookup("base");
    Connection con 	= 	ds.getConnection();

	Statement st 	= 	con.createStatement();
	ResultSet rs 	= 	st.executeQuery("SELECT libelle, libelleInverse, to_char(dateFin, 'DD/MM/YYYY') as d FROM markets WHERE idMarket='" + id +"';");
	rs.next();
	String libelle 	= 	(choix==0)
						?rs.getString("libelle")
						:rs.getString("libelleInverse");
	String head 	= 	"header.jsp?titre=" + libelle;
%>
<jsp:include page="<%=head%>" />

<a id="prev" href='marches'>Retour aux marchés</a>
<%
	out.println("<h3>" + libelle + "</h3><span class='small'>Si vous ne croyez pas en cette information, investissez dans <a href='information?id=" + id + "&choix=" + ((choix==1)?0:1) + "'>le pronostic inverse</a></span>");
%>

<p>Date de fin : <strong><%= rs.getString("d") %></strong></p>
<p>État de l'offre :</p>

<table class="rouge">
	<tr>
		<th colspan="3">Vendeurs</th>
	</tr>
<%
	rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(*) AS nbre, SUM(nombre) AS somme, 100 - prix AS prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + ((choix==1)?0:1) + " GROUP BY prix ORDER BY prix DESC");

	if(!rs.next())
		out.println("<tr class='empty'><td colspan='3'>Pas de vendeurs</td></tr>");
	else {
		do {
			out.println("<tr>");
			out.println("<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom"):"---") + "</td>");
			out.println("<td>" + rs.getString("somme") + " bons</td>");
			out.println("<td>" + rs.getString("prix") + "€</td>");
			out.println("</tr>");
		} while(rs.next());
	}
%>
</table>
<form id='acheter' method='POST' action='AcheterBons'>
<%
	out.println("<input type='hidden' name='id' value='" + request.getParameter("id") + "'/>");
	out.println("<input type='hidden' name='choix' value='" + choix + "'/>");
%>
<table class="vert">
	<tr>
		<th colspan="3">Acheteurs</th>
	</tr>
<%
	rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(*) AS nbre, SUM(nombre) AS somme, prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + choix + " GROUP BY prix ORDER BY prix DESC");
	if(!rs.next())
		out.println("<tr class='empty'><td colspan='3'>Pas d'acheteurs</td></tr>");
	else {
		do {
			out.println("<tr>");
			out.println("<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom"):"---") + "</td>");
			out.println("<td>" + rs.getString("somme") + " bons</td>");
			out.println("<td>" + rs.getString("prix") + "€</td>");
			out.println("</tr>");
		} while(rs.next());
	}		
	if ( request.isUserInRole("Admin") || request.isUserInRole("MarketMaker") || request.isUserInRole("User")){
				
		rs = st.executeQuery("SELECT (nom || ' ' || prenom) AS n FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
		rs.next();
	
	    out.println("<tr><td>" + rs.getString("n") + "</td>");
		out.println("<td><input name='nbBons' type='number' class='first' /> bons</td>");
		out.println("<td><input name='prixBons' type='number' />€</td></tr>");
		out.println("<tr class='empty'><td colspan='3'><input type='submit' value='acheter' /></td></tr>");
	
	}
	
	con.close();
%>
</table>
</form>



<jsp:include page="footer.jsp" />
