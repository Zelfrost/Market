import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

@WebServlet("/persoInfo")
public class persoInfo extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		try {
				Context initCtx = new InitialContext();
	          	Context envCtx 	= (Context) initCtx.lookup("java:comp/env");
            	DataSource ds 	= (DataSource) envCtx.lookup("base");
            	Connection con 	= ds.getConnection();

            	Statement st 	= con.createStatement();
            	ResultSet rs 	= st.executeQuery("SELECT idUser FROM users WHERE login='" + req.getUserPrincipal().getName() + "';");
            	rs.next();
            	String id 		= rs.getString("idUser");

            	rs 				= st.executeQuery("SELECT SUM(nombre - nombreRestant) AS nombre, SUM((nombre - nombreRestant) * prix) AS prix FROM transactions WHERE userID=" + id + " AND marketID=" + req.getParameter("id") + " AND choix=" + req.getParameter("choix") + " AND nombre<>nombreRestant;");
            	rs.next();
            	res.getWriter().print("nombre:" + rs.getString("nombre") + ";prix:" + rs.getString("prix") + "|");

            	rs 	= st.executeQuery("SELECT SUM(nombreRestant) AS nombre, SUM(nombreRestant * prix) AS prix FROM transactions WHERE userID=" + id + " AND marketID=" + req.getParameter("id") + " AND choix=" + req.getParameter("choix") + ";");
            	rs.next();
            	res.getWriter().print("nombre:" + rs.getString("nombre") + ";prix:" + rs.getString("prix"));

            	con.close();
        } catch( Exception e ) { e.printStackTrace(res.getWriter()); } 
	}
}