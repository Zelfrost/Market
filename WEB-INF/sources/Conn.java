import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/Conn")
public class Conn extends HttpServlet
{
	public void service( HttpServletRequest req, HttpServletResponse res )
		throws ServletException, IOException
	{
		if( req.getParameter("deco")!=null )
			req.getSession().invalidate();
        
		if(req.getParameter("url")!=null)
		    res.sendRedirect(req.getParameter("url"));
		else
		    res.sendRedirect("index");
	}
}
