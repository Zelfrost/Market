<%@ page import="tools.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?title=Recherche" />


<h2>Recherche</h2>

<%
    int nbRes = 0;
    
    String m = Marche.recherche(request.getParameter("search"));
    if(!m.equals("")) {
%>
<h3>Informations</h3>
<table>
    <tr class="th">
        <th>Libellé</th>
        <th>Date de fin</th>
        <th>Etat</th>
    </tr>

    <%= m %>
</table>
<%
        nbRes ++;
    }
%>

<%
	String u = Personne.recherche(request.getParameter("search"));
    if(!u.equals("")) {
%>
<h3>Utilisateurs</h3>
<table>
	<tr class="th">
		<th>Nom</th>
		<th>Mail</th>
	</tr>

    <%= u %>
</table>
<%
        nbRes ++;
    }
    if(nbRes == 0)
        out.println("Aucun résultat ne correspond à votre recherche");
%>

<jsp:include page="footer.jsp" />