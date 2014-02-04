<%@ page import="tools.Personne" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.MissingResourceException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>

<%
	Personne util = null;
	if(request.getUserPrincipal()!=null && session.getAttribute("Personne")==null) {
		util 	= new Personne(request.getUserPrincipal().getName());
		session.setAttribute("Personne", util);
	}
	if(util == null)
		util = (Personne)session.getAttribute("Personne");

	Locale loc 	= (Locale) session.getAttribute("loc");
	if(request.getParameter("loc")!=null) {
		if(request.getParameter("loc").equals("fr"))
			session.setAttribute("loc", new Locale("fr", ""));
		else
			session.setAttribute("loc", new Locale("en", ""));
	} else if(loc == null) {
		if(! Locale.getDefault().getLanguage().equals("fr")
					&& ! Locale.getDefault().getLanguage().equals("en"))
			loc 	= new Locale("fr", "");
		else
			loc 	= new Locale(Locale.getDefault().getLanguage(), "");
		session.setAttribute("loc", loc);
	}
	loc 				= (Locale) session.getAttribute("loc");
	int fr 				= loc.getLanguage().equals("fr")?0:1;
	ResourceBundle res 	= ResourceBundle.getBundle("prop.header", loc);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<%@ page contentType="text/html;charset=UTF-8" %>
		<meta charset="UTF-8" />
		<link rel="stylesheet" href="CSS/resetCSS.css" />
		<link rel="stylesheet" href="CSS/jquery-ui.css" />
		<link rel="stylesheet" href="CSS/index.css" />
<%
	String titre 	= res.getString("titre");
	if(request.getParameter("titre")!=null)
		titre 		= request.getParameter("titre");
	titre 		   +=  " - Lille 1 - " + session.getAttribute("loc");
%>
		<title><%= titre %></title>
	</head>
	
	<body>
	    <div id="wrapper">
	        <div id="header">
	            <div class="left">
	                <a href='index'><img src="Images/titre.png" alt="<%= res.getString("titre") %>" /></a>
	            </div>
	            <div class="right">
	            	<form method="POST" action="index" id="loc">
		            	<select name="loc" onchange="document.getElementById('loc').submit();">
		            		<option value="en">English (en)</option>
		            		<option value="fr" <%= ((fr==0)?"selected": "") %>>Français (fr)</option>
		            	</select>
		            </form>

	            	<div id="persoTop">
		                <img src="Images/user-group.gif" alt="icone" />
		                <%
		                	if( request.getUserPrincipal() == null )
		                		out.println(res.getString("deconnecte") + " (<a href='Conn?url=" + URLEncoder.encode((request.getRequestURL().append('?').append(request.getQueryString())).toString()) + "'>" + res.getString("deconnecte_link") + "</a>)");
		            		else {
		            			out.print(res.getString("connecte") + " « <a style='text-decoration: underline;' href='perso'>" + util.prenom() + " " + util.nom() + "</a> » (<a href='Conn?deco=1'>" + res.getString("connecte_link") +"</a>)");
		            		}
		            	%>
		            </div>
	            </div>
	        </div>
	
	        <div id="body">
	            <div class="int">
