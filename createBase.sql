DROP TABLE IF EXISTS    transactions;
DROP TABLE IF EXISTS    markets;
DROP TABLE IF EXISTS    users;


CREATE TABLE  users (
    idUser                      INT,
    nom                         VARCHAR(30),
    prenom                      VARCHAR(30),
    login                       VARCHAR(20),
    pass                        VARCHAR(20),
    mail                        VARCHAR(40),
    argent                      NUMERIC(10),
    argentBloque                NUMERIC(10),
    role                        VARCHAR(20),
    
    CONSTRAINT pk_user          PRIMARY KEY (idUser)
);

INSERT INTO users VALUES(0, 'Admin', '', 'admin', 'Rt6cO9f', 'deconinck.damien@gmail.com', '1000000', '0', 'Admin');
INSERT INTO users VALUES(1, 'Deconinck', 'Damien', 'deconind', 'moi', 'deconinck.damien@gmail.com', '100000', '0', 'Admin');
INSERT INTO users VALUES(2, 'Godart', 'Christophe', 'godartc', 'moi', 'godart.christophe@gmail.com', '100000', '0', 'Admin');
INSERT INTO users VALUES(3, 'Vanhoutte', 'Mickael', 'vanhoutm', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Vandenbussche', 'Mathieu', 'vandenbm', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Delerue', 'Axel', 'deleruea', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Boulanger', 'Constantin', 'boulangc', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Caboche', 'Maxime', 'cabochem', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Weng', 'Tom', 'wengh', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Gombert', 'Pierre', 'gombertp', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Delvallee', 'Adrien', 'delvalla', 'moi', '', '10000', '0', 'MarketMaker');
INSERT INTO users VALUES(3, 'Demode', 'Alexandre', 'demodea', 'moi', '', '10000', '0', 'MarketMaker');


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
    VALUES(0, 'Monsieur Beaufils mettra un 20 en projet', 'Monsieur Beaufils ne mettra aucun 20 en projet', '2014-04-01',  CURRENT_TIMESTAMP, 0, 2);
INSERT INTO markets
    VALUES(1, 'Demode arrivera en retard a tous les cours cette annee', 'Demode arrivera a temps a au moins un cours cette annee', '2014-07-01', CURRENT_TIMESTAMP, 1, 2);


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
