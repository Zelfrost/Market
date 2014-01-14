DROP TABLE IF EXISTS    users;
DROP TABLE IF EXISTS    markets;
DROP TABLE IF EXISTS    transactions;


CREATE TABLE  users (
    idUser                      INT,
    nom                         VARCHAR(30),
    prenom                      VARCHAR(30),
    login                       VARCHAR(20),
    pass                        VARCHAR(20),
    argent                      NUMERIC(10),
    marketMaker                 NUMERIC(1),
    
    CONSTRAINT pk_user          PRIMARY KEY (idUser)
);

INSERT INTO users(idUser, nom, prenom, login, pass, argent, marketMaker) 
    VALUES(0, 'Deconinck', 'Damien', 'deconind', 'moi', '10000', 1);
INSERT INTO users(idUser, nom, prenom, login, pass, argent, marketMaker) 
    VALUES(1, 'Godart', 'Christophe', 'godartc', 'moi', '10000', 1);
INSERT INTO users(idUser, nom, prenom, login, pass, argent, marketMaker) 
    VALUES(2, 'Vanhoutte', 'Mickael', 'vanhoutm', 'moi', 10000, 0);
INSERT INTO users(idUser, nom, prenom, login, pass, argent, marketMaker) 
    VALUES(3, 'Weng', 'Tom', 'wengh', 'moi', 10000, 0);


CREATE TABLE markets
(
    idMarket                    INT,
    libelle                     VARCHAR(300),
    libelleInverse              VARCHAR(300),
    dateFin                     DATE,
    publication                 DATETIME,

    CONSTRAINT pk_market        PRIMARY KEY (idMarket)
);

INSERT INTO markets(idMarket, libelle, libelleInverse, dateFin, publication) 
    VALUES(0, 'Monsieur Beaufils mettra un 20 en projet', 'Monsieur Beaufils ne mettra aucun 20 en projet', '2014-04-01',  CURRENT_TIMESTAMP);
INSERT INTO markets(idMarket, libelle, libelleInverse, dateFin, publication) 
    VALUES(1, 'Demode arrivera en retard a tous les cours cette annee', 'Demode arrivera a temps a au moins un cours cette annee', '2014-07-01',  CURRENT_TIMESTAMP);


CREATE TABLE transactions
(
    idTrans                     INT,
    marketID                    INT,
    userID                      INT,
    nombre                      NUMERIC(10),
    nombreRestant               NUMERIC(10),
    prix                        NUMERIC(10),
    choix                       NUMERIC(1),
    dateTrans                   DATETIME,

    CONSTRAINT pk_transactions  PRIMARY KEY (idTrans),
    CONSTRAINT fk_markets       FOREIGN KEY (marketID)  REFERENCES markets(idMarket)
                                ON UPDATE CASCADE
                                ON DELETE SET NULL,
    CONSTRAINT fk_users         FOREIGN KEY (userID)    REFERENCES users(idUser)
                                ON UPDATE CASCADE
                                ON DELETE SET NULL
);

INSERT INTO transactions(idTrans, userID, marketID, nombre, prix, choix, dateTrans) 
    VALUES(0, 0, 0, 10, 50, 0, CURRENT_TIMESTAMP);
INSERT INTO transactions(idTrans, userID, marketID, nombre, prix, choix, dateTrans) 
    VALUES(1, 1, 0, 60, 60, 1, CURRENT_TIMESTAMP);
INSERT INTO transactions(idTrans, userID, marketID, nombre, prix, choix, dateTrans) 
    VALUES(2, 2, 0, 40, 80, 1, CURRENT_TIMESTAMP);
INSERT INTO transactions(idTrans, userID, marketID, nombre, prix, choix, dateTrans) 
    VALUES(3, 3, 0, 20, 80, 1, CURRENT_TIMESTAMP);
INSERT INTO transactions(idTrans, userID, marketID, nombre, prix, choix, dateTrans) 
    VALUES(4, 0, 0, 70, 90, 1, CURRENT_TIMESTAMP);
INSERT INTO transactions(idTrans, userID, marketID, nombre, prix, choix, dateTrans) 
    VALUES(5, 1, 0, 20, 30, 1, CURRENT_TIMESTAMP);
