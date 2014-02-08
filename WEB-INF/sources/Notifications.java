import tools.Personne;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import java.sql.*;
import javax.sql.*;

import javax.naming.*;

@WebServlet("/Notifications")
public class Notifications extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		Connection con = null;
		Personne util = (Personne)req.getSession().getAttribute("Personne");
		if(util != null) {
		    try {
				Context initCtx = 	new InitialContext();
	            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	            con 			= 	ds.getConnection();

	            Statement st 	=	con.createStatement();
	            ResultSet rs 	=	st.executeQuery("SELECT MIN(idNotif) AS id, libelle FROM notifications LEFT JOIN users ON users.idUser = notifications.userID WHERE userID=" + util.id() + " AND idNotif > dernNotif GROUP BY idNotif, libelle;");
				
	            if(rs.next()) {
					res.getWriter().println("<p>" + rs.getString("libelle") + "</p>");
					st.executeUpdate("UPDATE users SET dernNotif=" + rs.getString("id") + " WHERE idUser=" + util.id() + ";");
	            }

	            con.close();

	        } catch( Exception e ) {
	        	try { con.close(); } catch( Exception ex ) { /* Ignored */ }
	        }
	    }
    }
}