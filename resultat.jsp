<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>


<%
	if(request.getParameter("id")==null || request.getParameter("id").equals("")) {
%>
<jsp:include page="header.jsp?titre=Error" />
<%
		out.println("<span id='error'>Page non trouvée : <a href='index'>Retourner à l'accueil</a></span>");
	} else {
%>
<jsp:include page="header.jsp?titre=Résultat d'un marché" />
<%
		int id 			= 	Integer.parseInt(request.getParameter("id"));
		
	    Context initCtx 	= 	new InitialContext();
	    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	    DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	    Connection con 	= 	ds.getConnection();

		Statement st 	= 	con.createStatement();
		ResultSet rs 	= 	st.executeQuery("SELECT libelle, libelleInverse, to_char(dateFin, 'DD/MM/YYYY') as d FROM markets WHERE idMarket='" + id +"';");
		rs.next();
		
		out.println("<h2>Le marché</h2>");

		out.println("Est-ce que le résultat final est :<br/>");
		out.println("<span class='res'> - " + rs.getString("libelle") + "</span>");
	}
%>


<jsp:include page="footer.jsp" />