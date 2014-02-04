<%@ page import="tools.Personne" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Mes marchés" />

<%
        Locale loc = (Locale) session.getAttribute("loc");
        ResourceBundle res  = ResourceBundle.getBundle("prop.index", loc);
%>	
        <h2> <%=res.getString("mes_marches")%></h2>


<div id="selectpage">

<%
int pages= 	(request.getParameter("page")!=null)
    ?Integer.parseInt(request.getParameter("page"))
    :1;

Context initCtx = 	new InitialContext();
Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
DataSource ds 	= 	(DataSource) envCtx.lookup("base");
Connection con 	= 	ds.getConnection();

Statement st 	= 	con.createStatement();
ResultSet rs ;
Personne util 	= (Personne)session.getAttribute("Personne");
String marches 	= util.tousMesMarches();

if(! marches.equals("0")) {

    int nbpages = 	(int)Math.ceil((double)util.nbMesMarches() / 10);

    if( nbpages > 0 )
	out.println("pages : ");
    if( pages != 1 )
	out.println("(<a class='orange' href='mesmarches?page=" + (pages-1) + "'>Précédent</a>)");
    for( int i = 1; i <= nbpages; i++ ) {
	if( i != pages )
	    out.println("<a class='orange' href='mesmarches?page=" + i + "'>" + i + "</a>");
	else
	    out.println("<span>" + i + "</span>");
    }
    if( pages != nbpages )
	out.println("(<a class='orange' href='mesmarches?page=" + (pages+1) + "'>Suivant</a>)");
%>
</div>

<table>
	<tr class="th">
		<th>Titres</th>
		<th>Date de fin</th>
		<th>Taux</th>
	</tr>
	
	<%= marches %>

</table>
<%
}
con.close();
%>

<jsp:include page="footer.jsp" />
