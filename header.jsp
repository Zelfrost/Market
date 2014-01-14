<%@ page contentType="text/html;charset=UTF-8" %>
<html>
	<head>
		<link rel="stylesheet" href="CSS/resetCSS.css" />
		<link rel="stylesheet" href="CSS/index.css" />
<%
	String titre = "Votre marché de l'Information";
	if(request.getParameter("titre")!=null)
		titre = request.getParameter("titre");
	titre +=  " - Lille 1";
%>
		<title>IM - <%= titre %></title>
	</head>
	
	<body>
	    <div id="wrapper">
	        <div id="header">
	            <div class="left">
	                <img src="Images/titre.png" alt="IM - Marché de l'Information" />
	            </div>
	            <div class="right">
	                Non connecté. (<a href="">Connexion</a>)
	            </div>
	        </div>
	
	        <div id="body">
	            <div class="int">
