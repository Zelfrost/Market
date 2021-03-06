<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Page utilisateur" />

<%
	if(request.getParameter("id")==null || request.getParameter("id").equals("") || request.getParameter("id").equals("0"))
		response.sendRedirect("index");
	
	String id 		= request.getParameter("id");

    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("base");
    Connection con  = ds.getConnection();

    Statement st    = con.createStatement();
	ResultSet rs 	= 	st.executeQuery("SELECT nom, prenom, login, mail, argent - argentBloque AS argent FROM users WHERE idUser='" + id + "';");
	rs.next();
%>

<h2 id="perso"><%= rs.getString("nom") %></h2>

<div class="label">
	<span>Login : </span>
	<span><%= rs.getString("login") %></span/>
</div>

<div class="label">
	<span>Adresse Mail : </span>
	<span><%= rs.getString("mail") %></span>
</div>

<div class="label">
	<span>Argent : </span>
	<span><%= rs.getString("argent") %>€</span>
</div>

<%
	rs = st.executeQuery("SELECT count(*) AS nb, idMarket, libelle FROM transactions JOIN markets ON markets.idMarket=transactions.marketID WHERE transactions.userID=" + id + " GROUP BY idMarket ORDER BY publication DESC;");
	if(rs.next() && rs.getInt("nb") != 0 ) {
%>

<h3>Pronostics dans lesquels il a investi</h3>

<table>
	<tr class="th">
		<th>Libellé</th>
	</tr>
<%
		do {
			out.println("<tr>");
			out.println( "<td style='text-align: center;' class='invest'><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></td>" );
			out.println("</tr>");
		} while(rs.next());
%>
</table>
<%
	}
    
    con.close();
%>


<jsp:include page="footer.jsp" />