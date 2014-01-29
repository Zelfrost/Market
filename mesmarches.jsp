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
	String old = request.getParameter("old");
	String toOld = "old=1&";
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
if (request.getUserPrincipal()!=null){
    rs = st.executeQuery("SELECT idUser from users where login='" + request.getUserPrincipal().getName() + "'");
    rs.next();
    String id = rs.getString("idUser");
    rs	= st.executeQuery("SELECT count(*) as c FROM markets where userid=" + id + " AND dateFin " + ((old==null)?">=":"<") + " date('now');");
    rs.next();

    int nbpages 	= 	(int)Math.ceil((double)rs.getInt("c") / 10);

    if( nbpages > 0 )
	out.println("pages : ");
    if( pages != 1 )
	out.println("(<a class='orange' href='mesmarches?" + ((old==null)?"":toOld) + "page=" + (pages-1) + "'>Précédent</a>)");
    for( int i = 1; i <= nbpages; i++ ) {
	if( i != pages )
	    out.println("<a class='orange' href='mesmarches?" + ((old==null)?"":toOld) + "page=" + i + "'>" + i + "</a>");
	else
	    out.println("<span>" + i + "</span>");
    }
    if( pages != nbpages )
	out.println("(<a class='orange' href='mesmarches?" + ((old==null)?"":toOld) + "page=" + (pages+1) + "'>Suivant</a>)");
	%>
	</div>

	<table>
	<tr class="th">
	<th>Titres</th>
	<th>Date de fin</th>
	<th>Taux</th>
	</tr>
	<%
	rs= st.executeQuery("SELECT idMarket, libelle, libelleInverse, to_char(dateFin, 'DD/MM/YYYY') as d, resultat FROM transactions JOIN users ON transactions.userID=users.idUser JOIN markets ON markets.idMarket=transactions.marketID WHERE transactions.userID=" + id + " AND dateFin>=DATE('now') GROUP BY idMarket, choix ORDER BY publication DESC LIMIT 10 OFFSET " + ((pages-1)*10) + ";");
    
    Statement stTaux;
    ResultSet rsTaux;
    int t0, t1, max, taux;
    while (rs.next()) {
	id 		= rs.getString("idMarket");
	out.println("<tr>");
	out.println("<td><a " + ((!rs.getString("resultat").equals("2"))?"style='color: #3322CC;'":"") + " href='information?id=" + id + "'>" + ((rs.getString("resultat").equals("1"))?rs.getString("libelleInverse"): rs.getString("libelle")) + "</a></td>");
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
}
con.close();
	%>

<jsp:include page="footer.jsp" />
