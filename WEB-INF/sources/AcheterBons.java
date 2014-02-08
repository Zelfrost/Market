import tools.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

@WebServlet("/AcheterBons")
public class AcheterBons extends HttpServlet
{
    public void service( HttpServletRequest req, HttpServletResponse res )
	throws ServletException, IOException
    {
    	Personne util = (Personne)req.getSession().getAttribute("Personne");

	    boolean valable = true;
	    int prix 		= 0,
	    	nbBons		= 0;

		try{
		    prix 	= Integer.parseInt(req.getParameter("prixBons"));
		    nbBons 	= Integer.parseInt(req.getParameter("nbBons"));
		    
		    if (prix <= 0 || prix >= 100) {
				res.sendRedirect("information?id=" + req.getParameter("id") + "&error=3");
				valable = false;
		    	//prix <0 ou >100
		    }

		} catch (Exception e){
		    res.sendRedirect("information?id=" + req.getParameter("id") + "&error=2");
		    valable = false;
		    //format prix invalide
		}

		Marche m = new Marche(Integer.parseInt(req.getParameter("id")));
		Marche mI = new Marche(m.idInverse());
		java.util.Date fin = new java.util.Date(m.dateFinEpoch() * 1000);

		if (req.getParameter("nbBons") != null && req.getParameter("prixBons") != null && valable && fin.after(new java.util.Date())) {
			try {
			    
			    Context initCtx = new InitialContext();
			    Context envCtx 	= (Context) initCtx.lookup("java:comp/env");
			    DataSource ds 	= (DataSource) envCtx.lookup("base");
			    Connection con 	= ds.getConnection();

			    Statement st 	= con.createStatement();
			    ResultSet rs 	= null;
			    
			    int somme		= prix * nbBons;
			    
			   	if(req.getParameter("valider").equals("Acheter") || req.getParameter("valider").equals("Buy") ) {
				    if(util.argentDispo() >= somme) {
						rs 			= st.executeQuery("SELECT idTrans, "
															+ "userID, "
															+ "100 - prix AS prix, "
															+ "nombreRestant, "
															+ "etat "
														+ "FROM transactions "
														+ "WHERE 100 - prix <= " + req.getParameter("prixBons")
															+ " AND marketID=" + req.getParameter("idInverse")
															+ " AND nombreRestant>0 "
														+ " ORDER BY prix ASC;");
						if(rs.next()) {
						    Statement upST	= con.createStatement();
						    int retraitBons;
						    do {
								retraitBons	= (nbBons > rs.getInt("nombreRestant")?rs.getInt("nombreRestant"):nbBons);
								upST		= con.createStatement();
								// Ajout de la transactions avec le nombre de bons
								upST.executeUpdate("INSERT INTO transactions(marketID, userID, nombre, nombreRestant, nombreBloque, prix, etat, dateTrans) VALUES (" 
															+ req.getParameter("id") + ", "
															+ util.id() + ", "
															+ retraitBons + ", "
															+ "0, "
															+ "0, "
															+ rs.getInt("prix") + ", "
															+ "0, "
															+ "CURRENT_TIMESTAMP);");
								// On retire de la transaction du joueur en face le nombre de bons rachetés
								upST.executeUpdate("UPDATE transactions SET "
														+ "nombreRestant = nombreRestant - " + retraitBons
													+ " WHERE idTrans = " + rs.getString("idTrans"));
								if(rs.getString("etat").equals("0")) {
									// On rend l'argent bloqué à l'utilisateur en face
									upST.executeUpdate("UPDATE users SET "
															+ "argentBloque = argentBloque - " + ((100-rs.getInt("prix")) * retraitBons)
														+ " WHERE idUser = " + rs.getString("userID"));
									// Et on descend son argent réel
									upST.executeUpdate("UPDATE users SET "
															+ "argent = argent - " + ((100-rs.getInt("prix")) * retraitBons)
														+ " WHERE idUser = " + rs.getString("userID"));
									upST.executeUpdate("INSERT INTO notifications(libelle, userID) VALUES('Achat de " + retraitBons + " bons sur le march&eacute; &quot;<a class=orange href=information?id=" + mI.id() + ">" + mI.libelle() + "</a>&quot;. Vous perdez la somme de " + ((100-rs.getInt("prix")) * retraitBons) + "&euro;.', " + rs.getString("userID") +");");
								} else {
									upST.executeUpdate("UPDATE users SET "
															+ "argent = argent + " + (rs.getInt("prix") * retraitBons)
														+ " WHERE idUser = " + rs.getString("userID"));
									upST.executeUpdate("INSERT INTO notifications(libelle, userID) VALUES('Vente de " + retraitBons + " bons sur le march&eacute; &quot;<a class=orange href=information?id=" + m.id() + ">" + m.libelle() + "</a>&quot;. Vous gagnez la somme de " + (rs.getInt("prix") * retraitBons) + "&euro;.', " + rs.getString("userID") +");");
								}
								// On met à jour l'argent de l'utilisateur
								util.setInformation();
								util.retirerArgent(rs.getInt("prix") * retraitBons);

								nbBons		-= retraitBons;
								if(nbBons == 0)
								    break;
						    } while(rs.next());
						    if(nbBons != 0) {
						    	// On met à jour l'argent bloqué du joueur si il reste des bons
						    	util.ajouterArgentBloque(Integer.parseInt(req.getParameter("prixBons")) * nbBons);
						    	// Et on crée une transactions pour les bons restants
						    	st.executeUpdate("INSERT INTO transactions(marketID, userID, nombre, nombreRestant, nombreBloque, prix, etat, dateTrans) VALUES ("
						    							+ req.getParameter("id") + ", "
						    							+ util.id() + ", "
						    							+ nbBons + ", "
						    							+ nbBons + ", "
						    							+ "0, "
						    							+ req.getParameter("prixBons") + ", "
						    							+ "0, "
						    							+ "CURRENT_TIMESTAMP);");
						    }
						} else {
					    	// On met à jour l'argent bloqué du joueur si il reste des bons
					    	util.ajouterArgentBloque(Integer.parseInt(req.getParameter("prixBons")) * nbBons);
					    	// Et on crée une transactions pour les bons restants
					    	st.executeUpdate("INSERT INTO transactions(marketID, userID, nombre, nombreRestant, nombreBloque, prix, etat, dateTrans) VALUES ("
					    							+ req.getParameter("id") + ", "
					    							+ util.id() + ", "
					    							+ nbBons + ", "
					    							+ nbBons + ", "
					    							+ "0, "
					    							+ req.getParameter("prixBons") + ", "
					    							+ "0, "
					    							+ "CURRENT_TIMESTAMP);");
						}
						con.close();
						util.setInformation();
						res.sendRedirect("information?id=" + req.getParameter("id") + "&success=1");
				    } else {
						con.close();
						util.setInformation();
						res.sendRedirect("information?id=" + req.getParameter("id") + "&error=1");
				    }
				} else {
					rs 	= st.executeQuery("SELECT "
												+ "SUM(nombre - nombreRestant - nombreBloque) AS nombre "
											+ "FROM transactions "
											+ "WHERE marketID=" + req.getParameter("id") + " "
												+ "AND userID=" + util.id() + " "
												+ "AND etat = 0;");
					if(rs.next() && rs.getInt("nombre") >= nbBons) {
						rs 	= st.executeQuery("SELECT "
												+ "idTrans, "
												+ "nombre - nombreRestant - nombreBloque AS nombre "
											+ "FROM transactions "
											+ "WHERE marketID=" + req.getParameter("id") + " "
												+ "AND userID=" + util.id() + " "
												+ "AND nombre - nombreRestant - nombreBloque <> 0 "
												+ "AND etat = 0;");

						Statement upSt 	= con.createStatement();
						int nbRetrait 	= 0;
						while(rs.next()){
							if(nbBons > rs.getInt("nombre"))
								nbRetrait = rs.getInt("nombre");
							else
								nbRetrait = nbBons;

							upSt.executeUpdate(	"UPDATE transactions " +
												"SET nombreBloque = nombreBloque + " + nbRetrait + " " +
												"WHERE idTrans=" + rs.getString("idTrans"));
							upSt.executeUpdate( "INSERT INTO transactions(" +
													"userID, " +
													"marketID, " +
													"nombre, " +
													"nombreRestant, " +
													"nombreBloque, " +
													"prix, " +
													"etat, " +
													"dateTrans) " +
												"VALUES(" +
													util.id() + ", " +
													m.idInverse() + ", " +
													nbRetrait + ", " +
													nbRetrait + ", " +
													"0, " +
													(100 - prix) + ", " + 
													"1, " +
													"CURRENT_TIMESTAMP);");
							nbBons -= nbRetrait;
						}
						res.sendRedirect("information?id=" + m.id() + "&success=1");
					} else {
						util.setInformation();
						res.sendRedirect("information?id=" + m.id() + "&error=5");
					}
				}
			} catch (Exception e ) {
			    e.printStackTrace(res.getWriter());
			}			
		} else
			res.sendRedirect("information?id=" + req.getParameter("id") + "&error=4");
    }
}