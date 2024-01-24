-- @block initialize the database
-- CREATE DATABASE home_booking;
DROP TABLE IF EXISTS Utente,
    Telefono,
    Pagamento,
    Prenotazione,
    Alloggio,
    Recensione,
    Commento,
    Lista,
    Contenuto,
    Servizio,
    Foto;
DROP TYPE IF EXISTS StatoPrenotazione,
    CategoriaRecensione,
    TipologiaAlloggio;
    
     
-- @block initialize the enums
CREATE TYPE StatoPrenotazione AS ENUM (
    'Prenotato',
    'Confermato',
    'Rifiutato',
    'Cancellato',
    'Cancellato dall" host'
);
CREATE TYPE TipologiaAlloggio AS ENUM (
    'Appartamento',
    'Stanza singola',
    'Stanza condivisa'
);
CREATE TYPE CategoriaRecensione AS ENUM ('Host', 'Utente', 'Alloggio');