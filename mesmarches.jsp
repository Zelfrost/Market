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
Personne util 	= (Personne)session.getAttribute("Personne");
String marches 	= util.tousMesMarches();

int pages 		= (request.getParameter("page")!=null)
		    		?Integer.parseInt(request.getParameter("page"))
		    		:1;

int nbpages 	= (int)Math.ceil((double)util.nbMesMarches() / 30);

if(nbpages > 1) {
	out.println("Pages : ");

	if(pages > 2)
    	out.println("(<a class='orange' href='mesmarches?page=1'>Début</a>)");
	if(pages > 1)
    	out.println("(<a class='orange' href='mesmarches?page=" + (pages-1) + "'>Précédent</a>)");

    for(int i=pages-4; i<pages; i++)
    	if(i > 0)
    		out.println("<a class='orange' href='mesmarches?page=" + i + "'>" + i + "</a>");

    out.println("<span>" + pages + "</span>");

    for(int i=pages+1; i<=pages+4; i++)
    	if(nbpages - i >= 0)
    		out.println("<a class='orange' href='mesmarches?page=" + i + "'>" + i + "</a>");

    if(nbpages - pages > 0)
		out.println("(<a class='orange' href='mesmarches?page=" + (pages+1) + "'>Suivant</a>)");
	if(pages < nbpages - 1)
		out.println("(<a class='orange' href='mesmarches?page=" + nbpages + "'>Fin</a>)");
}
%>
</div>

<table id='marches'>
	<tr class="th">
		<th>Titres</th>
		<th>Date de fin</th>
		<th>Etat</th>
	</tr>
	
	<%= marches %>

</table>


<jsp:include page="footer.jsp" />
