<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.information", loc);
%>

<%
	if(request.getParameter("id")==null || request.getParameter("id").equals("") || request.getParameter("id").equals("0")) {
%>
<jsp:include page="header.jsp?titre=Error" />
<%
		out.println("<span id='error'>" + res.getString("erreur") + "</span>");
	} else {
		int id 			= 	Integer.parseInt(request.getParameter("id"));
		int choix 		= 	(request.getParameter("choix")!=null)
							?Integer.parseInt(request.getParameter("choix"))
							:0;
		
	    Context initCtx = 	new InitialContext();
	    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	    DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	    Connection con 	= 	ds.getConnection();

		Statement st 	= 	con.createStatement();
		ResultSet rs 	= 	st.executeQuery("SELECT libelle, libelleInverse, to_char(dateFin, 'DD/MM/YYYY') as d, resultat, login FROM markets JOIN users on users.idUser=markets.userID WHERE idMarket='" + id +"';");

		if(!rs.next())
			response.sendRedirect("information");
		else {
		String libelle;
		if( ! rs.getString("resultat").equals("2") )
			libelle 	= 	(rs.getString("resultat").equals("0"))
							?rs.getString("libelle")
							:rs.getString("libelleInverse");
		else
			libelle 	= 	(choix==0)
							?rs.getString("libelle")
							:rs.getString("libelleInverse");

		String[] date 	=	rs.getString("d").split("/");
		java.util.Date fin 	= 	new java.util.Date(	Integer.parseInt(date[2])-1900,
														Integer.parseInt(date[1])-1,
														Integer.parseInt(date[0])
								);
		String resultat = rs.getString("resultat");
		String head 	= 	"header.jsp?titre=" + libelle;
%>
<jsp:include page="<%= head %>" />


<div class='infoLeft left'>
<a id="prev" href='marches'><%= res.getString("lienRetour") %></a>
<%
			out.println("<h3>" + libelle + "</h3>");

			if(request.getParameter("success")!=null) {
				if(rs.getString("resultat").equals("2"))
					out.println("<span id='success'>" + res.getString("succes2") + "</span>");
				else
					out.println("<span id='success'>" + res.getString("succes") + "</span>");
			}
			if(request.getParameter("error")!=null) {
				if(request.getParameter("error").equals("1"))
					out.println("<span id='error'>" + res.getString("erreur1") + "</span>");
				else if(request.getParameter("error").equals("2"))
					out.println("<span id='error'>" + res.getString("erreur2") + "</span>");
				else
					out.println("<span id='error'>" + res.getString("erreur3") + "</span>");
			}

			if(rs.getString("resultat").equals("2"))
				out.println("<span class='small'>" + res.getString("inverse") + " <a class='orange' href='information?id=" + id + "&choix=" + ((choix==1)?0:1) + "'>" + res.getString("inverseLien") + "</a></span>");
%>

<p><%= res.getString("date") %> : <strong><%= rs.getString("d") %></strong>
<%
			if( fin.compareTo(new java.util.Date()) <= 0 && request.getUserPrincipal()!=null && rs.getString("login").equals(request.getUserPrincipal().getName()) && rs.getString("resultat").equals("2")) {
				out.println("<span id='result'><a href='resultat?id=" + request.getParameter("id") + "'>" + res.getString("resultat") + " ?</a></span>");
			}
%>
</p>
<%
			if( fin.compareTo(new java.util.Date()) > 0 && resultat.equals("2") ) {
%>

<table class="rouge">
	<tr>
		<th colspan="3"><%= res.getString("vend") %></th>
	</tr>
<%
				rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(DISTINCT userID) AS nbre, SUM(nombreRestant) AS somme, 100 - prix AS prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + ((choix==1)?0:1) + " AND nombreRestant <> 0 GROUP BY prix ORDER BY prix DESC");

				if(!rs.next())
					out.println("<tr class='empty info'><td colspan='3'>" + res.getString("pasVend") + "</td></tr>");
				else {
					do {
						out.println("<tr>");
						out.println("<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom"):"---") + "</td>");
						out.println("<td>" + rs.getString("somme") + " bons</td>");
						out.println("<td>" + rs.getString("prix") + "€/u</td>");
						out.println("</tr>");
					} while(rs.next());
				}
%>
</table>
<form id='acheter' method='POST' action='AcheterBons'>
<%
	out.println("<input type='hidden' id='id' name='id' value='" + request.getParameter("id") + "'/>");
	out.println("<input type='hidden' id='choix' name='choix' value='" + choix + "'/>");
%>
<table class="vert">
	<tr>
		<th colspan="3"><%= res.getString("ach") %></th>
	</tr>
<%
				rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(DISTINCT userID) AS nbre, SUM(nombreRestant) AS somme, prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + choix + " AND nombreRestant <> 0 GROUP BY prix ORDER BY prix DESC");
				if(!rs.next())
					out.println("<tr class='empty info'><td colspan='3'>" + res.getString("pasAch") + "</td></tr>");
				else {
					do {
						out.println("<tr class='info'>");
						out.println("<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom"):"---") + "</td>");
						out.println("<td>" + rs.getString("somme") + " bons</td>");
						out.println("<td>" + rs.getString("prix") + "€/u</td>");
						out.println("</tr>");
					} while(rs.next());
				}		
				if ( request.isUserInRole("Admin") || request.isUserInRole("MarketMaker") || request.isUserInRole("User") ){
							
					rs = st.executeQuery("SELECT (nom || ' ' || prenom) AS n FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
					rs.next();
				
				    out.println("<tr class='form'><td id='nom'>" + rs.getString("n") + "</td>");
					out.println("<td><input name='nbBons' class='number first' type='text' placeholder='X' /> bons</td>");
					out.println("<td><input name='prixBons' class='number' type='text' class='second' placeholder='€' /></td></tr>");
					out.println("<tr class='form'><td colspan='3'><span class='achatInfo'>" + res.getString("info") + "</span><input type='submit' value='" + res.getString("acheter") + "' id='achat' /></td></tr>");
				
				}
			}
%>
</table>
</form>
<%
			rs = st.executeQuery("SELECT count(*) AS nb FROM transactions WHERE marketID=" + id + " AND choix=" + choix + ";");
			int nb = 0;
			if(rs.next())
				nb = rs.getInt("nb");
			if(nb > 0) {
%>

<h3><%= res.getString("etatMarche") %></h3>
<div id="graphique" style="width: auto; height: 250px;"></div>

<%
			}
%>

</div>

<%
			if(request.getUserPrincipal()!=null) {
				rs 	= st.executeQuery("SELECT idUser, nom, prenom, argent - argentBloque AS argent FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
				rs.next();

%>
<div class='infoRight right'>
	<h2 class='withSmall'><%= rs.getString("nom")%> <%= rs.getString("prenom") %></h2>
	<span class='small'><%= res.getString("argent") %> : <%= rs.getString("argent") %>€</span>
<%
				if( fin.compareTo(new java.util.Date()) > 0 && resultat.equals("2") ) {
%>
	<h4><%= res.getString("invest") %></h4>
	<table class='invest'>
		<tr class='th'>
			<th><%= res.getString("nombre") %></th>
			<th><%= res.getString("prix") %></th>
			<th><%= res.getString("suppr") %></th>
		</tr>

<%
					rs 	= st.executeQuery("SELECT idTrans, nombreRestant, prix FROM transactions JOIN users ON transactions.userID=users.idUser WHERE login = '" + request.getUserPrincipal().getName() + "' AND marketID=" + request.getParameter("id") + " AND choix=" + choix + " AND nombreRestant<>0 ORDER BY prix ASC, nombreRestant ASC;");
					if(! rs.next())
						out.println("<tr class='empty info'><td colspan='3'>" + res.getString("invest") + "</td></tr>");
					else {
						do {
%>
		<tr>
			<td><%= rs.getString("nombreRestant") %> bons</td>
			<td><%= rs.getString("prix") %> euros/u</td>
			<td><a href='suppTrans?idTrans=<%= rs.getString("idTrans") %>&id=<%= request.getParameter("id") %>'>X</a></td>
		<tr>
<%
					} while(rs.next());
				}
%>
	</table>
	<h4 class='second'><%= res.getString("investA") %></h4>
	<table class='invest'>
		<tr class='th'>
			<th><%= res.getString("nombre") %></th>
			<th><%= res.getString("prix") %></th>
		</tr>

<%
				rs 	= st.executeQuery("SELECT idTrans, (nombre - nombreRestant) AS nombre, prix FROM transactions JOIN users ON transactions.userID=users.idUser WHERE login = '" + request.getUserPrincipal().getName() + "' AND marketID=" + request.getParameter("id") + " AND choix=" + choix + " AND nombre>nombreRestant ORDER BY prix ASC, nombreRestant ASC;");
				if(! rs.next())
					out.println("<tr class='empty info'><td colspan='3'>" + res.getString("invest0") + "</td></tr>");
				else {
					do {
%>
		<tr>
			<td><%= rs.getString("nombre") %> bons</td>
			<td class='last'><%= rs.getString("prix") %> euros/u</td>
		<tr>
<%
				} while(rs.next());
			}
		}
%>
	</table>
</div>
<%
	}
}
con.close();
}
%>
<link rel='stylesheet' href='CSS/morris-0.4.3.min.css' />
<script src='JS/jquery-1.9.1.js'></script>
<script src='JS/jquery-ui.js'></script>
<script src="JS/raphael-min.js"></script>
<script src="JS/morris-0.4.3.min.js"></script>
<script src='JS/information.js'></script>
<jsp:include page="footer.jsp" />
