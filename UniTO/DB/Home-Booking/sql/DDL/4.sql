-- @block initialize Alloggio 
-- Nome: Si potrebbe creare un indice su Nome per velocizzare le operazioni di ricerca sull'alloggio
-- Host: Può essere NULL per supportare le casistiche in cui un host è stato cancellato dal sistema
CREATE TABLE Alloggio (
    IDAlloggio UUID NOT NULL DEFAULT gen_random_uuid(),
    Nome VARCHAR(45) NOT NULL,
    Host VARCHAR(45),
    Descrizione TEXT,
    Tipologia TipologiaAlloggio NOT NULL,
    OrarioCheckIn TIME NOT NULL,
    OrarioCheckOut TIME NOT NULL,
    Costo NUMERIC NOT NULL CHECK (Costo > 0),
    CostoPulizia NUMERIC DEFAULT 0 CHECK (CostoPulizia >= 0),
    CAP INT NOT NULL CHECK (CAP > 0),
    Comune VARCHAR(45) NOT NULL,
    Civico INT NOT NULL CHECK (Civico > 0),
    Via VARCHAR(45) NOT NULL,
    FOREIGN KEY (Host) REFERENCES Utente(Email) ON DELETE
    SET NULL ON UPDATE CASCADE,
        PRIMARY KEY (IDAlloggio)
);