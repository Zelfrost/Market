package tools;



import java.util.*;
import java.io.*;

import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import javax.sql.*;

import javax.mail.*;
import javax.mail.internet.*;

import javax.naming.*;



public class Personne
{



	private String 	nom, 
					prenom,
					mail,
					login,
					pass,
					role;

	private int 	id,
					argent,
					argentBloque;



	public Personne(String login)
	{
		this.login 	= login;
		setInformation();
	}

	public Personne(int id)
	{
		this.id = id;
		setInformationId();
	}

	public Personne(String mail, int m)
	{
		this.mail 	= mail;
		Connection con 		= null;
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery("SELECT idUser, nom, prenom FROM users WHERE mail='" + mail + "';");
			
			if(rs.next()) {
				id 			= rs.getInt("idUser");
				nom 		= rs.getString("nom");
				prenom 		= rs.getString("prenom");
			}

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}



	public void setInformation()
	{
		Connection con 		= null;
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery("SELECT nom, prenom, mail, login, pass, role, idUser, argent, argentBloque FROM users WHERE login='" + login + "';");
			rs.next();

			nom 			= rs.getString("nom");
			prenom 			= rs.getString("prenom");
			pass 			= rs.getString("pass");
			mail 			= rs.getString("mail");
			role 			= rs.getString("role");
			id 				= rs.getInt("idUser");
			argent 			= rs.getInt("argent");
			argentBloque 	= rs.getInt("argentBloque");

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}

	public void setInformationId()
	{
		Connection con 		= null;
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery("SELECT nom, prenom, mail, login, pass, role, argent, argentBloque FROM users WHERE idUser='" + id + "';");
			rs.next();

			nom 			= rs.getString("nom");
			prenom 			= rs.getString("prenom");
			login 			= rs.getString("login");
			pass 			= rs.getString("pass");
			mail 			= rs.getString("mail");
			role 			= rs.getString("role");
			argent 			= rs.getInt("argent");
			argentBloque 	= rs.getInt("argentBloque");

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}

	public String nom()
	{
		return nom;
	}

	public String prenom()
	{
		return prenom;
	}

	public String mail()
	{
		return mail;
	}

	public void setMail(String mail)
	{
		Connection con 		= null;

		try {
			con 			= getConnection();

			PreparedStatement pst = con.prepareStatement("UPDATE users SET mail=? WHERE idUser=" + id + ";");
			pst.setString(1, mail);
			pst.executeUpdate();

			this.mail 	= mail;

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}

	public void sendNouvPass()
	{
		final String username = "deconinck.damien@gmail.com";
		final String password = "feuer-frei";

		String car = "abcdefghijklmnopqrstuvwxyz0123456789";
		String nPass = "";

		java.util.Random g = new java.util.Random();
		int ind = 0;

		for(int i = 0; i < 8; i ++) {
			ind = (int)(g.nextFloat() *26) + 1;
			nPass += car.substring( ind, ind+1);
		}

 		try {
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

			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress("deconinck.damien@gmail.com"));
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(mail));
			message.setSubject("Nouveau mot de passe - Marché de l'Information");
			message.setText("Voici votre nouveau mot de passe : " + nPass + ". A bientôt sur votre Marché de l'Information.");

			Transport.send(message);

			setPass(nPass);
		} catch( Exception e ) { /* Ignored */ }
	}

	public String pass()
	{
		return pass;
	}

	public void setPass(String pass)
	{
		Connection con 		= null;

		try {
			con 			= getConnection();

			PreparedStatement pst = con.prepareStatement("UPDATE users SET pass=? WHERE idUser=" + id + ";");
			pst.setString(1, pass);
			pst.executeUpdate();

			this.pass = pass;

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}

	public String login()
	{
		return login;
	}

	public String role()
	{
		return role;
	}

	public void setMarketMaker()
	{
		Connection con 		= null;
		try {

			con 			= getConnection();
			if(con == null)
				return;

            Statement st 	= con.createStatement();
            st.executeUpdate("UPDATE users SET role=MarketMaker WHERE idUser=" + id + ";");
			
			setInformation();

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}

	public int id()
	{
		return id;
	}

	public int argent()
	{
		return argent;
	}

	public void setArgent(int argent)
	{
		Connection con 		= null;
		try {

			con 			= getConnection();
			if(con == null)
				return;

            PreparedStatement pst 	= con.prepareStatement("UPDATE users SET argent=? WHERE idUser=" + id + ";");
			pst.setInt(1, argent);
			pst.executeUpdate();
			this.argent 			= argent;

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}

	public void ajouterArgent(int ajout)
	{
		setArgent(argent + ajout);
	}

	public void retirerArgent(int retrait)
	{
		setArgent(argent - retrait);
	}

	public int argentBloque()
	{
		return argentBloque;
	}

	public void majArgentBloque()
	{
		Connection con 		= null;
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery("SELECT argentBloque FROM users WHERE login='" + login + "';");
			rs.next();

			argentBloque 	= rs.getInt("argentBloque");

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */ }
		}
	}

	public void recupArgentBloque(int idTrans)
	{
		Connection con 		= null;
		try {

			con 			= getConnection();

            PreparedStatement pst 	= con.prepareStatement("UPDATE users SET argentBloque = argentBloque - ( SELECT (nombreRestant * prix) FROM transactions WHERE idTrans=? ) WHERE idUser=" + id + ";");
			pst.setInt(1, idTrans);
			pst.executeUpdate();
			majArgentBloque();

			con.close();
			
		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}

	public boolean setArgentBloque(int argentBloque)
	{
		Connection con 		= null;
		try {

			con 			= getConnection();
			if(con == null)
				return false;

            PreparedStatement pst 	= con.prepareStatement("UPDATE users SET argentBloque=? WHERE idUser=" + id + ";");
			pst.setInt(1, argentBloque);
			pst.executeUpdate();
			this.argentBloque 		= argentBloque;

			con.close();
			return true;
			
		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return false;
		}
	}

	public void ajouterArgentBloque(int ajout)
	{
		setArgentBloque(argentBloque + ajout);
	}

	public void retirerArgentBloque(int retrait)
	{
		setArgentBloque(argentBloque - retrait);
	}

	public int argentDispo()
	{
		return argent - argentBloque;
	}

	public String getBons(int marketID, boolean suppr)
	{
		Connection con 	= null;
		String ret 		= "";
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"idTrans, " + 
													"nombreRestant AS nombre, " +
													"prix " +
												"FROM transactions " +
												"WHERE userID = '" + id + "'" +
													" AND marketID=" + marketID +
													" AND nombreRestant <> 0 " +
												"ORDER BY " +
													"prix ASC, " +
													"nombreRestant ASC;");
			if(! rs.next())
				ret = "0";
			else {
				do {
					ret += "<tr>";
					ret += "<td>" + rs.getString("nombre") + " bons</td>";
					ret += "<td>" + rs.getString("prix") + " &euro; / u</td>";
					if(suppr)
						ret += "<td><a href='suppTrans?idTrans=" + rs.getString("idTrans") + "&id=" + marketID + "'>X</a></td>";
					ret += "</tr>";
				} while(rs.next());
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return "0";
		}
	}

	public String getTitres(int marketID)
	{
		Connection con 	= null;
		String ret 		= "Vous ne possédez actuellement <span class='underline'>aucun</span> titres dans ce marché.";
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
            String rq 		= "SELECT " +
													"SUM(nombre - nombreRestant) AS nombre " +
												"FROM transactions " +
												"WHERE userID = '" + id + "'" +
													" AND marketID=" + marketID +
													" AND nombre > nombreRestant;";
			ResultSet rs 	= st.executeQuery( rq );
			if(rs.next() && rs.getString("nombre") != null)
				ret = "Vous possédez actuellement <span class='underline'>" + rs.getString("nombre") + "</span> titre" + ((rs.getInt("nombre")!=1)?"s":"") + " dans ce marché.";

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return ret;
		}
	}

	public String mesMarches()
	{
		Connection con 	= null;
		String ret 		= "";
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"idMarket, " +
													"libelle, " +
												"FROM transactions " +
													"JOIN markets ON markets.idMarket=transactions.marketID " +
												"WHERE" +
													" transactions.userID=" + id + 
													" AND dateFin>=DATE('now')" +
													" AND resultat=0 " +
												"GROUP BY " +
													"idMarket " +
												"ORDER BY publication " +
												"DESC LIMIT 10;");
			if(! rs.next())
				ret = "0";
			else {
				do {
	            	ret += "<li><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></li>";
	        	} while (rs.next());
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return "0";
		}
	}

	public String tousMesMarches()
	{
		Connection con 	= null;
		String ret 		= "";
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"idMarket, " +
													"libelle, " +
													"to_char(dateFin, 'HH24:MI DD/MM/YYYY') AS d, " +
													"date_part('epoch', dateFin) AS dateFinEpoch " +
												"FROM transactions " +
													"JOIN markets ON markets.idMarket=transactions.marketID " +
												"WHERE" +
													" transactions.userID=" + id + 
													" AND dateFin>=DATE('now')" +
													" AND resultat=0 " +
												"GROUP BY " +
													"idMarket " +
												"ORDER BY publication " +
												"DESC LIMIT 10;");
			if(! rs.next())
				ret = "<td class='empty' colspan='3'>Vous n'avez investis dans aucun marchés en cours</td>";
			else {
				do {
					ret += "<tr>";
	            	ret += "<td><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></td>";
	            	ret += "<td>" + rs.getString("d") + "</td>";

					java.util.Date fin = new java.util.Date(Math.round(Double.parseDouble(rs.getString("dateFinEpoch"))) * 1000);
					if(fin.after(new java.util.Date()))
						ret += "<td>En cours</td>";
					else {
						if(rs.getString("resultat").equals("0"))
							ret += "<td style='color: red;'>En attente d'un résultat</td>";
						else
							ret += "<td style='color: green;'>Finit</td>";
					}

	            	ret += "</tr>";
	        	} while (rs.next());
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return "0";
		}
	}


	public int nbMesMarches()
	{
		Connection con 	= null;
		int ret;
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"count(*) AS c " +
												"FROM transactions " +
													"JOIN markets ON markets.idMarket=transactions.marketID " +
												"WHERE" +
													" transactions.userID=" + id + 
													" AND dateFin>=DATE('now')" +
													" AND resultat = 0, " +
													" AND etat = 0 " +
												"GROUP BY " +
													"idMarket " +
												"ORDER BY publication " +
												"DESC LIMIT 10;");
			if(! rs.next())
				ret = 0;
			else {
				ret = rs.getInt("c");
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return 0;
		}
	}

	public static String recherche(String r)
	{
		String ret = "";
		Connection con 	= null;
		try {
			con 			= getConnection();
			Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"idUser, " +
													"( prenom || ' ' || nom ) AS nom, " +
													"mail " +
												"FROM users " +
												"WHERE " +
													"idUser<>0 AND " +
													"( " +
														"nom ILIKE '%" + r + "%' OR " +
														"prenom ILIKE '%" + r + "%' OR " +
														"login ILIKE '%" + r + "%' OR " +
														"mail ILIKE '%" + r + "%' " +
													") " +
												"ORDER BY nom, prenom;" );

			while(rs.next()) {
				ret += "<tr>";
				ret += "<td><a class='orange' href='utilisateur?id=" + rs.getString("idUser") + "'>" + rs.getString("nom") + "</a></td>";
				ret += "<td>" + rs.getString("mail") + "</td>";
				ret += "</tr>";
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return e.getMessage();
		}
	}

	private static Connection getConnection()
	{
		Connection con 	= null;
		try {
			
			Context initCtx = new InitialContext();
            Context envCtx 	= (Context) initCtx.lookup("java:comp/env");
            DataSource ds 	= (DataSource) envCtx.lookup("base");
            con 			= ds.getConnection();

            return con;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */ }
			return null;
		}
	}
}