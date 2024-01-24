-- @block initialize Commento 
CREATE TABLE Commento (
    IDCommento UUID NOT NULL DEFAULT gen_random_uuid(),
    IDRecensione UUID NOT NULL,
    DataCommento TIMESTAMP NOT NULL,
    Autore VARCHAR(45) NOT NULL,
    Corpo TEXT,
    FOREIGN KEY (IDRecensione) REFERENCES Recensione(IDRecensione) ON DELETE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE
    SET NULL ON UPDATE CASCADE,
        PRIMARY KEY (IDCommento)
);