<%@ page import="tools.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Les marchés" />

<%
	String old = request.getParameter("old");
	String toOld = "old=1&";

	if((request.isUserInRole("Admin") || request.isUserInRole("MarketMaker")) && old==null)
		out.println("<div id='prono'><a href='creerPronostic'>Créer un marché</a></div>");
	
	out.println( (old==null)?"<h2>Marchés en cours</h2>":"<h2>Marchés terminés</h2>" );
%>

<div id="selectpage">
<%
    int pages 		= 	(request.getParameter("page")!=null)
			    		?Integer.parseInt(request.getParameter("page"))
			    		:1;

    Marche m = new Marche(0);
    int nbpages 	= 	(int)Math.ceil((double)((old==null)?m.nbMarches():m.nbMarchesFinit()) / 30);

    if(nbpages > 1) {
		out.println("Pages : ");

		if(pages > 2)
	    	out.println("(<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=1'>Début</a>)");
    	if(pages > 1)
	    	out.println("(<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + (pages-1) + "'>Précédent</a>)");

	    for(int i=pages-4; i<pages; i++)
	    	if(i > 0)
	    		out.println("<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + i + "'>" + i + "</a>");

	    out.println("<span>" + pages + "</span>");

	    for(int i=pages+1; i<=pages+4; i++)
	    	if(nbpages - i >= 0)
	    		out.println("<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + i + "'>" + i + "</a>");

	    if(nbpages - pages > 0)
			out.println("(<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + (pages+1) + "'>Suivant</a>)");
		if(pages < nbpages - 1)
			out.println("(<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + nbpages + "'>Fin</a>)");
	}

    if( pages != nbpages )
%>
</div>

<table id="marches">
	<tr class="th">
		<th>Titres</th>
		<th>Date de fin</th>
		<th>Etat</th>
	</tr>
<%
	if(old == null)
		out.println( m.marchesEnCours(((pages-1)*30)) );
	else
		out.println( m.marchesFinit(((pages-1)*30)) );
%>
</table>

<%
	if(old!=null)
		out.println("En <span style='color: #3322CC;'>bleu</span>, les pronostics dont le résultat a été ajouté<br/>");

	int hasOther = ((old==null)?m.nbMarchesFinit():m.nbMarches());
	if( hasOther>0 )
		out.println("<a href='marches?" + ((old==null)?"old=1":"") + "' class='orange next' >Voir les marchés " + ((old==null)?"terminés":"en cours") + "</a>");
%>

<jsp:include page="footer.jsp" />