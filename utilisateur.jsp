<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Page utilisateur" />

<%
	if(request.getParameter("id")==null || request.getParameter("id").equals(""))
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
<%
	if(request.getParameter("success")!=null)
		out.println("<span id='success'>Vos modifications ont bien été prises en compte.</span>");
%>

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
	rs = st.executeQuery("SELECT count(*) AS nb, idMarket, libelle, libelleInverse, choix FROM transactions JOIN users ON transactions.userID=users.idUser JOIN markets ON markets.idMarket=transactions.marketID WHERE transactions.userID=" + id + " GROUP BY idMarket, choix ORDER BY publication DESC;");
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