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


			PreparedStatement pstA = null;
			PreparedStatement pstB = null;

		    String insertA 		= "INSERT INTO markets(libelle, dateFin, publication, resultat, etat, userID, idInverse) VALUES(?, ?::TIMESTAMP, CURRENT_TIMESTAMP, 2, 0, ?, 0);";
		    String insertB 		= "INSERT INTO markets(libelle, dateFin, publication, resultat, etat, userID, idInverse) VALUES(?, ?::TIMESTAMP, CURRENT_TIMESTAMP, 2, 1, ?, ?);";

		    int 	id = 0,
		    		idInverse = 0;

		    try {
				Context initCtx = 	new InitialContext();
	            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	            Connection con 	= 	ds.getConnection();
	            Statement st 	= 	con.createStatement();
	            ResultSet rs;

	            Personne util 	= 	(Personne)req.getSession().getAttribute("Personne");

		        pstA = con.prepareStatement(insertA, Statement.RETURN_GENERATED_KEYS);
		        pstB = con.prepareStatement(insertB, Statement.RETURN_GENERATED_KEYS);


		        String fin = StringEscapeUtils.escapeHtml(req.getParameter("dateFin")) + " " + StringEscapeUtils.escapeHtml(req.getParameter("heurefin"));

		        pstA.setString(1, StringEscapeUtils.escapeHtml(req.getParameter("libelle")));
		        pstA.setString(2, fin);
		        pstA.setInt(3, util.id());

      			pstA.executeUpdate();

      			rs = pstA.getGeneratedKeys();
      			if(rs.next())
      				id = rs.getInt(1);

      			pstB.setString(1, StringEscapeUtils.escapeHtml(req.getParameter("libelleInverse")));
      			pstB.setString(2, fin);
      			pstB.setInt(3, util.id());
      			pstB.setInt(4, id);

      			pstB.executeUpdate();

      			rs = pstB.getGeneratedKeys();
      			if(rs.next())
      				idInverse = rs.getInt(1);

      			st = con.createStatement();
      			st.executeUpdate("UPDATE markets SET idInverse=" + idInverse + " WHERE idMarket=" + id + ";");

      			con.close();
      			res.sendRedirect("creerPronostic?succes=1");
		    } catch (Exception e ) {
		    	e.printStackTrace(res.getWriter());
		    }
		}
	}
}