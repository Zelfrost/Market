<%@ page import="tools.*" %>
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

<%
  Marche m = new Marche(0);
  String tm = m.tousMarches();
  if(! tm.equals("")) {
%>
     
    <div class="menu">
        <div class="header">
            <%= res.getString("dern_marches") %>
        </div>
        <div class="body">
            <ul>
                <%= tm %>
                <li class="all"><a href="marches"><%= res.getString("tous_marches") %></a></li>
            </ul>
        </div>
    </div>
<% 
  }
  if (request.getUserPrincipal() != null){
    String mm = ((Personne)session.getAttribute("Personne")).mesMarches();
    if(! mm.equals("0")) {
%>
    <div class="menu">
      <div class="header">
        <%= res.getString("mes_marches") %>
      </div>
      <div class="body">
        <ul>
          <%= mm %>
          <li class="all"><a href="mesmarches"><%= res.getString("tous_mes_marches") %></a></li>
        </ul>
      </div>
    </div>
<%
    }
  }
%>
</div>
<jsp:include page="footer.jsp" />