-- @block initialize Telefono
CREATE TABLE Telefono (
    Utente VARCHAR(45) NOT NULL,
    Numero VARCHAR(15) NOT NULL,
    Prefisso VARCHAR(5) NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (Utente, Numero)
);