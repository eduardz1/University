-- @block initialize Contenuto
CREATE TABLE Contenuto (
    IDLista UUID NOT NULL,
    IDAlloggio UUID NOT NULL,
    FOREIGN KEY (IDLista) REFERENCES Lista(IDLista) ON DELETE CASCADE,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
    PRIMARY KEY (IDLista, IDAlloggio)
);