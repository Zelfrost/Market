<%@ page import="tools.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.information", loc);

	if(request.getParameter("id")==null || request.getParameter("id").equals("") || request.getParameter("id").equals("0")) {
%>
<jsp:include page="header.jsp?titre=Error" />
<%
		out.println("<span id='error'>" + res.getString("erreur") + "</span>");
	} else {
		Personne util 	= 	(Personne) session.getAttribute("Personne");
		int id 			= 	Integer.parseInt(request.getParameter("id"));
		int choix 		= 	(request.getParameter("choix")!=null)
							?Integer.parseInt(request.getParameter("choix"))
							:0;
		
	    Context initCtx = 	new InitialContext();
	    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	    DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	    Connection con 	= 	ds.getConnection();

		Statement st 	= 	con.createStatement();
		ResultSet rs;

		Marche m 		= new Marche(id);

		if(m.libelle() == null)
			response.sendRedirect("information");
		else {

			if(! m.resultat().equals("2"))
				response.sendRedirect("informationFinit?id=" + id);
			else {
				String libelle 	= 	(choix==0)
								?m.libelle()
								:m.libelleInverse();

				String[] date 	= m.dateFin().split("/");
				java.util.Date fin 	= new java.util.Date(	Integer.parseInt(date[2])-1900,
																Integer.parseInt(date[1])-1,
																Integer.parseInt(date[0])
										);
				String resultat = m.resultat();
				String head 	= "header.jsp?titre=" + libelle;
%>
<jsp:include page="<%= head %>" />


<div class='infoLeft left'>
<a id="prev" href='marches'><%= res.getString("lienRetour") %></a>
<%
				out.println("<h3>" + libelle + "</h3>");

				if(request.getParameter("success")!=null)
					out.println("<span id='success'>" + res.getString("succes") + "</span>");
				if(request.getParameter("error")!=null) {
					if(request.getParameter("error").equals("1"))
						out.println("<span id='error'>" + res.getString("erreur1") + "</span>");
					else if(request.getParameter("error").equals("2"))
						out.println("<span id='error'>" + res.getString("erreur2") + "</span>");
					else
						out.println("<span id='error'>" + res.getString("erreur3") + "</span>");
				}

				out.println("<span class='small'>" + res.getString("inverse") + " <a class='orange' href='information?id=" + id + "&choix=" + ((choix==1)?0:1) + "'>" + res.getString("inverseLien") + "</a></span>");
%>

<p><%= res.getString("date") %> : <strong><%= m.dateFin() %></strong>
<%
				if( fin.compareTo(new java.util.Date()) <= 0 && request.getUserPrincipal()!=null && m.id() == util.id())
					out.println("<span id='result'><a href='resultat?id=" + id + "'>" + res.getString("resultat") + " ?</a></span>");
%>
</p>
<%
				if( fin.compareTo(new java.util.Date()) > 0 ) {
%>

<table class="rouge">
	<tr>
		<th colspan="3"><%= res.getString("vend") %></th>
	</tr>
<%
					rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(DISTINCT userID) AS nbre, SUM(nombreRestant) AS somme, 100 - prix AS prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + ((choix==1)?0:1) + " AND nombreRestant <> 0 AND etat = 0 GROUP BY prix ORDER BY prix DESC");

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
					rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(DISTINCT userID) AS nbre, SUM(nombreRestant) AS somme, prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + choix + " AND nombreRestant <> 0 AND etat = 0 GROUP BY prix ORDER BY prix DESC");
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
						out.println("<tr class='form'><td colspan='3'><span class='achatInfo'>" + res.getString("info") + "</span><input type='submit' name='valider' value='" + res.getString("acheter") + "' class='achat' /><input type='submit' name='valider' value='" + res.getString("vendre") + "' class='achat' /></td></tr>");
					
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

%>
<div class='infoRight right'>
	<h2 class='withSmall'><%= util.prenom() + " " + util.nom() %></h2>
	<span class='small'><%= res.getString("argent") %> : <%= util.argentDispo() %>€</span>
<%
					if( fin.compareTo(new java.util.Date()) > 0 ) {
%>
	<h4><%= res.getString("invest") %></h4>
	<table class='invest'>
		<tr class='th'>
			<th><%= res.getString("nombre") %></th>
			<th><%= res.getString("prix") %></th>
			<th><%= res.getString("suppr") %></th>
		</tr>

<%
						String bons = util.getBons(id, choix);
						if(bons.equals("0"))
							out.println("<tr class='empty info'><td colspan='3'>" + res.getString("invest0") + "</td></tr>");
						else
							out.println(bons);
%>
	</table>
	<h4 class='second'><%= res.getString("investA") %></h4>
	<table class='invest'>
		<tr class='th'>
			<th><%= res.getString("nombre") %></th>
			<th><%= res.getString("prix") %></th>
		</tr>

<%
						String titres = util.getTitres(id, choix);
						if(titres.equals("0"))
							out.println("<tr class='empty info'><td colspan='3'>" + res.getString("invest0") + "</td></tr>");
						else
							out.println(titres);
%>
	</table>
</div>
<%
	}
			}
		}
		con.close();
	}
}	
%>
<link rel='stylesheet' href='CSS/morris-0.4.3.min.css' />
<script src='JS/jquery-1.9.1.js'></script>
<script src='JS/jquery-ui.js'></script>
<script src="JS/raphael-min.js"></script>
<script src="JS/morris-0.4.3.min.js"></script>
<script src='JS/information.js'></script>
<jsp:include page="footer.jsp" />
