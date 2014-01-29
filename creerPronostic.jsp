<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Création" />

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.creerPronostic", loc);
%>


<script src="JS/jquery-1.9.1.js"></script>
<script src="JS/jquery-ui.js"></script>
<script>
	function sub(){
		$( "#datepicker").val(
			$.datepicker.formatDate(
				"dd/mm/yy", 
				new Date($( "#datepicker" ).val())
			)
		);
	}

	$(function() {
		$( "#datepicker" ).datepicker();
	});
</script>

<a id="prev" href='marches'><%= (String)res.getObject("lienRetour") %></a>

<h3><%= (String)res.getObject("titre") %></h3>

<form accept-charset="ISO-8859-1" id="pronostic" method="POST" action="AjoutPronostic">

<%
	if(request.getParameter("succes")!=null)
		out.println("<span id='success'>" + (String)res.getObject("succes") + "</span>");
%>

<div>
	<label for="libelle"><%= (String)res.getObject("libelle") %> :</label>
	<textarea name="libelle"></textarea>
</div>

<div>
	<label for="libelleInverse"><%= (String)res.getObject("libelleInverse") %> :</label>
	<textarea name="libelleInverse"></textarea>
</div>

<div>
	<label for="dateFin"><%= (String)res.getObject("date") %> :</label>
	<input type="text" id="datepicker" name="dateFin" onchange="sub();" />
</div>

<input type="submit" value="<%= (String)res.getObject("valider") %>" />

</form>


<jsp:include page="footer.jsp" />