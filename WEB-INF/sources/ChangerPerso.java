import tools.Personne;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import org.apache.commons.lang.StringEscapeUtils;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

@WebServlet("/ChangerPerso")
public class ChangerPerso extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
	    throws ServletException, IOException
    {

	    Personne util = (Personne)req.getSession().getAttribute("Personne");
	    	
		String ancienPass 	= req.getParameter("ancienPass");
		String nouveauPass 	= req.getParameter("nouveauPass");
		String repetePass 	= req.getParameter("repetePass");

		String mail			= req.getParameter("mail");

		int nbValid			= 0;

	    if(ancienPass!=null && !ancienPass.equals("") && !nouveauPass.equals("")) {
			if(ancienPass.equals(util.pass())) {
			    if(nouveauPass.equals(repetePass)) {
					util.setPass(nouveauPass);
					nbValid ++;
			    } else {
					res.sendRedirect("perso?error=2");
					return;
			    }
			} else {
				res.sendRedirect("perso?error=1");
				return;
			}
	    }

	    if( mail!=null && !mail.equals("") && !mail.equals(util.mail()) ) {
			Pattern p = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$");
			Matcher m = p.matcher(mail.toUpperCase());
			if(m.matches()) {
			    util.setMail(StringEscapeUtils.escapeHtml(mail));
				res.sendRedirect("perso?success=1");
				return;
			} else {
				res.sendRedirect("perso?error=3");
				return;
			}
	    }

	    res.sendRedirect("perso" + ((nbValid != 0)?"?success=1":""));
	}
}