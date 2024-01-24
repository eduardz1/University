-- @block initialize Recensione 
-- IDPrenotazione: Una prenotazione non può essere cancellata dal sistema, a meno di attività manuali sul db
CREATE TABLE Recensione (
    IDRecensione UUID NOT NULL DEFAULT gen_random_uuid(),
    IDPrenotazione UUID NOT NULL,
    Autore VARCHAR(45) NOT NULL,
    DataRecensione DATE NOT NULL,
    ValutazionePosizione INT CHECK(
        ValutazionePosizione >= 0
        AND ValutazionePosizione <= 5
    ),
    ValutazionePulizia INT CHECK(
        ValutazionePulizia >= 0
        AND ValutazionePulizia <= 5
    ),
    ValutazioneQualitaPrezzo INT CHECK(
        ValutazioneQualitaPrezzo >= 0
        AND ValutazioneQualitaPrezzo <= 5
    ),
    ValutazioneComunicazione INT CHECK(
        ValutazioneComunicazione >= 0
        AND ValutazioneComunicazione <= 5
    ),
    Corpo TEXT,
    Categoria TEXT NOT NULL,
    FOREIGN KEY (IDPrenotazione) REFERENCES Prenotazione(IDPrenotazione) ON DELETE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE
    SET NULL ON UPDATE CASCADE,
        PRIMARY KEY (IDRecensione),
        Constraint recensione_valid_category CHECK (
            (
                Categoria = 'Host'
                AND ValutazionePosizione IS NULL
                AND ValutazionePulizia IS NULL
                AND ValutazioneQualitaPrezzo IS NUll
            )
            OR (
                Categoria = 'Utente'
                AND ValutazionePosizione IS NULL
                AND ValutazionePulizia IS NULL
                AND ValutazioneQualitaPrezzo IS NUll
                AND ValutazioneComunicazione IS NULL
            )
            OR (
                Categoria = 'Alloggio'
                AND ValutazioneComunicazione IS NULL
            )
        )
);