package tools;



import java.io.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;



public class Personne
{



	private String 	nom, 
					prenom,
					mail,
					login,
					role,
					error;

	private int 	id,
					argent,
					argentBloque;



	public Personne(String login)
	{
		this.login 	= login;
		setInformation();
	}



	private void setInformation()
	{
		Connection con 		= null;
		error 				= "Pas d'erreurs.<br>";
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery("Select nom, prenom, mail, login, role, idUser, argent, argentBloque FROM users WHERE login='" + login + "';");
			rs.next();

			nom 			= rs.getString("nom");
			prenom 			= rs.getString("prenom");
			mail 			= rs.getString("mail");
			role 			= rs.getString("role");
			id 				= rs.getInt("idUser");
			argent 			= rs.getInt("argent");
			argentBloque 	= rs.getInt("argentBloque");

			con.close();

		} catch( Exception e ) {
			setError(e);
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
		this.mail 	= mail;
	}

	public boolean setPass(String oldPass, String newPass)
	{
		Connection con 		= null;
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery("SELECT pass FROM users WHERE idUser=" + id + ";");
			rs.next();

			String pass 	= rs.getString("pass");
			if(! pass.equals(oldPass))
				return false;

			PreparedStatement pst = con.prepareStatement("UPDATE users SET pass=? WHERE idUser=" + id + ";");
			pst.setString(1, newPass);
			pst.executeUpdate();

			con.close();
			
			return true;

		} catch( Exception e ) {
			setError(e);
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return false;
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

	public int id()
	{
		return id;
	}

	public int argent()
	{
		return argent;
	}

	public boolean setArgent(int argent)
	{
		Connection con 		= null;
		try {

			con 			= getConnection();
			if(con == null)
				return false;

            PreparedStatement pst 	= con.prepareStatement("UPDATE users SET argent=? WHERE idUser=" + id + ";");
			pst.setInt(1, argent);
			pst.executeUpdate();
			this.argent 			= argent;

			con.close();
			return true;

		} catch( Exception e ) {
			setError(e);
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return false;
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
			setError(e);
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

	public String getBons(int marketID, int choix)
	{
		return getBons(marketID, choix, "nombreRestant", "nombreRestant<>0");
	}

	public String getTitres(int marketID, int choix)
	{
		return getBons(marketID, choix, "nombre - nombreRestant AS nombre", "nombre > nombreRestant");
	}

	private String getBons(int marketID, int choix, String nombre, String condition)
	{
		Connection con 	= null;
		String ret 		= "";
		try {

			con 			= getConnection();

            Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"idTrans, " + 
													nombre + ", " +
													"prix " +
												"FROM transactions " +
												"WHERE userID = '" + id + "'" +
													" AND marketID=" + marketID +
													" AND choix=" + choix +
													" AND " + condition + " " +
												"ORDER BY " +
													"prix ASC, " +
													"nombreRestant ASC;");
			if(! rs.next())
				ret = "0";
			else {
				do {
					ret += "<tr>";
					ret += "<td>" + rs.getString("nombreRestant") + " bons</td>";
					ret += "<td>" + rs.getString("prix") + " euros/u</td>";
					ret += "<td><a href='suppTrans?idTrans=" + rs.getString("idTrans") + "&id=" + marketID + "'>X</a></td>";
					ret += "<tr>";
				} while(rs.next());
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return "0";
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
													"libelleInverse, " +
													"choix " +
												"FROM transactions " +
													"JOIN markets ON markets.idMarket=transactions.marketID " +
												"WHERE" +
													" transactions.userID=" + id + 
													" AND dateFin>=DATE('now')" +
													" AND resultat=2 " +
												"GROUP BY " +
													"idMarket, " +
													"choix " +
												"ORDER BY publication " +
												"DESC LIMIT 10;");
			if(! rs.next())
				ret = "0";
			else {
				do {
	            	ret += "<li><a href='information?id=" + rs.getString("idMarket") + "&choix=" + rs.getString("choix") + "'>" + ((rs.getString("choix").equals("0"))?rs.getString("libelle"):rs.getString("libelleInverse")) + "</a></li>";
	        	} while (rs.next());
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return "0";
		}
	}



	private Connection getConnection()
	{
		Connection con 	= null;
		try {
			
			Context initCtx = new InitialContext();
            Context envCtx 	= (Context) initCtx.lookup("java:comp/env");
            DataSource ds 	= (DataSource) envCtx.lookup("base");
            con 			= ds.getConnection();

            return con;

		} catch( Exception e ) {
			setError(e);
			try { con.close(); } catch( Exception ex ) { /* Ignored */ }
			return null;
		}
	}



	private void setError(Exception error)
	{
		if(this.error.equals("Pas d'erreurs.<br>") && error != null) {
			StringWriter errors = new StringWriter();
			error.printStackTrace(new PrintWriter(errors));
			this.error 	= errors.toString();
		}
	}

	public String error()
	{
		String tmp  = error;
		error 		= "Pas d'erreurs.<br>";
		return tmp;
	}
}