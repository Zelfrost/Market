import tools.*;

import java.util.*;
import java.io.*;

import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import javax.sql.*;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

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

			int id 		= 	Integer.parseInt(req.getParameter("id"));
			Marche m  		= 	new Marche(id);
			Personne util	= 	(Personne)req.getSession().getAttribute("Personne");

			
		    Context initCtx = 	new InitialContext();
		    Context envCtx 	= 	(Context) initCtx.lookup("java:comp/env");
		    javax.sql.DataSource ds 	= 	(javax.sql.DataSource) envCtx.lookup("base");
		    Connection con 	= 	ds.getConnection();

			Statement st 	= 	con.createStatement();
			Statement upST 	= 	con.createStatement();
			ResultSet rs;

			String[] heure 	= m.dateFin().substring(0, 5).split(":");
			String[] date 	= m.dateFin().substring(6,14).split("/");
			java.util.Date fin 	= new java.util.Date( m.dateFinEpoch() * 1000 );
			
			if( m.createur() != util.id() || fin.after(new java.util.Date()) )
				res.sendRedirect("marches");
			else {
				int rest 	= 	req.getParameter("result").equals("oui")?m.id():m.idInverse();
				String lib 	= 	m.libelle();

				st.executeUpdate("UPDATE markets SET resultat=" + rest + " WHERE idMarket=" + id + " OR idMarket=" + m.idInverse() + ";");

				rs = st.executeQuery("SELECT userID, SUM(nombreRestant * prix) AS argent FROM transactions WHERE ( marketID=" + id + " OR marketID=" + m.idInverse() + " ) AND nombreRestant<>0 GROUP BY userID");
				while(rs.next())
					upST.executeUpdate("UPDATE users SET argentBloque = argentBloque - " + rs.getString("argent") + " WHERE idUser = " + rs.getString("userID") + ";");

				rs = st.executeQuery("SELECT userID, mail, (100 * (nombre - nombreRestant)) AS somme FROM transactions JOIN users ON transactions.userID=users.idUser WHERE marketID=" + rest + " AND nombreRestant<>nombre;");
				while(rs.next()) {
					upST.executeUpdate("UPDATE users SET argent = argent + " + rs.getString("somme") + " AND nbVictoire = nbVictoire + 1 WHERE idUser=" + rs.getString("userID") + ";");

					// Envoi d'un mail

					// Récupération de la session
					Context iniCont = new InitialContext();
			        Context envCont = (Context) iniCont.lookup("java:/comp/env");
			      	javax.mail.Session sess = (javax.mail.Session)envCont.lookup("mail/Session");

			      	// Création du message
			      	Message message = new MimeMessage(sess);

			      	// From
			      	message.setFrom(new InternetAddress("market@dammien-deconinck.fr"));

			      	// To
			      	InternetAddress to[] = new InternetAddress[1];
			      	to[0] = new InternetAddress(rs.getString("mail"));
			      	message.setRecipients(Message.RecipientType.TO, to);

			      	// Sujet
		         	message.setSubject("Vous avez misé sur le bon cheval !");

		         	// Contenu
			      	message.setContent("Bravo ! Le pronostic \"" + lib + "\" sur lequel vous aviez parié vient d'être confirmé. Vous êtes donc l'heureux vainqueurs de " + rs.getString("somme") + "€, qui viennent d'être ajouté à votre argent sur le site.", "text/plain");

			      	// Envoi
			      	Transport.send(message);
			    }
				res.sendRedirect("informationFinit?id=" + id + "&success=1");
			}
			con.close();
		} catch(Exception e) {
			e.printStackTrace(res.getWriter());
		}
	}
}