<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp" />

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.index", loc);
%>

<div class="left">
    <h2><%= res.getString("titre") %></h2>
    <%= res.getString("contenu") %>
</div>

<div class="right">
    <div class="menu">
        <div class="header">
            <%= res.getString("rechercher") %>
        </div>
        <div class="body">
            <form method="POST" action="recherche">
                <input type="text" name="search" />
                <input type="submit" value="<%= res.getString("valider") %>" />
            </form>
        </div>
    </div>
     
    <div class="menu">
        <div class="header">
            <%= res.getString("dern_marches") %>
        </div>
        <div class="body">
            <ul>
<%
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("base");
    Connection con  = ds.getConnection();

    Statement st    = con.createStatement();
    ResultSet rs    = st.executeQuery("SELECT idMarket, libelle FROM markets WHERE dateFin>=DATE('now') ORDER BY publication DESC LIMIT 10");

    while (rs.next())
        out.println("<li><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></li>");
  
%>
                <li class="all"><a href="marches"><%= res.getString("tous_marches") %></a></li>
            </ul>
        </div>
    </div>
<% 
   if (request.getUserPrincipal()!=null){
%>
    <div class="menu">
      <div class="header">
	<%= res.getString("mes_marches") %>
      </div>
      <div class="body">
        <ul>
<%
   rs = st.executeQuery("SELECT idUser from users where login='" + request.getUserPrincipal().getName() + "'");
   rs.next();
   String id = rs.getString("idUser");
   rs = st.executeQuery("SELECT count(*) AS nb, idMarket, libelle, choix FROM transactions JOIN users ON transactions.userID=users.idUser JOIN markets ON markets.idMarket=transactions.marketID WHERE transactions.userID=" + id + " AND dateFin>=DATE('now') GROUP BY idMarket, choix ORDER BY publication DESC LIMIT 10;");
   
   while (rs.next())
   out.println("<li><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></li>");
%>
<li class="all"><a href="mesmarches"><%= res.getString("tous_mes_marches") %></a></li>
	</ul>
      </div>
    </div>
<%
   }
   con.close();
%>
</div>

<jsp:include page="footer.jsp" />
