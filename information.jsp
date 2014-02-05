<%@ page import="tools.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
	if(request.getParameter("id")==null || request.getParameter("id").equals("") || request.getParameter("id").equals("0"))
		response.sendRedirect("marches");
	else {
		int id 			= 	Integer.parseInt(request.getParameter("id"));
		int choix 		= 	(request.getParameter("choix")!=null)
							?Integer.parseInt(request.getParameter("choix"))
							:0;

		Marche m 		= new Marche(id);

		if(m.libelle() == null)
			response.sendRedirect("marches");
		else {
			if(! m.resultat().equals("2"))
				response.sendRedirect("informationFinit?id=" + id);
			else {
				String libelle 	= 	(choix==0)
									?m.libelle()
									:m.libelleInverse();
				java.util.Date fin 	= new java.util.Date( m.dateFinEpoch() * 1000 );
				String resultat = m.resultat();
				String head 	= "header.jsp?titre=" + libelle;
%>

<jsp:include page="<%= head %>" />

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.information", loc);
%>


<div class='infoLeft left'>
<a id="prev" href='marches'><%= res.getString("lienRetour") %></a>
<%
				Personne util = null;
				if(request.getUserPrincipal() != null)
					util 		= (Personne) session.getAttribute("Personne");

				out.println("<div><h3 class='followLink'>" + libelle + "</h3>");

				out.println("<span class='small'>" + res.getString("inverse") + " <a class='orange' href='information?id=" + id + "&choix=" + ((choix==1)?0:1) + "'>" + res.getString("inverseLien") + "</a></span></div>");
%>

<p><%= res.getString("date") %> : <strong><%= m.dateFin() %></strong>
<%
				if( (! fin.after(new java.util.Date())) && request.getUserPrincipal()!=null && m.createur() == util.id())
					out.println("<span id='result'><a href='resultat?id=" + id + "'>" + res.getString("resultat") + " ?</a></span>");
%>
</p>

<table class="rouge">
	<thead>
		<tr class='th'>
			<th colspan="3"><%= res.getString("vend") %></th>
		</tr>
	</thead>
	<tbody>
<%
					String vente = m.proposition((choix==0)?1:0, 1);
					if(vente.equals("0"))
						out.println("<tr class='empty info'><td colspan='3'>" + res.getString("pasVend") + "</td></tr>");
					else
						out.println(vente);
%>
	</tbody>
</table>
<form id='acheter' method='POST' action='AcheterBons'>
<%
					out.println("<input type='hidden' id='id' name='id' value='" + request.getParameter("id") + "'/>");
					out.println("<input type='hidden' id='choix' name='choix' value='" + choix + "'/>");
%>
<table class="vert">
	<thead>
		<tr class='th'>
			<th colspan="3"><%= res.getString("ach") %></th>
		</tr>
	</thead>
<%
				if( fin.after(new java.util.Date()) && request.getUserPrincipal() != null ) {
				    out.println("<tfoot><tr class='form'><td id='nom'>" + util.nom() + " " + util.prenom() +  "</td>");
					out.println("<td><input name='nbBons' class='number first' type='text' placeholder='X' /> bons</td>");
					out.println("<td><input name='prixBons' class='number' type='text' class='second' placeholder='€' /></td></tr>");
					out.println("<tr class='form'><td colspan='3'><span class='achatInfo'>" + res.getString("info") + "</span><input type='submit' name='valider' value='" + res.getString("acheter") + "' class='achat' /><input type='submit' name='valider' value='" + res.getString("vendre") + "' class='achat' /></td></tr></tfoot>");
				}
%>
	<tbody>
<%
				String achat = m.proposition(choix, 0);
				if(achat.equals("0"))
					out.println("<tr class='empty info'><td colspan='3'>" + res.getString("pasAch") + "</td></tr>");
				else
					out.println(achat);
%>
	</tbody>
</table>
</form>

<%
				if(request.getParameter("success")!=null)
					out.println("<span id='success'>" + res.getString("succes") + "</span>");
				if(request.getParameter("error")!=null) {
					try {
						out.println("<span id='error'>" + res.getString("erreur"+request.getParameter("error")) + "</span>");
					} catch( Exception e ) { /* Ignored */ }
				}
				
				if(m.nbProp(choix) > 0) {
%>
<h3><%= res.getString("etatMarche") %></h3>
<div id="graphique" style="width: auto; height: 250px;"></div>
<%
				}
%>

</div>

<%
				if(request.getUserPrincipal()!=null) {

%>
<div class='infoRight right'>
	<h2 class='withSmall'><%= util.prenom() + " " + util.nom() %></h2>
	<span class='small'><%= res.getString("argent") %> : <%= util.argentDispo() %>€</span>
	<h4><%= res.getString("invest") %></h4>
	<table class='invest'>
		<tr class='th'>
			<th><%= res.getString("nombre") %></th>
			<th><%= res.getString("prix") %></th>
<%
				if( fin.after(new java.util.Date()) )
					out.println("<th>" + res.getString("suppr") + "</th>");
%>
		</tr>
<%
						String bons = util.getBons(id, choix, fin.after(new java.util.Date()));
						if(bons.equals("0"))
							out.println("<tr class='empty info'><td colspan='3'>" + res.getString("invest0") + "</td></tr>");
						else
							out.println(bons);
%>
	</table>
	<h4 class='second'><%= res.getString("investA") %></h4>
	<table class='invest'>
		<tr class='th'>
			<th><%= res.getString("nombre") %></th>
			<th><%= res.getString("prix") %></th>
		</tr>
<%
						String titres = util.getTitres(id, choix);
						if(titres.equals("0"))
							out.println("<tr class='empty info'><td colspan='3'>" + res.getString("invest0") + "</td></tr>");
						else
							out.println(titres);
%>
	</table>
</div>
<%
			}
		}
	}
}
%>
<link rel='stylesheet' href='CSS/morris-0.4.3.min.css' />
<script src='JS/jquery-1.9.1.js'></script>
<script src='JS/jquery-ui.js'></script>
<script src="JS/raphael-min.js"></script>
<script src="JS/morris-0.4.3.min.js"></script>
<script src='JS/information.js'></script>
<jsp:include page="footer.jsp" />