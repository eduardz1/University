
-- @block initialize Prenotazione 
-- IDAlloggio: Può essere NULL per supportare le casistiche in cui un alloggio è stato cancellato dal sistema
-- Il check su DataInizio > CURRENT_TIMESTAMP potrebbe non permettere inserimenti massivi futuri da parte di un DBA,
-- in caso di manutenzione: meglio evitare questo tipo di controllo
CREATE TABLE Prenotazione (
    IDPrenotazione UUID NOT NULL DEFAULT gen_random_uuid(),
    IDAlloggio UUID,
    Richiedente VARCHAR(45) NOT NULL,
    DataInizio TIMESTAMP NOT NULL,
    DataFine TIMESTAMP NOT NULL,
    Soggiorno BOOLEAN DEFAULT FALSE NOT NULL,
    NumeroOspiti INT NOT NULL CHECK (NumeroOspiti >= 0),
    Stato StatoPrenotazione NOT NULL DEFAULT 'Prenotato',
    Visibile BOOLEAN DEFAULT FALSE NOT NULL,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE
    SET NULL,
        FOREIGN KEY (Richiedente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (IDPrenotazione),
        Constraint prenotazione_start_before_end CHECK (DataInizio < DataFine) 
    -- CHECK (DataInizio > CURRENT_TIMESTAMP)
);