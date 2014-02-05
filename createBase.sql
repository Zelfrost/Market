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
    role                        VARCHAR(20),
    
    CONSTRAINT pk_user          PRIMARY KEY (idUser)
);

INSERT INTO users VALUES(0, 'Admin', 'admin', 'admin', 'Rt6cO9f', 'deconinck.damien@gmail.com', '1000000', '0', 'Admin');
INSERT INTO users(nom, prenom, login, pass, mail, argent, argentBloque, role) VALUES('Deconinck', 'Damien', 'deconind', 'vrpCLZ', 'deconinck.damien@gmail.com', '100000', '0', 'Admin');
INSERT INTO users(nom, prenom, login, pass, mail, argent, argentBloque, role) VALUES('Godart', 'Christophe', 'godartc', 'vrpCLZ', 'godart.christophe@gmail.com', '100000', '0', 'Admin');

CREATE TABLE markets
(
    idMarket                    SERIAL,
    libelle                     VARCHAR(300),
    libelleInverse              VARCHAR(300),
    dateFin                     TIMESTAMP,
    publication                 TIMESTAMP,
    userID                      INT,
    resultat                    NUMERIC(1),

    CONSTRAINT pk_market        PRIMARY KEY (idMarket),
    CONSTRAINT fk_user          FOREIGN KEY (userID)    REFERENCES users(idUser)
                                ON UPDATE CASCADE
                                ON DELETE SET NULL
);

INSERT INTO markets VALUES(0, '', '', '1995-01-01 00:00:00.0',  CURRENT_TIMESTAMP, 0, 2);
INSERT INTO markets(libelle, libelleInverse, dateFin, publication, userID, resultat) VALUES('Il pleuvra le 1er Juin', 'Il ne pleuvra pas le 1er Juin', '2014-06-01 00:00:00.0',  CURRENT_TIMESTAMP, 0, 2);


CREATE TABLE transactions
(
    idTrans                     SERIAL,
    marketID                    INT,
    userID                      INT,
    nombre                      NUMERIC(10),
    nombreRestant               NUMERIC(10),
    prix                        NUMERIC(10),
    choix                       NUMERIC(1),
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

INSERT INTO transactions VALUES(0, 0, 0, 0, 0, 0, 0, 0, CURRENT_TIMESTAMP);
