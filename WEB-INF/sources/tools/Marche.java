package tools;



import java.io.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;



public class Marche
{
	int 	id,
			createur;
	long 	dateFinEpoch;
	String 	libelle,
			libelleInverse,
			dateDebut,
			dateFin,
			resultat;



	public Marche(int id)
	{
		this.id 		= id;
		if(id == 0) {
			createur 		= 0;
			dateFinEpoch	= 0;
			libelle 		= null;
			libelleInverse 	= null;
			dateDebut		= null;
			dateFin 		= null;
			resultat 		= null;
		} else {
			creerMarche();
		}
	}



	public void creerMarche()
	{
		Connection con 		= null;

		try {
			con 			= getConnection();

			Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery("	SELECT " +
													"libelle, " +
													"libelleInverse, " +
													"to_char(publication, 'DD/MM/YYYY') AS dateDebut, " +
													"to_char(dateFin, 'HH24:MI DD/MM/YYYY') AS dateFin, " +
													"date_part('epoch', dateFin) AS dateFinEpoch, " +
													"resultat, " +
													"userID " +
												"FROM markets " +
												"WHERE idMarket=" + id);
			if(rs.next()) {
				libelle 		= rs.getString("libelle");
				libelleInverse 	= rs.getString("libelleInverse");
				dateDebut	 	= rs.getString("dateDebut");
				dateFin		 	= rs.getString("dateFin");
				dateFinEpoch 	= Math.round(Double.parseDouble(rs.getString("dateFinEpoch")));
				resultat 		= rs.getString("resultat");
				createur 		= rs.getInt("userID");
			} else {
				createur 		= 0;
				dateFinEpoch	= 0;
				libelle 		= null;
				libelleInverse 	= null;
				dateDebut 		= null;
				dateFin 		= null;
				resultat 		= null;
			}

			con.close();

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
		}
	}



	public int id()
	{
		return id;
	}

	public int createur()
	{
		return createur;
	}

	public String libelle()
	{
		return libelle;
	}

	public String libelleInverse()
	{
		return libelleInverse;
	}

	public String dateDebut()
	{
		return dateDebut;
	}

	public String dateFin()
	{
		return dateFin;
	}

	public long dateFinEpoch()
	{
		return dateFinEpoch;
	}

	public String resultat()
	{
		return resultat;
	}

	public int nbMarches()
	{
		if(id == 0) {

			Connection con 		= null;
			int ret = 0;
			try {
				con 			= getConnection();

				Statement st 	= con.createStatement();
				ResultSet rs 	= st.executeQuery(	"SELECT " +
														"count(*) as c " +
													"FROM markets " +
													"WHERE " +
														"dateFin >= date('now') " +
														"AND resultat = 2;");

				if(rs.next())
					ret = rs.getInt("c");

				con.close();
				return ret;

			} catch( Exception e ) {
				try { con.close(); } catch( Exception ex ) { /* Ignored */}
				return ret;
			}
		}
		return 0;
	}

	public int nbMarchesFinit()
	{
		if(id == 0) {

			Connection con 		= null;
			int ret = 0;
			try {
				con 			= getConnection();

				Statement st 	= con.createStatement();
				ResultSet rs 	= st.executeQuery(	"SELECT " +
														"COUNT(*) AS c " +
													"FROM markets " +
													"WHERE " +
														"dateFin<DATE('now') " +
														"OR resultat <> 2;");
			    
				if(rs.next())
					ret = rs.getInt("c");

				con.close();
				return ret;

			} catch( Exception e ) {
				try { con.close(); } catch( Exception ex ) { /* Ignored */}
				return ret;
			}
		}
		return 0;
	}

	public String tousMarches()
	{
		if(id == 0) {

			Connection con 		= null;
			String ret = "";
			try {
				con 			= getConnection();

				Statement st 	= con.createStatement();
				ResultSet rs 	= st.executeQuery(	"SELECT " +
														"idMarket, " +
														"libelle " +
													"FROM markets " +
													"WHERE" +
														" dateFin>=DATE('now')" +
														" AND resultat=2 " +
													"ORDER BY publication DESC " +
													"LIMIT 10");

			    while (rs.next())
			    	ret += "<li><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></li>";
				
				con.close();
				return ret;

			} catch( Exception e ) {
				try { con.close(); } catch( Exception ex ) { /* Ignored */}
				return ret;
			}
		}
		return "";
	}

	public String marchesEnCours(int decalage)
	{
		return marches(	decalage, "dateFin >= date('now') " +
							" AND resultat = 2 ", 
						"publication" );
	}

	public String marchesFinit(int decalage)
	{
		return marches( decalage, "(dateFin < date('now') " +
							" OR resultat <> 2) ", 
						"dateFin" );
	}

	private String marches(int decalage, String condition, String ordre)
	{
		if(id == 0) {
			Connection con 		= null;
			String ret = "";
			try {
				con 			= getConnection();

				Statement st 	= con.createStatement();
				ResultSet rs 	= st.executeQuery("	SELECT " +
														"idMarket, " +
														"libelle, " +
														"libelleInverse, " +
														"to_char(dateFin, 'DD/MM/YYYY') AS dateFin, " +
														"date_part('epoch', dateFin) AS dateFinEpoch, " +
														"resultat " +
													"FROM markets " +
													"WHERE " + condition + " " +
														" AND idMarket <> 0 " +
													"ORDER BY " + ordre + " DESC " +
													"LIMIT 30 OFFSET " + decalage + ";");

				if(! rs.next())
					ret += "<tr><td colspan=3 style='text-align: center;'>Aucun marchés ne correspond à votre demande</td></tr>";
				else {
					do {
						ret += "<tr>";
						ret += "<td><a " + ((! rs.getString("resultat").equals("2"))
												?"class='finit'"
												: "") + 
								" href='information?id=" + rs.getString("idMarket") + "'>" + 
								((rs.getString("resultat").equals("1"))
									? rs.getString("libelleInverse")
									: rs.getString("libelle"))
								+ "</a></td>";
						ret += "<td>" + rs.getString("dateFin") + "</td>";

						java.util.Date fin = new java.util.Date(Math.round(Double.parseDouble(rs.getString("dateFinEpoch"))) * 1000);
						if(fin.after(new java.util.Date()))
							ret += "<td>En cours</td>";
						else {
							if(rs.getString("resultat").equals("2"))
								ret += "<td style='color: red;'>En attente d'un résultat</td>";
							else
								ret += "<td style='color: green;'>Finit</td>";
						}

						ret += "</tr>";	
					} while( rs.next());
				}

				con.close();
				return ret;

			} catch( Exception e ) {
				try { con.close(); } catch( Exception ex ) { /* Ignored */}
				return ret;
			}
		}

		return null;
	}

	public String proposition(int choix, int prixInverse)
	{
		Connection con 	= null;
		String ret 		= "";
		try {
			con 			= getConnection();

			Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"MIN(userID) AS userID, " +
													"MIN(nom || ' ' || prenom) AS nom, " +
													"count(DISTINCT userID) AS nbre, " +
													"SUM(nombreRestant) AS somme, " +
													((prixInverse!=0)?"100 - ":"") + "prix AS prix " +
												"FROM transactions " +
													"LEFT JOIN users ON transactions.userID=users.idUser " +
												"WHERE " +
													"marketID=" + id + 
													" AND choix=" + choix + 
													" AND nombreRestant <> 0" +
													" AND etat = 0 " +
												"GROUP BY prix " +
												"ORDER BY prix DESC;");

			if(!rs.next())
				ret 	= "0";
			else {
				do {
					ret += "<tr>";
					ret += "<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom"):"---") + "</td>";
					ret += "<td>" + rs.getString("somme") + " bons</td>";
					ret += "<td>" + rs.getString("prix") + " &euro; / u</td>";
					ret += "</tr>";
				} while(rs.next());
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return "<td></td>";
		}
	}

	public static String proposition(int marche, int choix, int prixInverse)
	{
		Connection con 	= null;
		String ret 		= "";
		try {
			con 			= getConnection();

			Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"MIN(userID) AS userID, " +
													"MIN(nom || ' ' || prenom) AS nom, " +
													"count(DISTINCT userID) AS nbre, " +
													"SUM(nombreRestant) AS somme, " +
													((prixInverse!=0)?"100 - ":"") + "prix AS prix " +
												"FROM transactions " +
													"LEFT JOIN users ON transactions.userID=users.idUser " +
												"WHERE " +
													"marketID=" + marche + 
													" AND choix=" + choix + 
													" AND nombreRestant <> 0" +
													" AND etat = 0 " +
												"GROUP BY prix " +
												"ORDER BY prix DESC;");

			if(!rs.next())
				ret 	= "0";
			else {
				do {
					ret += "<tr>";
					ret += "<td>" + ((rs.getInt("nbre")==1)?rs.getString("nom"):"---") + "</td>";
					ret += "<td>" + rs.getString("somme") + " bons</td>";
					ret += "<td>" + rs.getString("prix") + " &euro; / u</td>";
					ret += "</tr>";
				} while(rs.next());
			}

			con.close();
			return ret;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return "<td></td>";
		}
	}

	public int nbProp(int choix)
	{
		Connection con 	= null;
		try {
			con 			= getConnection();

			Statement st 	= con.createStatement();
			ResultSet rs 	= st.executeQuery(	"SELECT " +
													"count(*) AS nb " +
												"FROM transactions " +
												"WHERE " +
													"marketID=" + id +
													" AND choix=" + choix +
													" AND nombre <> 0;" );

			int nb = 0;
			if(rs.next())
				nb = rs.getInt("nb");

			con.close();
			return nb;

		} catch( Exception e ) {
			try { con.close(); } catch( Exception ex ) { /* Ignored */}
			return 0;
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