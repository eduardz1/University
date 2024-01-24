INSERT INTO Utente (Nome, Cognome, Email, Password, Host, SuperHost)
VALUES (
        'Marco',
        'Molica',
        'marco.molica@ehostone.it',
        'a',
        FALSE,
        TRUE
    );
-- L'utente non viene creato perchè questa query di insert viola il vincolo aggiunto in fase di DDL per cui un utente non può essere un superhost se non è un host
INSERT INTO Utente (Nome, Cognome, Email, Password, Verificato)
VALUES (
        'Marco',
        'Molica',
        'marco.molica@verificatone.it',
        'a',
        TRUE
    );
-- L'utente non viene creato perchè questa query di insert viola il vincolo aggiunto in fase di DDL per cui un utente può risultare verificato solamente se ha una carta di identità valida
INSERT INTO Prenotazione (
        Richiedente,
        IDAlloggio,
        DataInizio,
        DataFine,
        NumeroOspiti
    )
VALUES (
        'iman.solaih@edu.unito.to',
        '97c645ea-e19c-411c-8539-5d21def970cc',
        '2022-10-06',
        '2021-10-13',
        0
    );
-- La prenotazione non viene creata perchè viene violato il vincolo per cui la prenotazione deve avere una data di inizio coerente con la data di fine
INSERT INTO Recensione (
        IDPrenotazione,
        Autore,
        DataRecensione,
        Corpo,
        ValutazionePosizione,
        Categoria
    )
VALUES (
        '12af2073-3418-4a7a-8b2c-e9f91f2234ed',
        'eduard.occhipinti@edu.unito.to',
        '2022-01-05',
        'Marco è stato un grande ospite, mi ha aiutato in tutti i progetti',
        5,
        'Utente'
    );
-- La recensione non viene creata perchè viene violato il vincolo di categoria per cui una recensione fatta ad utente non deve avere valutazioni
DELETE FROM Alloggio
WHERE IDAlloggio = '97c645ea-e19c-411c-8539-5d21def970cc';
-- In questo il DBMS ci permetterà di effettuare la cancellazione, però eliminerà tutti i record nella tabella Contenuto che fanno riferimento a questo alloggio.
-- Tutte le prenotazioni che fanno riferimento a questo alloggio riceveranno un update all'attributo IDAlloggio con NULL, per il vincolo ON DELETE SET NULL aggiunto in fase di DDL.
UPDATE Utente
SET email = 'mmolica@edu.unito.to'
WHERE Email = 'marco.molica@edu.unito.to' -- In questo caso l'aggiornamento dell'attributo email comporterà l'aggiornamento a cascata di tutte le tabelle dove è presente una relazione con l'attributo email, per via della clausola ON UPDATE CASCADE.