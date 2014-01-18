DROP TABLE IF EXISTS    transactions;
DROP TABLE IF EXISTS    markets;
DROP TABLE IF EXISTS    users;


CREATE TABLE  users (
    idUser                      INT,
    nom                         VARCHAR(30),
    prenom                      VARCHAR(30),
    login                       VARCHAR(20),
    pass                        VARCHAR(20),
    argent                      NUMERIC(10),
    role                        VARCHAR(20),
    
    CONSTRAINT pk_user          PRIMARY KEY (idUser)
);

INSERT INTO users VALUES(0, 'Deconinck', 'Damien', 'deconind', 'moi', '10000', 'Admin');
INSERT INTO users VALUES(1, 'Godart', 'Christophe', 'godartc', 'moi', '10000', 'Admin');
INSERT INTO users VALUES(2, 'Vanhoutte', 'Mickael', 'vanhoutm', 'moi', '10000', 'MarketMaker');
INSERT INTO users VALUES(3, 'Weng', 'Tom', 'wengh', 'moi', '10000', 'User');


CREATE TABLE markets
(
    idMarket                    INT,
    libelle                     VARCHAR(300),
    libelleInverse              VARCHAR(300),
    dateFin                     DATE,
    publication                 TIMESTAMP,
    userID                      INT,
    resultat                    NUMERIC(1),

    CONSTRAINT pk_market        PRIMARY KEY (idMarket),
    CONSTRAINT fk_user          FOREIGN KEY (userID)    REFERENCES users(idUser)
                                ON UPDATE CASCADE
                                ON DELETE SET NULL
);

INSERT INTO markets 
    VALUES(0, 'Monsieur Beaufils mettra un 20 en projet', 'Monsieur Beaufils ne mettra aucun 20 en projet', '2014-04-01',  CURRENT_TIMESTAMP, 0, NULL);
INSERT INTO markets
    VALUES(1, 'Demode arrivera en retard a tous les cours cette annee', 'Demode arrivera a temps a au moins un cours cette annee', '2014-07-01', CURRENT_TIMESTAMP, 1, NULL);


CREATE TABLE transactions
(
    idTrans                     INT,
    marketID                    INT,
    userID                      INT,
    nombre                      NUMERIC(10),
    nombreRestant               NUMERIC(10),
    prix                        NUMERIC(10),
    choix                       NUMERIC(1),
    dateTrans                   TIMESTAMP,

    CONSTRAINT pk_transactions  PRIMARY KEY (idTrans),
    CONSTRAINT fk_markets       FOREIGN KEY (marketID)  REFERENCES markets(idMarket)
                                ON UPDATE CASCADE
                                ON DELETE SET NULL,
    CONSTRAINT fk_users         FOREIGN KEY (userID)    REFERENCES users(idUser)
                                ON UPDATE CASCADE
                                ON DELETE SET NULL
);

INSERT INTO transactions VALUES(0, 0, 0, 0, 0, 0, 0, CURRENT_TIMESTAMP);
