import tools.Personne;
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
				res.sendRedirect("information?id=" + req.getParameter("id") + "&choix=" + req.getParameter("choix") + "&error=3");
				valable = false;
		    	//prix <0 ou >100
		    }

		} catch (Exception e){
		    res.sendRedirect("information?id=" + req.getParameter("id") + "&choix=" + req.getParameter("choix") + "&error=2");
		    valable = false;
		    //format prix invalide
		}


		if (req.getParameter("nbBons") != null && req.getParameter("prixBons") != null && valable) {
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
															+ "100-prix AS prix, "
															+ "nombreRestant "
														+ "FROM transactions "
														+ "WHERE 100-prix <= " + req.getParameter("prixBons")
															+ " AND choix = " + ((Integer.parseInt(req.getParameter("choix"))==0)?1:0)
															+ " AND marketID=" + req.getParameter("id")
															+ " AND nombreRestant>0 "
														+ " ORDER BY prix ASC;");
						if(rs.next()) {
						    Statement upST	= con.createStatement();
						    int retraitBons;
						    do {
								retraitBons	= (nbBons > rs.getInt("nombreRestant")?rs.getInt("nombreRestant"):nbBons);
								upST		= con.createStatement();
								// Ajout de la transactions avec le nombre de bons
								upST.executeUpdate("INSERT INTO transactions "
														+ "SELECT MAX(idtrans)+1, "
															+ req.getParameter("id") + ", "
															+ util.id() + ", "
															+ retraitBons + ", "
															+ "0, "
															+ rs.getInt("prix") + ", "
															+ req.getParameter("choix") + ", "
															+ "0, "
															+ "CURRENT_TIMESTAMP "
														+ "FROM transactions;");
								// On retire de la transaction du joueur en face le nombre de bons rachetés
								upST.executeUpdate("UPDATE transactions SET "
														+ "nombreRestant = nombreRestant - " + retraitBons
													+ " WHERE idTrans = " + rs.getString("idTrans"));
								// On rend l'argent bloqué à l'utilisateur en face
								upST.executeUpdate("UPDATE users SET "
														+ "argentBloque = argentBloque - " + ((100-rs.getInt("prix")) * retraitBons)
													+ " WHERE idUser = " + rs.getString("userID"));
								// Et on descend son argent réel
								upST.executeUpdate("UPDATE users SET "
														+ "argent = argent - " + ((100-rs.getInt("prix")) * retraitBons)
													+ " WHERE idUser = " + rs.getString("userID"));
								// On met à jour l'argent de l'utilisateur
								util.retirerArgent(rs.getInt("prix") * retraitBons);

								nbBons		-= retraitBons;
								if(nbBons == 0)
								    break;
						    } while(rs.next());
						    if(nbBons != 0) {
						    	// On met à jour l'argent bloqué du joueur si il reste des bons
						    	util.ajouterArgentBloque(Integer.parseInt(req.getParameter("prixBons")) * nbBons);
						    	// Et on crée une transactions pour les bons restants
						    	st.executeUpdate("INSERT INTO transactions "
						    						+ "SELECT MAX(idtrans)+1, "
						    							+ req.getParameter("id") + ", "
						    							+ util.id() + ", "
						    							+ nbBons + ", "
						    							+ "0, "
						    							+ nbBons + ", "
						    							+ req.getParameter("prixBons") + ", "
						    							+ req.getParameter("choix") + ", "
						    							+ "0, "
						    							+ "CURRENT_TIMESTAMP "
						    						+ "FROM transactions;");
						    }
						} else {
					    	// On met à jour l'argent bloqué du joueur si il reste des bons
					    	util.ajouterArgentBloque(Integer.parseInt(req.getParameter("prixBons")) * nbBons);
					    	// Et on crée une transactions pour les bons restants
					    	st.executeUpdate("INSERT INTO transactions "
					    						+ "SELECT MAX(idtrans)+1, "
					    							+ req.getParameter("id") + ", "
					    							+ util.id() + ", "
					    							+ nbBons + ", "
					    							+ "0, "
					    							+ nbBons + ", "
					    							+ req.getParameter("prixBons") + ", "
					    							+ req.getParameter("choix") + ", "
					    							+ "0, "
					    							+ "CURRENT_TIMESTAMP "
					    						+ "FROM transactions;");
						}
						con.close();
						res.sendRedirect("information?id=" + req.getParameter("id") + "&choix=" + req.getParameter("choix") + "&success=1");
				    } else {
					con.close();
					res.sendRedirect("information?id=" + req.getParameter("id") + "&choix=" + req.getParameter("choix") + "&error=1");
				    }
				} else {
					rs 	= st.executeQuery("SELECT "
												+ "SUM(nombre - nombreRestant - nombreBloque) AS nombre "
											+ "FROM transactions "
											+ "WHERE idMarket=" + req.getParameter("id") + " "
												+ "AND choix=" + req.getParameter("choix") + " "
												+ "AND userID=" + util.id() + " "
												+ "AND etat <> 0;");
				}
			} catch (Exception e ) {
			    e.printStackTrace(res.getWriter());
			}			
		}
    }
}	
