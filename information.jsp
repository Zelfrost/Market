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
	ResultSet rs 	= 	st.executeQuery("SELECT libelle, libelleInverse, strftime('%d/%m/%Y', dateFin) as d FROM markets WHERE idMarket='" + id +"';");
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
	rs = st.executeQuery("SELECT userID, nom, prenom, count(*) AS nbre, SUM(nombre) AS somme, 100 - prix AS prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + ((choix==1)?0:1) + " GROUP BY prix ORDER BY prix DESC");

	if(!rs.next())
		out.println("<tr class='empty'><td colspan='3'>Pas de vendeurs</td></tr>");
	else {
		do {
			out.println("<tr>");
			out.println("<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom") + " " + rs.getString("prenom"):"---") + "</td>");
			out.println("<td>" + rs.getString("somme") + " bons</td>");
			out.println("<td>" + rs.getString("prix") + "€</td>");
			out.println("</tr>");
		} while(rs.next());
	}
%>
</table>
<table class="vert">
	<tr>
		<th colspan="3">Acheteurs</th>
	</tr>
<%
	rs = st.executeQuery("SELECT userID, nom, prenom, count(*) AS nbre, SUM(nombre) AS somme, prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + choix + " GROUP BY prix ORDER BY prix DESC");
	if(!rs.next())
		out.println("<tr class='empty'><td colspan='3'>Pas d'acheteurs</td></tr>");
	else {
		do {
			out.println("<tr>");
			out.println("<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom") + " " + rs.getString("prenom"):"---") + "</td>");
			out.println("<td>" + rs.getString("somme") + " bons</td>");
			out.println("<td>" + rs.getString("prix") + "€</td>");
			out.println("</tr>");
		} while(rs.next());
				
		if ( request.isUserInRole("Admin") || request.isUserInRole("MarketMaker") || request.isUserInRole("User")){
				
			rs = st.executeQuery("SELECT (nom || ' ' || prenom) AS n FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
				       		
	        	out.println("<tr><td>" + rs.getString("n") + "</td>");
			out.println("<td><form>");
			out.println("<input type=number size=2 /></td>");
			out.println("<td><input type=number size=2 /></td>");
			out.println("</tr><tr class='empty'>");
			out.println("<td colspan='3'><input type=submit value=acheter /></td></tr>");
	
		}
	}
%>
</table>



<jsp:include page="footer.jsp" />
