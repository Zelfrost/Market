import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
import org.apache.commons.lang.StringEscapeUtils;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

@WebServlet("/ChangerPerso")
public class ChangerPerso extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
	    throws ServletException, IOException
    {
	String ancienPass 	= req.getParameter("ancienPass");
	String nouveauPass 	= req.getParameter("nouveauPass");
	String repetePass 	= req.getParameter("repetePass");

	String mail			= req.getParameter("mail");

	try {
	    Context initCtx = new InitialContext();
	    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
	    DataSource ds   = (DataSource) envCtx.lookup("base");
	    Connection con  = ds.getConnection();

	    Statement st    = con.createStatement();
	    ResultSet rs 	= st.executeQuery("SELECT pass, mail FROM users WHERE login='" + req.getUserPrincipal().getName() + "';");
	    rs.next();

	    String redirect	= "perso",
				update 	= "UPDATE users SET ",
				arg1	= null,
				arg2	= null;
		int nbArg		= 0;

	    if(ancienPass!=null && !ancienPass.equals("") && !nouveauPass.equals("")) {
		if(ancienPass.equals(rs.getString("pass"))) {
		    if(nouveauPass.equals(repetePass)) {
				update   += "pass=?";
				arg1 	 = StringEscapeUtils.escapeHtml(nouveauPass);
				nbArg++;
				redirect = "perso?success=1";
		    } else
			redirect = "changePerso?error=2";
		} else
		    redirect = "changePerso?error=1";
	    }

	    if( mail!=null && !mail.equals("") && !mail.equals(rs.getString("mail")) ) {
		Pattern p = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$");
		Matcher m = p.matcher(mail.toUpperCase());
		if(m.matches()) {
		    if(update.charAt(update.length()-1) == '\'') {
				update += ", mail=?";
				arg2 	= StringEscapeUtils.escapeHtml(mail);
			} else {
		    	update += " mail=?";
				arg1 	= StringEscapeUtils.escapeHtml(mail);
		    }
		    nbArg++;
		    redirect = "perso?success=1";
		} else
		    redirect = "changePerso?error=3";
	    }

	    update += " WHERE login='" + req.getUserPrincipal().getName() + "';";

    	PreparedStatement pst = con.prepareStatement(update);
	    if(nbArg>0) {
	    	pst.setString(1, arg1);
	    	if(nbArg==2)
	    		pst.setString(2, arg2);

			pst.executeUpdate();
		}
	    res.sendRedirect(redirect);
	} catch (Exception e) {
	    e.printStackTrace(res.getWriter());
	}
    }
}