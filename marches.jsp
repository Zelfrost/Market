<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Les marchés" />

<h2>Marchés en cours</h2>

<div id="selectPage">
	<%
	int p = 	(request.getParameter("page")!=null)
				?Integer.parseInt(request.getParameter("page"))
				:1;

	Class.forName("org.sqlite.JDBC");
	Connection con = DriverManager.getConnection("jdbc:sqlite:base.db");

	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("SELECT count(*) as c FROM markets where dateFin > date('now');");

	int nbPages = (int)Math.ceil((double)rs.getInt("c") / 10);
	if(nbPages>0)
		out.println("Pages : ");
	if(p!=1)
		out.println("(<a href='marches.jsp?page=" + (p-1) + "'>Précédent</a>)");
	for( int i=1; i<=nbPages; i++ ) {
		if(i!=p)
			out.println("<a href='marches.jsp?page=" + i + "'>" + i + "</a>");
		else
			out.println("<span>" + i + "</span>");
	}
	if(p!=nbPages)
		out.println("(<a href='marches.jsp?page=" + (p+1) + "'>Suivant</a>)");
	%>
</div>

<table>
	<tr class="th">
		<th>Titres</th>
		<th>Date de fin</th>
		<th>Taux</th>
	</tr>
	<%
	rs = st.executeQuery("SELECT idMarket, libelle, strftime('%d/%m/%Y', dateFin) AS d FROM markets WHERE dateFin > date('now') ORDER BY idMarket DESC LIMIT 10 OFFSET " + ((p-1)*10) + ";");
	String id;
	Statement stTaux;
	ResultSet rsTaux;
	int t0, t1, max, taux;
	while (rs.next()) {
		id = rs.getString("idMarket");
	    out.println("<tr>");
	    out.println("<td><a href='information.jsp?id=" + id + "'>" + rs.getString("libelle") + "</a></td>");
	    out.println("<td>" + rs.getString("d") + "</td>");

	    stTaux = con.createStatement();
	    rsTaux = stTaux.executeQuery("SELECT sum(nombre * prix) AS t0 FROM transactions WHERE marketID = " + id + " AND choix = 0;");
	    rsTaux.next();
	    t0 = rsTaux.getInt("t0");

	    rsTaux = stTaux.executeQuery("SELECT sum(nombre * prix) AS t1 FROM transactions WHERE marketID = " + id + " AND choix = 1;");
	    rsTaux.next();
	    t1 = rsTaux.getInt("t1");

	    max = 	(t1>t0)
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
	con.close();
	%>
</table>

<jsp:include page="footer.jsp" />