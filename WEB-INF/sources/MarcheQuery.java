import tools.Marche;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;



@WebServlet("/MarcheQuery")
public class MarcheQuery extends HttpServlet
{



	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		int id 		= Integer.parseInt(req.getParameter("id"));
		int choix 	= Integer.parseInt(req.getParameter("choix"));
		int prix 	= Integer.parseInt(req.getParameter("prix"));

		String r 	= Marche.proposition(id, choix, prix);
		if(r.charAt(r.length()-1) == '0') {
			r 		= r.substring(0, r.length()-1);
			r 		+= "<tr class='empty info'><td colspan='3'>Pas " + ((prix==1)?"de vendeurs":"d'acheteurs") + "</td></tr>";
		}

		res.getWriter().println(r);
	}

}