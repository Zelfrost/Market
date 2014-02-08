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

			int gainM1 = 0, gainM2 = 0, idM1 = 0, idM2 = 0;

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

				rs = st.executeQuery("SELECT userID, nom, prenom, mail, SUM(100 * (nombre - nombreRestant - nombreBloque)) AS somme FROM transactions JOIN users ON transactions.userID=users.idUser WHERE marketID=" + rest + " AND nombreRestant<>nombre - nombreBloque GROUP BY userID, nom, prenom, mail;");

				// Identifiants
				///*
				final String username = "";
				final String password = "";
		 
				Properties props = new Properties();
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.starttls.enable", "true");
				props.put("mail.smtp.host", "smtp.gmail.com");
				props.put("mail.smtp.port", "587");
		 
				Session session = Session.getInstance(props,
					new javax.mail.Authenticator() {
						protected PasswordAuthentication getPasswordAuthentication() {
							return new PasswordAuthentication(username, password);
						}
					}
				);

				//*/

				while(rs.next()) {
					if(rs.getInt("somme")>gainM1) {
						gainM1 = rs.getInt("somme");
						idM1 = rs.getInt("userID");
					} else if(rs.getInt("somme")>gainM2) {
						gainM2 = rs.getInt("somme");
						idM2 = rs.getInt("userID");
					}

					upST.executeUpdate("UPDATE users SET argent = argent + " + rs.getString("somme") + ", nbVictoire = nbVictoire + 1 WHERE idUser=" + rs.getString("userID") + ";");

					// Envoi d'un mail
					///*
					Message message = new MimeMessage(session);
					message.setFrom(new InternetAddress("deconinck.damien@gmail.com"));
					message.setRecipients(Message.RecipientType.TO,
						InternetAddress.parse(rs.getString("mail")));
					message.setSubject("Félicitation - Votre Marché de l'Information");
					message.setText("Bravo ! Grâce à vos bons acheté sur le marché '" + lib + "', vous venez de remporter " + rs.getString("somme") + "€.");
		 
					Transport.send(message);
			      	//*/
			    }
			    if(idM1 != 0) {
				    Personne p = new Personne(idM1);
				    p.setMarketMaker();
				    if(idM2 != 0) {
					    p = new Personne(idM2);
					    p.setMarketMaker();
					}
				}

				((Personne)req.getSession().getAttribute("Personne")).setInformation();
				res.sendRedirect("informationFinit?id=" + id + "&success=1");
			}
			con.close();
		} catch(Exception e) {
			e.printStackTrace(res.getWriter());
		}
	}
}