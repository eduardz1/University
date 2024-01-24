-- @block initialize Utente
-- Superhost: Non si può essere superhost se non si è host
-- Verificato: Non si può essere verificati se non si ha la carta di identità
CREATE TABLE Utente (
    Nome VARCHAR(45) NOT NULL,
    Cognome VARCHAR(45) NOT NULL,
    Password VARCHAR(40) NOT NULL,
    Email VARCHAR(45),
    DataRegistrazione TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Host BOOLEAN DEFAULT FALSE NOT NULL,
    Superhost BOOLEAN DEFAULT FALSE NOT NULL,
    Verificato BOOLEAN DEFAULT FALSE NOT NULL,
    CartaIdentita VARCHAR(30),
    PRIMARY KEY (Email),
    Constraint user_valid_host CHECK (
        (
            Superhost = TRUE
            AND Host = TRUE
        )
        OR Superhost = FALSE
    ),
    Constraint user_valid_verified CHECK (
        (
            Verificato = TRUE
            AND CartaIdentita IS NOT NULL
        )
        OR Verificato = FALSE
    ),
    Constraint user_valid_email CHECK (
        email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
    )
);
