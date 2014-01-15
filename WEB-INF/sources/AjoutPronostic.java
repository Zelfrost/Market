import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

@WebServlet("/AjoutPronostic")
public class AjoutPronostic extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		if (req.getParameter("libelle")!=null
			&& req.getParameter("libelleInverse")!=null
			&& req.getParameter("dateFin")!=null ) {


			PreparedStatement pst = null;

		    String insert = "INSERT INTO markets SELECT MAX(idMarket)+1, ?, ?, TO_DATE(?, 'DD/MM/YYYY'), date('now') FROM markets;";

		    try {
				Context initCtx = 	new InitialContext();
	            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	            Connection con 	= 	ds.getConnection();

		        pst = con.prepareStatement(insert);

		        pst.setString(1, req.getParameter("libelle"));
		        pst.setString(2, req.getParameter("libelleInverse"));
		        pst.setString(3, req.getParameter("dateFin"));

      			pst.executeUpdate();

      			con.close();
      			res.sendRedirect("creerPronostic?succes=1");
		    } catch (Exception e ) {
		    	e.printStackTrace(res.getWriter());
		    }
		}
	}
}