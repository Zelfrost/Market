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
    <h2><%= (String)res.getObject("titre") %></h2>
    <%= (String)res.getObject("contenu") %>
</div>

<div class="right">
    <div class="menu">
        <div class="header">
            <%= (String)res.getObject("rechercher") %>
        </div>
        <div class="body">
            <form method="POST" action="recherche">
                <input type="text" name="search" />
                <input type="submit" value="<%= (String)res.getObject("valider") %>" />
            </form>
        </div>
    </div>
     
    <div class="menu">
        <div class="header">
            <%= (String)res.getObject("dern_marches") %>
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
    con.close();
%>
                <li class="all"><a href="marches"><%= (String)res.getObject("tous_marches") %></a></li>
            </ul>
        </div>
     </div>
    <div class="menu">
      <div class="header">
    <%= (String)res.getObject("mes_marches") %>
      </div>
      <div class="body">
         <ul>
<%
    rs=st.executeQuery(
</div>

<jsp:include page="footer.jsp" />