<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?title=Recherche" />


<h2>Recherche</h2>

<%
    if(request.getParameter("search") == null || request.getParameter("search").equals("") )
        response.sendRedirect("index");

	Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("base");
    Connection con  = ds.getConnection();

    Statement st 	= con.createStatement();
    ResultSet rs;
    try {
        rs = st.executeQuery("SELECT idMarket, libelle, dateFin, resultat FROM markets WHERE idMarket<>0 AND ( libelle ILIKE '%" + request.getParameter("search") + "%' OR libelleInverse ILIKE '%" + request.getParameter("search") + "%' ) ORDER BY dateFin DESC;");

        int nbRes = 0;

        if( rs.next() ) {
        	nbRes ++;
%>
<h3>Informations</h3>
<table>
	<tr class="th">
		<th>Libellé</th>
		<th>Date de fin</th>
	</tr>
<%
        	do {
        		out.println("<tr>");
        		out.println("<td><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></td>");
        		out.println("<td>" + rs.getString("dateFin") + "</td>");
        		out.println("</tr>");
    		} while (rs.next());
    	}
%>
</table>
<%
    	rs 	= st.executeQuery("SELECT idUser, ( prenom || ' ' || nom ) AS nom, mail FROM users WHERE idUser<>0 AND ( nom ILIKE '%" + request.getParameter("search") + "%' OR prenom ILIKE '%" + request.getParameter("search") + "%' OR login ILIKE '%" + request.getParameter("search") + "%' OR mail ILIKE '%" + request.getParameter("search") + "%' ) ORDER BY nom, prenom;");
    	if( rs.next() ) {
        	nbRes ++;
%>
<h3>Utilisateurs</h3>
<table>
	<tr class="th">
		<th>Nom</th>
		<th>Mail</th>
	</tr>
<%
        	do {
        		out.println("<tr>");
        		out.println("<td><a href='utilisateur?id=" + rs.getString("idUser") + "'>" + rs.getString("nom") + "</a></td>");
        		out.println("<td>" + rs.getString("mail") + "</td>");
        		out.println("</tr>");
    		} while (rs.next());
%>
</table>
<%
    	}
        if(nbRes == 0)
            out.println("Aucun résultat ne correspond à votre recherche");
    } catch( SQLException e ) {
        out.println("Exception Throw");
    }
    con.close();
%>

<jsp:include page="footer.jsp" />