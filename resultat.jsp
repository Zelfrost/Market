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
		int id 			= 	Integer.parseInt(request.getParameter("id"));
		
	    Context initCtx = 	new InitialContext();
	    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	    DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	    Connection con 	= 	ds.getConnection();

		Statement st 	= 	con.createStatement();
		ResultSet rs 	= 	st.executeQuery("SELECT libelle, to_char(dateFin, 'DD/MM/YYYY') AS d, login FROM markets JOIN users ON users.idUser=markets.userID WHERE idMarket='" + id +"';");
		rs.next();
		String[] date 	=	rs.getString("d").split("/");
		java.util.Date fin 	= 	new java.util.Date(	Integer.parseInt(date[2])-1900,
													Integer.parseInt(date[1])-1,
													Integer.parseInt(date[0])
								);
		if( (! rs.getString("login").equals(request.getUserPrincipal().getName())) || fin.compareTo(new java.util.Date()) > 0)
			response.sendRedirect("resultat");
%>
<jsp:include page="header.jsp?titre=Résultat d'un marché" />
<%		
		out.println("<h2>Résultat du marché</h2>");

		out.println("Le pronostic était : <strong>" +  rs.getString("libelle") + "</strong>.<br/>");
		out.println("<form method='POST' id='resultat' action='Result'>");
		out.println("<span>Est-ce que ce résultat est le bon ?</span>");
		out.println("<input type='hidden' name='id' value='" + id + "' />");
		out.println("<input type='radio' name='result' value='oui' /><span>Oui</span>");
		out.println("<input type='radio' name='result' value='non' /><span>Non</span>");
		out.println("<input type='submit' value='Confirmer' />");
		out.println("</form>");

		con.close();
	}
%>


<jsp:include page="footer.jsp" />