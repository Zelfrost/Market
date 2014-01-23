import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

@WebServlet("/suppTrans")
public class suppTrans extends HttpServlet
{
    public void service( HttpServletRequest req, HttpServletResponse res )
	throws ServletException, IOException
    {
    	if(req.getParameter("idTrans")==null || req.getParameter("idTrans").equals(""))
    		res.sendRedirect("marches");
    	else {
    		PreparedStatement pst = null;

		    String delete 		= "UPDATE transactions SET nombre = nombre - nombreRestant, nombreRestant = 0 WHERE idTrans=?;";

		    try {
				Context initCtx = 	new InitialContext();
	            Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
	            DataSource ds 	= 	(DataSource) envCtx.lookup("base");
	            Connection con 	= 	ds.getConnection();
	            Statement st 	= 	con.createStatement();

		        pst = con.prepareStatement(delete);
		        pst.setInt(1, Integer.parseInt(req.getParameter("idTrans")));

            st.executeUpdate("UPDATE users SET argentBloque = argentBloque - ( SELECT (nombreRestant * prix) FROM transactions WHERE idTrans=" + req.getParameter("idTrans") + " ) WHERE login = '" + req.getUserPrincipal().getName() + "';");

            pst.executeUpdate();
            st.executeUpdate("DELETE FROM transactions WHERE nombre=0 AND idTrans <> 0;");

      			con.close();

      			res.sendRedirect("information?id=" + req.getParameter("id"));
      		} catch (Exception e) {
      			e.printStackTrace(res.getWriter());
      		}
    	}
    }
}