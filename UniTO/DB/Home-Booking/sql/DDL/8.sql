-- @block initialize Lista
CREATE TABLE Lista (
    IDLista UUID NOT NULL DEFAULT gen_random_uuid(),
    Nome VARCHAR(45) NOT NULL,
    Descrizione TEXT,
    Autore VARCHAR(45) NOT NULL,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (IDLista)
);