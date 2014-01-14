<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
	<head>
		<link rel="stylesheet" href="CSS/resetCSS.css" />
		<link rel="stylesheet" href="CSS/index.css" />
<%
	String titre 	= "Votre marché de l'Information";
	if(request.getParameter("titre")!=null)
		titre 		= request.getParameter("titre");
	titre 		   +=  " - Lille 1";
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
	                <img src="Images/user-group.gif" alt="icone" />
	                <%
	                	if( ! (request.isUserInRole("Admin") || request.isUserInRole("MarketMaker") || request.isUserInRole("User") ) )
	                		out.println("Non connecté. (<a href='Conn?url=" + URLEncoder.encode((request.getRequestURL().append('?').append(request.getQueryString())).toString()) + "'>Connexion</a>)");
	            		else {
	            			out.println("Connecté sous le nom \" " + request.getUserPrincipal().getName() + " \"");
	            		}
	            	%>
	            </div>
	        </div>
	
	        <div id="body">
	            <div class="int">
