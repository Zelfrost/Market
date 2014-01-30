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