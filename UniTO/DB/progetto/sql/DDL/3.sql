-- @block initialize Pagamento
CREATE TABLE Pagamento (
    Utente VARCHAR(45) NOT NULL,
    Numero VARCHAR(16) NOT NULL CHECK (char_length(Numero) = 16),
    Circuito VARCHAR(30) NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (Utente, Numero)
);