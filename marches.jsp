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
    Connection con = null;
    try {
        Context initCtx = 	new InitialContext();
        Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
        DataSource ds 	= 	(DataSource) envCtx.lookup("base");
        con 	= 	ds.getConnection();

	    Statement st 	= 	con.createStatement();
	    ResultSet rs 	= 	st.executeQuery("SELECT count(*) as c FROM markets where dateFin " + ((old==null)?">=":"<") + " date('now');");
	    rs.next();

	    int nbpages 	= 	(int)Math.ceil((double)rs.getInt("c") / 10);

	    if( nbpages > 0 )
		    out.println("pages : ");
	    if( pages != 1 )
		    out.println("(<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + (pages-1) + "'>Précédent</a>)");
	    for( int i = 1; i <= nbpages; i++ ) {
		    if( i != pages )
			    out.println("<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + i + "'>" + i + "</a>");
		    else
			    out.println("<span>" + i + "</span>");
	    }
	    if( pages != nbpages )
		    out.println("(<a class='orange' href='marches?" + ((old==null)?"":toOld) + "page=" + (pages+1) + "'>Suivant</a>)");
%>
</div>

<table>
	<tr class="th">
		<th>Titres</th>
		<th>Date de fin</th>
		<th>Taux</th>
	</tr>
<%
	Marche m = new Marche(0);
	if(old == null)
		out.println( m.marchesEnCours(((pages-1)*10)) );
	else
		out.println( m.marchesFinit(((pages-1)*10)) );
%>
</table>

<%
		if(old!=null)
			out.println("En <span style='color: #3322CC;'>bleu</span>, les pronostics dont le résultat a été ajouté<br/>");

		rs = st.executeQuery("SELECT COUNT(*) AS c FROM markets WHERE " + ((old==null)?"dateFin<DATE('now')":"dateFin>=DATE('now')") + ";");
		if( rs.next() && rs.getInt("c")>0 )
			out.println("<a href='marches?" + ((old==null)?"old=1":"") + "' class='orange next' >Voir les marchés " + ((old==null)?"terminés":"en cours") + "</a>");

		con.close();
	} catch(SQLException e) {
	    try { con.close(); } catch(Exception ex) { /* Ignored */ }
	}
%>

<jsp:include page="footer.jsp" />