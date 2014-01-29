<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.informationFinit", loc);
%>

<%
	if(request.getParameter("id")==null || request.getParameter("id").equals("") || request.getParameter("id").equals("0")) {
%>
<jsp:include page="header.jsp?titre=Erreur" />
<%
		out.println("<span id='error'>" + res.getString("erreur") + "</span>");
	} else {
		int id 			= 	Integer.parseInt(request.getParameter("id"));
		int choix 		= 	(request.getParameter("choix")!=null)
							?Integer.parseInt(request.getParameter("choix"))
							:0;
		
	    Context initCtx = 	new InitialContext();
	    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	    DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	    Connection con 	= 	ds.getConnection();

		Statement st 	= 	con.createStatement();
		ResultSet rs 	= 	st.executeQuery("SELECT libelle, libelleInverse, to_char(dateFin, 'DD/MM/YYYY') as d, resultat, login FROM markets JOIN users on users.idUser=markets.userID WHERE idMarket='" + id +"';");

		if(!rs.next())
			response.sendRedirect("information");
		else {
			String libelle = rs.getString("libelle");

			String[] date 	=	rs.getString("d").split("/");
			java.util.Date fin 	= 	new java.util.Date(	Integer.parseInt(date[2])-1900,
															Integer.parseInt(date[1])-1,
															Integer.parseInt(date[0])
									);
			String resultat = rs.getString("resultat");
			String head 	= 	"header.jsp?titre=" + libelle;
%>
<jsp:include page="<%= head %>" />
<%
		}
	}
%>
<jsp:include page="footer.jsp" />