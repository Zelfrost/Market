<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Les marchés" />

<h2>Marchés en cours</h2>

<div id="selectpage">
    <%
	    int pages 		= 	(request.getParameter("pages")!=null)
				    		?Integer.parseInt(request.getParameter("pages"))
				    		:1;
        
        Context initCtx = 	new InitialContext();
        Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
        DataSource ds 	= 	(DataSource) envCtx.lookup("base");
        Connection con 	= 	ds.getConnection();

	    Statement st 	= 	con.createStatement();
	    ResultSet rs 	= 	st.executeQuery("SELECT count(*) as c FROM markets where dateFin > date('now');");
	    rs.next();

	    int nbpages 	= 	(int)Math.ceil((double)rs.getInt("c") / 10);

	    if( nbpages > 0 )
		    out.println("pages : ");
	    if( pages != 1 )
		    out.println("(<a href='marches?page=" + (pages-1) + "'>Précédent</a>)");
	    for( int i = 1; i <= nbpages; i++ ) {
		    if( i != pages )
			    out.println("<a href='marches?page=" + i + "'>" + i + "</a>");
		    else
			    out.println("<span>" + i + "</span>");
	    }
	    if( pages != nbpages )
		    out.println("(<a href='marches?page=" + (pages+1) + "'>Suivant</a>)");
	%>
</div>

<table>
	<tr class="th">
		<th>Titres</th>
		<th>Date de fin</th>
		<th>Taux</th>
	</tr>
	<%
		rs 			= st.executeQuery("SELECT idMarket, libelle, to_char(dateFin, 'DD/MM/YYYY') as d FROM markets WHERE dateFin > date('now') ORDER BY idMarket DESC LIMIT 10 OFFSET " + ((pages-1)*10) + ";");
		String id;
		Statement stTaux;
		ResultSet rsTaux;
		int t0, t1, max, taux;
		while (rs.next()) {
			id 		= rs.getString("idMarket");
		    out.println("<tr>");
		    out.println("<td><a href='information?id=" + id + "'>" + rs.getString("libelle") + "</a></td>");
		    out.println("<td>" + rs.getString("d") + "</td>");

		    stTaux 	= con.createStatement();
		    rsTaux 	= stTaux.executeQuery("SELECT sum(nombre * prix) AS t0 FROM transactions WHERE marketID = " + id + " AND choix = 0;");
		    rsTaux.next();
		    t0 		= rsTaux.getInt("t0");

		    rsTaux 	= stTaux.executeQuery("SELECT sum(nombre * prix) AS t1 FROM transactions WHERE marketID = " + id + " AND choix = 1;");
		    rsTaux.next();
		    t1 		= rsTaux.getInt("t1");

		    max 	= 	(t1>t0)
		    			?t1
		    			:t0;
		    try {
		    	taux = (int)(((double)max/(t0+t1))*100);
		    } catch(ArithmeticException e) {
		    	taux = 0;
			}

		    out.print("<td");
		    out.print( 	(taux==0)
		    			?">"
		    			:
		    				(t0==max)
		    				?" class='positif'>+"
		    				:" class='negatif'>-"
		   	);
		    out.println(taux + "%</td>");
		    out.println("</tr>");
		}
		out.println("</table>");

		rs = st.executeQuery("SELECT COUNT(*) AS c FROM markets WHERE dateFin<DATE('now');");
		if( rs.next() && rs.getInt("c")>0 )
			out.println("<a href='marchesFinis'>Voir les marchés terminés</a>");
		con.close();
	%>

<jsp:include page="footer.jsp" />
