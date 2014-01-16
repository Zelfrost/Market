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

		if (req.getParameter("nbBons") != null && req.getParameter("prixBons") != null)
		{
			String login 			= req.getUserPrincipal().getName();

			try {
					Context initCtx = new InitialContext();
		          	Context envCtx 	= (Context) initCtx.lookup("java:comp/env");
	            	DataSource ds 	= (DataSource) envCtx.lookup("base");
	            	Connection con 	= ds.getConnection();

	            	Statement st 	= con.createStatement();
	            	ResultSet rs 	= st.executeQuery("SELECT idUser, argent FROM users WHERE login='" + req.getUserPrincipal().getName() + "'");
	            	rs.next();

	            	String idUser	= rs.getString("idUser");
	            	int somme		= Integer.parseInt(req.getParameter("nbBons")) * Integer.parseInt(req.getParameter("prixBons"));

	            	if(rs.getInt("argent") >= somme) {
		            	String argent	= "UPDATE users SET argent = argent - " + somme + " WHERE login='" + login + "';";
		            	String trans	= "INSERT INTO transactions SELECT MAX(idtrans)+1, " + req.getParameter("id") + ", " + idUser + ", " + req.getParameter("nbBons") + ", " + req.getParameter("nbBons") + ", " + req.getParameter("prixBons") + ", " + req.getParameter("choix") + ", CURRENT_TIMESTAMP FROM transactions;";
				        
		            	st.executeUpdate(argent);
		            	st.executeUpdate(trans);

      					con.close();
	      				res.sendRedirect("information?id=" + req.getParameter("id") + "&choix=" + req.getParameter("choix") + "&success=1");
	      			} else {
      					con.close();
	      				res.sendRedirect("information?id=" + req.getParameter("id") + "&choix=" + req.getParameter("choix") + "&error=1");
	      			}
		    	} catch (Exception e ) {
		    		e.printStackTrace(res.getWriter());
		    	}			
		}
	}
}	
