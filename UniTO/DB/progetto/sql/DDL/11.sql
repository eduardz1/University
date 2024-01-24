-- @block initialize Servizio
CREATE TABLE Servizio (
    TipoServizio TEXT,
    IDAlloggio UUID NOT NULL,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
    PRIMARY KEY (TipoServizio, IDAlloggio)
);