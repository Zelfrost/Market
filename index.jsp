<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp" />

<div class="left">
    <h2>Bienvenue sur IM, votre Marché de l'Information</h2>
    <p>Ici, tout se passe comme à la bourse, vous achetez des parts sur ce qui vous intéressent. Mais ce que vous achetez ici concerne un tout nouveau type de marchés. On n'achète pas des actions chez Apple ou chez Facebook ici.</p>
    <p>Non, ce que vous trouverez ici, ce sont des parts sur l'information. Vous pensez que les Red Sox seront champions de la Ligue cette année ? Que votre prof de math va virer un étudiant, ou que votre patron arrivera saoul au travail ?</p>
    <p>Eh bien lancez vous. Ici, tout le monde commence avec la même somme : 10 000€.</p>
    <p>Si vous êtes joueurs, vous pouvez acheter des parts sur les marchés en cours. Le principe est simple. Une information est constitué de trois choses : l'information elle-même, son inverse, et une date de fin. Vous pouvez acheter autant de part que vous le voulez ( et le pouvez ) sur l'information ou son inverse, au prix que vous le voulez, entre 1 et 99€. Toutes demandes d'achat que vous faites d'un côté devient une vente de l'autre. La date de fin représente la date à laquelle l'information ou son inverse se vérifie. Toutes personnes ayant acheté des parts du côté qui se vérifie remporte 100€.</p>
    <p>Si vous êtes Market Maker, ou créateur de marché, vous pouvez ajouter une information avec sa contre information, ainsi qu'une date à laquelle l'information devra pouvoir être vérifiée ou non. Si vous ne les avez pas, envoyez nous un mail avec les mêmes informations, et nous nous chargerons de l'ajouter si elle en vaut la peine.</p>
    <p>Sur ce, nous vous laissons naviguer parmi les informations en vente afin de découvrir le système par vous même.</p>
</div>

<div class="right">
    <div class="menu">
        <div class="header">
            Rechercher
        </div>
        <div class="body">
            <form method="POST" action="">
                <input type="text" name="search" />
                <input type="submit" value="Valider">
            </form>
        </div>
    </div>
     
    <div class="menu">
        <div class="header">
            Derniers Marchés
        </div>
        <div class="body">
            <ul>
<%
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("base");
    Connection con  = ds.getConnection();

    Statement st    = con.createStatement();
    ResultSet rs    = st.executeQuery("SELECT idMarket, libelle FROM markets WHERE dateFin>=DATE('now') ORDER BY publication DESC LIMIT 10");

    while (rs.next())
        out.println("<li><a href='information?id=" + rs.getString("idMarket") + "'>" + rs.getString("libelle") + "</a></li>");
    con.close();
%>
                <li class="all"><a href="marches">Tous les marchés</a></li>
            </ul>
        </div>
     </div>
</div>

<jsp:include page="footer.jsp" />