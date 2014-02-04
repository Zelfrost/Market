<%@ page import="tools.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>


<%
	if(request.getParameter("id")==null || request.getParameter("id").equals(""))
		response.sendRedirect("marches");
	else {
%>
<jsp:include page="header.jsp?titre=Résultat d'un marché" />
<%
		int id 			= 	Integer.parseInt(request.getParameter("id"));
		Marche m 		= 	new Marche(id);

		String[] heure 	= m.dateFin().substring(0, 5).split(":");
		String[] date 	= m.dateFin().substring(6,14).split("/");
		java.util.Date fin 	= new java.util.Date(	Integer.parseInt(date[2])-1900,
													Integer.parseInt(date[1])-1,
													Integer.parseInt(date[0]),
													Integer.parseInt(heure[0])-1,
													Integer.parseInt(heure[1]) );
		
		if( m.createur() != ((Personne)session.getAttribute("Personne")).id()
						 || fin.compareTo(new java.util.Date()) < 0 )
			response.sendRedirect("resultat");
		else {
%>
	<h2>Résultat du marché</h2>

	Le pronostic était : <strong><%= m.libelle() %></strong>.<br/>
	<form method='POST' id='resultat' action='Result'>
		<span>Est-ce que ce résultat est le bon ?</span>
		<input type='hidden' name='id' value='<%= id %>' />
		<input type='radio' name='result' value='oui' /><span>Oui</span>
		<input type='radio' name='result' value='non' /><span>Non</span>
		<input type='submit' value='Confirmer' />
	</form>
<%
		}
	}
%>


<jsp:include page="footer.jsp" />