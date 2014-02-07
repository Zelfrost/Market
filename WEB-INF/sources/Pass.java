import tools.Personne;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import org.apache.commons.lang.StringEscapeUtils;

@WebServlet("/Pass")
public class Pass extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		if(req.getParameter("mail") != null && !req.getParameter("mail").equals("")) {
			res.getWriter().println(StringEscapeUtils.escapeHtml(req.getParameter("mail")));
			Personne p =  new Personne(StringEscapeUtils.escapeHtml(req.getParameter("mail")), 0);
			if(p.nom() != null)
				p.sendNouvPass();
			else
				res.getWriter().println("Not Found");
			res.sendRedirect("Conn");
		} else
			res.sendRedirect("index");
	}
}