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
            	ResultSet rs 	= st.executeQuery("SELECT idUser, argent FROM users WHERE login='" + req.getUserPrincipal().getName() + "'");
            	rs.next();
        } catch( Exception e ) {}
	}
}