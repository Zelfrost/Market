import tools.Personne;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
import org.apache.commons.lang.StringEscapeUtils;

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

		    String insert 		= "INSERT INTO markets SELECT MAX(idMarket)+1, ?, ?, ?::TIMESTAMP, CURRENT_TIMESTAMP, ?::INTEGER, 2 FROM markets;";

		    try {
				Context initCtx = 	new InitialContext();
	            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	            Connection con 	= 	ds.getConnection();

	            Statement st 	=	con.createStatement();

	            Personne util 	= 	(Personne)req.getSession().getAttribute("Personne");

		        pst = con.prepareStatement(insert);

		        String fin = StringEscapeUtils.escapeHtml(req.getParameter("dateFin")) + " " + StringEscapeUtils.escapeHtml(req.getParameter("heurefin"));

		        pst.setString(1, StringEscapeUtils.escapeHtml(req.getParameter("libelle")));
		        pst.setString(2, StringEscapeUtils.escapeHtml(req.getParameter("libelleInverse")));
		        pst.setString(3, fin);
		        pst.setString(4, util.id() + "");

      			pst.executeUpdate();

      			con.close();
      			res.sendRedirect("creerPronostic?succes=1");
		    } catch (Exception e ) {
		    	e.printStackTrace(res.getWriter());
		    }
		}
	}
}