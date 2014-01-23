import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

@WebServlet("/Result")
public class Result extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		try {

			if(	req.getParameter("id")==null || req.getParameter("id").equals("") || 
				req.getParameter("result")==null )
				res.sendRedirect("resultat");

			String id 		= 	req.getParameter("id");
			
		    Context initCtx = 	new InitialContext();
		    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
		    DataSource ds 	= 	(DataSource) envCtx.lookup("base");
		    Connection con 	= 	ds.getConnection();

			Statement st 	= 	con.createStatement();
			Statement upST 	= 	con.createStatement();
			ResultSet rs 	= 	st.executeQuery("SELECT to_char(dateFin, 'DD/MM/YYYY') AS d, login FROM markets JOIN users ON users.idUser=markets.userID WHERE idMarket=" + id + ";");
			rs.next();

			String[] date 	=	rs.getString("d").split("/");
			java.util.Date fin 	= 	new java.util.Date(	Integer.parseInt(date[2])-1900,
														Integer.parseInt(date[1])-1,
														Integer.parseInt(date[0])
								);
			if( (! rs.getString("login").equals(req.getUserPrincipal().getName())) || fin.compareTo(new java.util.Date()) > 0)
				res.sendRedirect("Result?id" + id);

			int rest 	= 	req.getParameter("result").equals("oui")?0:1;
			st.executeUpdate("UPDATE markets SET resultat=" + rest + " WHERE idMarket=" + id + ";");

			rs 			= 	st.executeQuery("SELECT userID, SUM(nombreRestant * prix) AS argent FROM transactions WHERE marketID=" + id + " AND nombreRestant<>0 GROUP BY userID");
			while(rs.next())
				upST.executeUpdate("UPDATE users SET argentBloque = argentBloque - " + rs.getString("argent") + " WHERE idUser = " + rs.getString("userID") + ";");

			rs 			= 	st.executeQuery("SELECT userID, mail, (100 * (nombre - nombreRestant)) AS somme FROM transactions JOIN users ON transactions.userID=users.idUser WHERE marketID=" + id + " AND choix=" + rest + " AND nombreRestant<>nombre;");
			while(rs.next()) {
				upST.executeUpdate("UPDATE users SET argent = argent + " + rs.getString("somme") + " WHERE idUser=" + rs.getString("userID") + ";");

				// TODO : mail
				// mail : rs.getString("mail");

			}
			res.sendRedirect("information?id=" + id + "&success=1");

			con.close();
		} catch(Exception e) {
			e.printStackTrace(res.getWriter());
		}
	}
}