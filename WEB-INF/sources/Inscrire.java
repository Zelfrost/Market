import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
import org.apache.commons.lang.StringEscapeUtils;

@WebServlet("/Inscrire")
public class Inscrire extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		if (req.getParameter("login")==null
				&& req.getParameter("pass")==null
				&& req.getParameter("passConf")==null
				&& req.getParameter("mail")==null 
				&& req.getParameter("nom")==null 
				&& req.getParameter("prenom")==null  )
			res.sendRedirect("inscription?error=1");
	    else if( !req.getParameter("pass").equals( req.getParameter("passConf") ) )
	        res.sendRedirect("inscription?error=2");
		else {
			PreparedStatement pst = null;

		    String insert 		= "INSERT INTO users SELECT MAX(idUser)+1, ?, ?, ?, ?, ?, 10000, 0, 'User' FROM users;";

		    try {
				Context initCtx = 	new InitialContext();
	            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	            Connection con 	= 	ds.getConnection();

	            Statement st 	=	con.createStatement();
	            ResultSet rs 	=	st.executeQuery("SELECT idUser FROM users WHERE login ='" + req.getParameter("login") + "';");
	            if(rs.next())
	            	res.sendRedirect("inscription?error=3");

		        pst = con.prepareStatement(insert);

		        pst.setString(1, StringEscapeUtils.escapeHtml(req.getParameter("nom")));
		        pst.setString(2, StringEscapeUtils.escapeHtml(req.getParameter("prenom")));
		        pst.setString(3, StringEscapeUtils.escapeHtml(req.getParameter("login")));
		        pst.setString(4, StringEscapeUtils.escapeHtml(req.getParameter("pass")));
		        pst.setString(5, StringEscapeUtils.escapeHtml(req.getParameter("mail")));

      			pst.executeUpdate();

      			con.close();
      			res.sendRedirect("Conn");
		    } catch (Exception e ) {
		    	e.printStackTrace(res.getWriter());
		    }
		}
	}
}