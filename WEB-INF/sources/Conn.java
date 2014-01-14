import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/Conn")
public class Conn extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		if( req.getParameter("deco")!=null )
			req.getSession().invalidate();/*
	    else if( req.getUserPrincipal().getName()!=null ) {
	        HttpSession session = req.getSession(true);
	        
	        Connection con 		= null;
	        try {
	            Context initCtx = 	new InitialContext();
	            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	            con 			= 	ds.getConnection();

	        	Statement st 	= 	con.createStatement();
	       		ResultSet rs 	= 	st.executeQuery("SELECT (nom || ' ' || prenom) AS n FROM users WHERE login='" + req.getUserPrincipal().getName() + "';");

	       		rs.next();
            	session.setAttribute("nom", rs.getString("n"));
	        } catch( Exception e ) {
	         	e.printStackTrace(res.getWriter());
	        }
        }*/
        
		if(req.getParameter("url")!=null)
		    res.sendRedirect(req.getParameter("url"));
		else
		    res.sendRedirect("index");
	}
}
