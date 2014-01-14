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
	    if( request.getUserPrincipal().getName()!=null ) {
	        HttpSession session = request.getSession(true);
	        
            Context initCtx = 	new InitialContext();
            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
            Connection con 	= 	ds.getConnection();

	        Statement st 	= 	con.createStatement();
	        ResultSet rs 	= 	st.executeQuery("SELECT CONCAT(nom, prenom) AS nom FROM users WHERE login='" + request.getUserPrincipal().getName() + "';");
	        
            session.setAttribute("nom", nom);
        }
        
		if(req.getParameter("url")!=null)
		    res.sendRedirect(req.getParameter("url"));
		else
		    res.sendRedirect("index");
	}
}
