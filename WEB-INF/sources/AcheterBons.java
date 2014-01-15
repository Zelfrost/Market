import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

@WebServlet("/AcheterBons")
public class AcheterBons extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{

		if (req.getParameter("nbBons") != null && req.getParameter("prixBons") != null && req.getParameter("login"))
		{
			
			PreparedStatement pst = null;

		   	String insert = "UPDATE users SET argent = argent - " + req.getParameter("nbBons") + " * " + req.getParameter("prixBons") + " WHERE login=" + req.getParameter("login")	
			try {
				Context initCtx = new InitialContext();
		          	Context envCtx 	= (Context) initCtx.lookup("java:comp/env");
		            	DataSource ds 	= (DataSource) envCtx.lookup("base");
		            	Connection con 	= ds.getConnection();

			        pst = con.prepareStatement(insert);

			        pst.setString(1, req.getParameter("libelle"));
			        pst.setString(2, req.getParameter("libelleInverse"));
			        pst.setString(3, req.getParameter("dateFin"));

      				pst.executeUpdate();

      				con.close();
		    	} catch (Exception e ) {}			
		}
	}
}	
