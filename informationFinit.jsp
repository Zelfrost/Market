<%@ page import="tools.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
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
		
	    Marche m 		= new Marche(id);

		if(m.libelle() == null)
			response.sendRedirect("marches");
		else {
			String head 	= 	"header.jsp?titre=" + m.libelle();
%>
<jsp:include page="<%= head %>" />
			<h3><%= m.libelle() %></h3>
			<p>
				<%= res.getString("dateD") %> : <strong><%= m.dateDebut() %></strong>
			</p>
			<p>
				<%= res.getString("dateF") %> : <strong><%= m.dateFin() %></strong>
			</p>

			<span id="rsltt">
<%
			if(m.resultat().equals("0"))
				out.println(res.getString("gagne"));
			else
				out.println(res.getString("perd"));
		}
	}
%>
<jsp:include page="footer.jsp" />