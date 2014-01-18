<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Page personnelle" />

<%
	
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("base");
    Connection con  = ds.getConnection();

    Statement st    = con.createStatement();
	ResultSet rs 	= 	st.executeQuery("SELECT idUser, nom, prenom, mail, argent FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
	rs.next();
	String id 		= rs.getString("idUser");
%>

<h2><%= rs.getString("prenom") + " " + rs.getString("nom") %></h2>

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

<table>
	<tr>
		<th>Libellé</th>
	</tr>
<%
	rs = st.executeQuery("SELECT idMarket, libelle, libelleInverse, choix FROM transactions JOIN users ON transactions.userID=users.idUser JOIN markets ON markets.idMarket=transactions.marketID WHERE transactions.userID=" + id + " ORDER BY publication DESC;");
	while(rs.next()) {
		out.println("<tr>");
		out.println( "<td style='text-align: center;'><a href='information?id=" + rs.getString("idMarket") + "&choix=" + rs.getString("choix") + "''>" + ((rs.getString("choix").equals("0"))?rs.getString("libelle"):rs.getString("libelleInverse")) + "</a></td>" );
		out.println("</tr>");
	}
%>
</table>


<jsp:include page="footer.jsp" />