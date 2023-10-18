-- @block initialize Foto
CREATE TABLE Foto (
    Path TEXT,
    IDAlloggio UUID NOT NULL,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
    PRIMARY KEY (Path, IDAlloggio)
);