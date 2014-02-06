DROP TABLE IF EXISTS    transactions;
DROP TABLE IF EXISTS    markets;
DROP TABLE IF EXISTS    users;


CREATE TABLE  users (
    idUser                      SERIAL,
    nom                         VARCHAR(30),
    prenom                      VARCHAR(30),
    login                       VARCHAR(20),
    pass                        VARCHAR(20),
    mail                        VARCHAR(40),
    argent                      NUMERIC(10),
    argentBloque                NUMERIC(10),
    nbVictoire                  NUMERIC(1),
    role                        VARCHAR(20),
    
    CONSTRAINT pk_user          PRIMARY KEY (idUser)
);

INSERT INTO users VALUES(0, 'Admin', 'admin', 'admin', 'Rt6cO9f', 'deconinck.damien@gmail.com', '1000000', 0, 0, 'Admin');
INSERT INTO users(nom, prenom, login, pass, mail, argent, argentBloque, nbVictoire, role) VALUES('Deconinck', 'Damien', 'deconind', 'vrpCLZ', 'deconinck.damien@gmail.com', '100000', 0, 0, 'Admin');
INSERT INTO users(nom, prenom, login, pass, mail, argent, argentBloque, nbVictoire, role) VALUES('Godart', 'Christophe', 'godartc', 'vrpCLZ', 'godart.christophe@gmail.com', '100000', 0, 0, 'Admin');

CREATE TABLE markets
(
    idMarket                    SERIAL,
    libelle                     VARCHAR(300),
    dateFin                     TIMESTAMP,
    publication                 TIMESTAMP,
    resultat                    NUMERIC(1),
    etat                        NUMERIC(1),
    userID                      INT,
    idInverse                   NUMERIC(7),

    CONSTRAINT pk_market        PRIMARY KEY (idMarket),
    CONSTRAINT fk_user          FOREIGN KEY (userID)    REFERENCES users(idUser)
                                ON UPDATE CASCADE
                                ON DELETE SET NULL
);

INSERT INTO markets VALUES(0, '', '1995-01-01 00:00:00.0',  CURRENT_TIMESTAMP, 2, 0, 0, 1);
INSERT INTO markets(libelle, dateFin, publication, resultat, etat, userID, idInverse) VALUES('', '1995-01-01 00:00:00.0',  CURRENT_TIMESTAMP, 2, 1, 0, 0);
INSERT INTO markets(libelle, dateFin, publication, resultat, etat, userID, idInverse) VALUES('Il pleuvra le 1er Juin', '2014-06-01 00:00:00.0',  CURRENT_TIMESTAMP, 2, 0, 1, 3);
INSERT INTO markets(libelle, dateFin, publication, resultat, etat, userID, idInverse) VALUES('Il ne pleuvra pas le 1er Juin', '2014-06-01 00:00:00.0',  CURRENT_TIMESTAMP, 2, 1, 1, 2);


CREATE TABLE transactions
(
    idTrans                     SERIAL,
    marketID                    INT,
    userID                      INT,
    nombre                      NUMERIC(10),
    nombreRestant               NUMERIC(10),
    prix                        NUMERIC(10),
    etat                        NUMERIC(1),
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
