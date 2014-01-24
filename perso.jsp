<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Page personnelle" />


<script src="JS/jquery-1.9.1.js"></script>
<script src="JS/perso.js"></script>

<%
	
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("base");
    Connection con  = ds.getConnection();

    Statement st    = con.createStatement();
	ResultSet rs 	= 	st.executeQuery("SELECT idUser, nom, prenom, mail, argent - argentBloque AS argent FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
	rs.next();
	String id 		= rs.getString("idUser");
%>

<h2 id="perso"><%= rs.getString("prenom") + " " + rs.getString("nom") %></h2>
<a href='changePerso' class='orange'>Changer mes infos</a>
<%
	if(request.getParameter("success")!=null)
		out.println("<span id='success'>Vos modifications ont bien été prises en compte.</span>");
%>

<div class="label">
	<span>Login : </span>
	<span><%= request.getUserPrincipal().getName() %></span/>
</div>

<div class="label">
	<span>Adresse Mail : </span>
	<span><%= rs.getString("mail") %></span>
</div>

<div class="label">
	<span>Argent restant : </span>
	<span><%= rs.getString("argent") %>€</span>
</div>


<% 
	rs = st.executeQuery("SELECT count(*) AS nb, idMarket, libelle FROM markets WHERE markets.userID=" + id + " AND dateFin=DATE('now') AND resultat=2 GROUP BY idMarket, libelle ORDER BY publication DESC;");
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
%>
</table>


<%
	}
%>

<div class="persoInfo">
	<div id="achetes">
		Vous avez acheté <span id="nbA"></span> bons 
		aux prix de <span id="prixA"></span>€
	</div>

	<div id="restants">
		Vous avez <span id="nb"></span> bons en attente
		aux prix de <span id="prix"></span>€
	</div>
</div>

<%
	rs = st.executeQuery("SELECT count(*) AS nb, idMarket, libelle, libelleInverse, choix FROM transactions JOIN users ON transactions.userID=users.idUser JOIN markets ON markets.idMarket=transactions.marketID WHERE transactions.userID=" + id + " GROUP BY idMarket, choix ORDER BY publication DESC;");
	if(rs.next() && rs.getInt("nb") != 0 ) {
%>

<h3>Pronostics dans lesquels vous avez investis</h3>

<table>
	<tr class="th">
		<th>Libellé</th>
	</tr>
<%
		do {
			out.println("<tr>");
			out.println( "<td style='text-align: center;' class='invest' id='" + rs.getString("idMarket") + ":" + rs.getString("choix") + "'><a href='information?id=" + rs.getString("idMarket") + "&choix=" + rs.getString("choix") + "'>" + ((rs.getString("choix").equals("0"))?rs.getString("libelle"):rs.getString("libelleInverse")) + "</a></td>" );
			out.println("</tr>");
		} while(rs.next());
%>
</table>
<%
	}
    
    con.close();
%>


<jsp:include page="footer.jsp" />