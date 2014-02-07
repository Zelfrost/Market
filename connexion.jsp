<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Connexion" />

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.connexion", loc);
%>


<form id="conn" method="POST" action="j_security_check">
	<h3>Connexion :</h3>
	<%
		if(request.getParameter("error")!=null)
			out.println("<span id='error'>" + res.getString("erreur") + "</span>");
		if(request.getParameter("success")!=null)
			out.println("<span id='success'>" + res.getString("succes") + "</span>");
	%>

	<div class="label">
		<span><%= res.getString("login") %> :</span><span><input type="text" id="j_username" name="j_username" placeholder="-" /></span>
	</div>

	<div class="label">
		<span><%= res.getString("pass") %> :</span><span><input type="password" 	id="j_password" name="j_password" placeholder="-" /></span>
	</div>

	<input type="submit" value="<%= res.getString("conf") %>" />

	<div class='last'>
		<a href='inscription' id='insc'><%= res.getString("insc") %> ?</a>
	</div>
	<div class='last'>
		<a href='retrouver' id='insc'><%= res.getString("retrouv") %></a>
	</div>
</form>

<jsp:include page="footer.jsp" />
