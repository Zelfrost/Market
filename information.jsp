<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
	if(request.getParameter("id")==null || request.getParameter("id").equals("")) {
%>
<jsp:include page="header.jsp?titre=Error" />
<%
		out.println("<span id='error'>Page non trouvée : <a href='index'>Retourner à l'accueil</a></span>");
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
			String head 	= 	"header.jsp?titre=" + libelle;
%>
<jsp:include page="<%= head %>" />

<a id="prev" href='marches'>Retour aux marchés</a>
<%
			if(request.getParameter("success")!=null) {
				if(rs.getString("resultat").equals("2"))
					out.println("<span id='success'>Votre transaction s'est bien déroulée</span>");
				else
					out.println("<span id='success'>L'évènement a bien été mis à jour.</span>");
			}
			if(request.getParameter("error")!=null) {
				if(request.getParameter("error").equals("1"))
					out.println("<span id='error'>Vous ne possédez pas suffisamment d'argent</span>");
				else if(request.getParameter("error").equals("2"))
					out.println("<span id='error'>Le prix entré n'est pas un nombre</span>");
				else
					out.println("<span id='error'>Le prix entré n'est pas compris entre 1 et 99</span>");
			}

			out.println("<h3>" + libelle + "</h3>");

			if(rs.getString("resultat").equals("2"))
				out.println("<span class='small'>Si vous ne croyez pas en cette information, investissez dans <a href='information?id=" + id + "&choix=" + ((choix==1)?0:1) + "'>le pronostic inverse</a></span>");
%>

<p>Date de fin : <strong><%= rs.getString("d") %></strong>
<%
			if( fin.compareTo(new java.util.Date()) <= 0 && request.getUserPrincipal()!=null && rs.getString("login").equals(request.getUserPrincipal().getName()) && rs.getString("resultat").equals("2")) {
				out.println("<span id='result'><a href='resultat?id=" + request.getParameter("id") + "'>Résultat ?</a></span>");
			}
%>
</p>
<p>État de l'offre : <strong>
	<%
			if(! rs.getString("resultat").equals("2"))
				out.println("Terminé</strong> - <span style='color: green'>Le libellé affiché est celui qui s'est avéré vrai</span>");
			else {
				if(fin.compareTo(new java.util.Date()) <= 0)
					out.println("Terminé</strong> - Résultat en attente</span>");
				else
					out.println("En cours</strong>");
			}
%>
</p>
<%
			if( fin.compareTo(new java.util.Date()) > 0 && rs.getString("resultat").equals("2") ) {
%>

<table class="rouge">
	<tr>
		<th colspan="3">Vendeurs</th>
	</tr>
<%
				rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(DISTINCT userID) AS nbre, SUM(nombreRestant) AS somme, 100 - prix AS prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + ((choix==1)?0:1) + " AND nombreRestant <> 0 GROUP BY prix ORDER BY prix DESC");

				if(!rs.next())
					out.println("<tr class='empty info'><td colspan='3'>Pas de vendeurs</td></tr>");
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
				rs = st.executeQuery("SELECT MIN(userID) AS userID, MIN(nom || ' ' || prenom) AS nom, count(DISTINCT userID) AS nbre, SUM(nombreRestant) AS somme, prix FROM transactions LEFT JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + choix + " AND nombreRestant <> 0 GROUP BY prix ORDER BY prix DESC");
				if(!rs.next())
					out.println("<tr class='empty info'><td colspan='3'>Pas d'acheteurs</td></tr>");
				else {
					do {
						out.println("<tr class='info'>");
						out.println("<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom"):"---") + "</td>");
						out.println("<td>" + rs.getString("somme") + " bons</td>");
						out.println("<td>" + rs.getString("prix") + "€</td>");
						out.println("</tr>");
					} while(rs.next());
				}		
				if ( request.isUserInRole("Admin") || request.isUserInRole("MarketMaker") || request.isUserInRole("User") ){
							
					rs = st.executeQuery("SELECT (nom || ' ' || prenom) AS n FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
					rs.next();
				
				    out.println("<tr class='form'><td id='nom'>" + rs.getString("n") + "</td>");
					out.println("<td><input name='nbBons' type='number' class='first' /> bons</td>");
					out.println("<td><input name='prixBons' type='number' class='second' placeholder='€' /></td></tr>");
					out.println("<tr class='form'><td colspan='3'><span class='achatInfo'>Un bon s'achète entre 1 et 99€, le prix doit être un entier</span><input type='submit' value='acheter' /></td></tr>");
				
				}
				
				con.close();
			}
		}
%>
</table>
</form>
<%
	}
%>


<jsp:include page="footer.jsp" />
