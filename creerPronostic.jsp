<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp?titre=Création" />

<%
    Locale loc          = (Locale) session.getAttribute("loc");
    ResourceBundle res  = ResourceBundle.getBundle("prop.creerPronostic", loc);
%>


<a id="prev" href='marches'><%= res.getString("lienRetour") %></a>

<h3><%= res.getString("titre") %></h3>

<form accept-charset="ISO-8859-1" onsubmit="validH();" id="pronostic" method="POST" action="AjoutPronostic">

<%
	if(request.getParameter("succes")!=null)
		out.println("<span id='success'>" + res.getString("succes") + "</span>");
%>

<div>
	<label for="libelle"><%= res.getString("libelle") %> :</label>
	<textarea name="libelle"></textarea>
</div>

<div>
	<label for="libelleInverse"><%= res.getString("libelleInverse") %> :</label>
	<textarea name="libelleInverse"></textarea>
</div>

<div>
	<label for="dateFin"><%= res.getString("date") %> :</label>
	<input type="text" id="timepicker" name="heurefin" onchange="subH();" />
	<input type="text" id="datepicker" name="dateFin" onchange="subD();" />
</div>

<input type="submit" value="<%= res.getString("valider") %>" />

</form>


<jsp:include page="footer.jsp" />


<link rel='stylesheet' href='CSS/jquery.ptTimeSelect.css' />
<script src="JS/jquery-1.9.1.js"></script>
<script src="JS/jquery-ui.js"></script>
<script src="JS/jquery.ptTimeSelect.js"></script>
<script>
	function validH() {
		$("#timepicker").val( $("#timepicker").val() + ":00" );
	}

	function subD() {
		$( "#datepicker").val(
			$.datepicker.formatDate(
				"yy-mm-dd", 
				new Date($( "#datepicker" ).val())
			)
		);
	}

	$(document).ready( function() {
		$( "#timepicker" ).ptTimeSelect({
			hoursLabel: "heures",
			minutesLabel: "minutes",
			setButtonLabel: "Valider",
			onClose: function(i) {
				var t = $("#timepicker").val();

				if(t.indexOf(" ")==4)
					t = "0" + t;

				if(t.indexOf("PM") != -1)
					t = parseInt(t.split(":")[0])+12 + ":" + t.split(":")[1];

				t = t.substring(0, 5);

				$("#timepicker").val(t);
			}
		});
		$( "#datepicker" ).datepicker();
	});
</script>