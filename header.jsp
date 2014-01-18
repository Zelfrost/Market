<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<!DOCTYPE HTML>
<html>
	<head>
		<%@ page contentType="text/html;charset=UTF-8" %>
		<meta charset="UTF-8" />
		<link rel="stylesheet" href="CSS/resetCSS.css" />
		<link rel="stylesheet" href="CSS/jquery-ui.css" />
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
	                <a href='index'><img src="Images/titre.png" alt="IM - Marché de l'Information" /></a>
	            </div>
	            <div class="right">
	                <img src="Images/user-group.gif" alt="icone" />
	                <%
	                	if( ! (request.isUserInRole("Admin") || request.isUserInRole("MarketMaker") || request.isUserInRole("User") ) )
	                		out.println("Non connecté. (<a href='Conn?url=" + URLEncoder.encode((request.getRequestURL().append('?').append(request.getQueryString())).toString()) + "'>Connexion</a>)");
	            		else {
            				Context initCtx = 	new InitialContext();
				            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
				            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
				            Connection con 	= 	ds.getConnection();

				        	Statement st 	= 	con.createStatement();
				       		ResultSet rs 	= 	st.executeQuery("SELECT (prenom || ' ' || nom) AS n FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
				       		
				       		rs.next();
	            			out.print("Connecté sous le nom « <a href='compte'>" + rs.getString("n") + "</a> » (<a href='Conn?deco=1'>Déconnexion</a>)");
							con.close();
	            		}
	            	%>
	            </div>
	        </div>
	
	        <div id="body">
	            <div class="int">
