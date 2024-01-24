-- @block Dump dei dati per la tabella Utente --
INSERT INTO Utente (Nome, Cognome, Email, Password, Host)
VALUES (
                'Marco',
                'Molica',
                'marco.molica@edu.unito.to',
                'a',
                TRUE
        );
INSERT INTO Utente (Nome, Cognome, Email, Password)
VALUES (
                'Iman',
                'Solaih',
                'iman.solaih@edu.unito.to',
                'a'
        );
INSERT INTO Utente (Nome, Cognome, Email, Password, Host)
VALUES (
                'Eduard',
                'Occhipinti',
                'eduard.occhipinti@edu.unito.to',
                'a',
                TRUE
        );
INSERT INTO Utente (Nome, Cognome, Email, Password)
VALUES (
                'Host',
                'Incredibile',
                'host.incredibile@edu.unito.to',
                'a'
        );
INSERT INTO Utente (Nome, Cognome, Email, Password)
VALUES (
                'Host',
                'Sensazionale',
                'host.sensazionale@edu.unito.to',
                'a'
        );
INSERT INTO Utente (Nome, Cognome, Email, Password)
VALUES (
                'Super',
                'Hostone',
                'superhostone@edu.unito.to',
                'a'
        );
-- @block Dump dei dati per la tabella Telefono --
INSERT INTO Telefono (Utente, Numero, Prefisso)
VALUES ('marco.molica@edu.unito.to', '3465432121', '+39');
INSERT INTO Telefono (Utente, Numero, Prefisso)
VALUES ('marco.molica@edu.unito.to', '3392516621', '+39');
-- @block Dump dei dati per la tabella Pagamento --
INSERT INTO Pagamento (Utente, Numero, Prefisso)
VALUES (
                'marco.molica@edu.unito.to',
                '0000012345678901',
                'Visa'
        );
INSERT INTO Pagamento (Utente, Numero, Prefisso)
VALUES (
                'iman.solaih@edu.unito.to',
                '2141512512231231',
                'American Express'
        );
-- @block Dump dei dati per la tabella Alloggio --
INSERT INTO Alloggio (
                IDAlloggio,
                Nome,
                Host,
                Descrizione,
                Tipologia,
                OrarioCheckIn,
                OrarioCheckOut,
                Costo,
                CostoPulizia,
                CAP,
                Comune,
                Civico,
                Via
        )
VALUES (
                '97c645ea-e19c-411c-8539-5d21def970cc',
                'Casa di Emme',
                'marco.molica@edu.unito.to',
                'Un alloggio sempre disponibile per lo studio in compagnia e la realizzazione del progetto di db',
                'Appartamento',
                '18:00:00',
                '23:59:00',
                1,
                0,
                10129,
                'Torino',
                3,
                'Via Peano'
        );
INSERT INTO Alloggio (
                IDAlloggio,
                Nome,
                Host,
                Descrizione,
                Tipologia,
                OrarioCheckIn,
                OrarioCheckOut,
                Costo,
                CostoPulizia,
                CAP,
                Comune,
                Civico,
                Via
        )
VALUES (
                'e3084a88-a6fc-42bb-8a00-4c24f07229b6',
                'Casa di Eduard',
                'eduard.occhipinti@edu.unito.to',
                'Stanza molto tranquilla e confortevole, ottima per studenti del dipartimento di informatica',
                'Stanza condivisa',
                '09:00:00',
                '22:00:00',
                10,
                5,
                10129,
                'Torino',
                12,
                'Via non ricordo indirizzo'
        );
-- @block Dump dei dati per la tabella Prenotazione --
INSERT INTO Prenotazione (
                IDPrenotazione,
                Richiedente,
                IDAlloggio,
                DataInizio,
                DataFine,
                NumeroOspiti,
                Stato
        )
VALUES (
                '9a0d4e3f-0e1e-49b5-838a-b9521c794e6f',
                'marco.molica@edu.unito.to',
                'e3084a88-a6fc-42bb-8a00-4c24f07229b6',
                '2022-01-05',
                '2023-01-05',
                0,
                'Confermato'
        );
INSERT INTO Prenotazione (
                IDPrenotazione,
                Richiedente,
                IDAlloggio,
                DataInizio,
                DataFine,
                NumeroOspiti,
                Stato,
                Soggiorno
        )
VALUES (
                '12af2073-3418-4a7a-8b2c-e9f91f2234ed',
                'marco.molica@edu.unito.to',
                'e3084a88-a6fc-42bb-8a00-4c24f07229b6',
                '2021-01-01',
                '2022-01-01',
                0,
                'Confermato',
                TRUE
        );
INSERT INTO Prenotazione (
                IDPrenotazione,
                Richiedente,
                IDAlloggio,
                DataInizio,
                DataFine,
                NumeroOspiti
        )
VALUES (
                '99acbb6b-9f4e-4234-a49d-a27acd0f0173',
                'iman.solaih@edu.unito.to',
                '97c645ea-e19c-411c-8539-5d21def970cc',
                '2022-10-06',
                '2023-10-13',
                0
        );
-- @block Dump dei dati per la tabella Recensione --
INSERT INTO Recensione (
                IDRecensione,
                IDPrenotazione,
                Autore,
                DataRecensione,
                ValutazionePosizione,
                ValutazionePulizia,
                Corpo,
                Categoria
        )
VALUES (
                'e6ff4eb7-c7cb-4f3e-b59e-267544c984a2',
                '12af2073-3418-4a7a-8b2c-e9f91f2234ed',
                'marco.molica@edu.unito.to',
                '2022-01-05',
                4,
                5,
                'Ottima casa, ci tornerò',
                'Alloggio'
        );
INSERT INTO Recensione (
                IDRecensione,
                IDPrenotazione,
                Autore,
                DataRecensione,
                ValutazioneComunicazione,
                Corpo,
                Categoria
        )
VALUES (
                '14155146-d619-41dd-8aca-fd789262287d',
                '12af2073-3418-4a7a-8b2c-e9f91f2234ed',
                'marco.molica@edu.unito.to',
                '2022-01-05',
                2,
                'Ho avuto molte difficoltà a comunicare con Eduard perchè parla spesso russo',
                'Host'
        );
INSERT INTO Recensione (
                IDRecensione,
                IDPrenotazione,
                Autore,
                DataRecensione,
                Corpo,
                Categoria
        )
VALUES (
                '16ffe4b2-b4e6-45cb-86e1-5402b28d372d',
                '12af2073-3418-4a7a-8b2c-e9f91f2234ed',
                'eduard.occhipinti@edu.unito.to',
                '2022-01-05',
                'Marco è stato un grande ospite, mi ha aiutato in tutti i progetti',
                'Utente'
        );
-- @block Dump dei dati per la tabella Commento --
INSERT INTO Commento (IDrecensione, DataCommento, Autore, Corpo)
VALUES (
                'e6ff4eb7-c7cb-4f3e-b59e-267544c984a2',
                '2022-01-06 12:04:21',
                'eduard.occhipinti@edu.unito.to',
                'Sono molto contento che sia stato tutto di tuo gradimento'
        );
INSERT INTO Commento (IDrecensione, DataCommento, Autore, Corpo)
VALUES (
                'e6ff4eb7-c7cb-4f3e-b59e-267544c984a2',
                '2022-01-06 13:01:18',
                'marco.molica@edu.unito.to',
                'Grazie, lo sono anche io'
        );
-- @block Dump dei dati per la tabella Commento --
INSERT INTO Lista (IDLista, Nome, Descrizione, Autore)
VALUES (
                '14e9d1b4-7144-4e9f-9ec2-571432ef2068',
                'Lista1',
                'Lista di prova',
                'marco.molica@edu.unito.to'
        );
-- @block Dump dei dati per la tabella Contenuto --
INSERT INTO Contenuto (IDLista, IDAlloggio)
VALUES (
                '14e9d1b4-7144-4e9f-9ec2-571432ef2068',
                '97c645ea-e19c-411c-8539-5d21def970cc'
        );
INSERT INTO Contenuto (IDLista, IDAlloggio)
VALUES (
                '14e9d1b4-7144-4e9f-9ec2-571432ef2068',
                'e3084a88-a6fc-42bb-8a00-4c24f07229b6'
        );
-- @block Dump dei dati per la tabella Foto --
INSERT INTO Foto (IDAlloggio, Path)
VALUES (
                '97c645ea-e19c-411c-8539-5d21def970cc',
                'http://www.unito.it/wp-content/uploads/2017/01/unito-logo.png'
        );
-- @block Dump dei dati per la tabella Foto --
INSERT INTO Servizio (IDAlloggio, TipoServizio)
VALUES ('97c645ea-e19c-411c-8539-5d21def970cc', 'Wifi');
INSERT INTO Servizio (IDAlloggio, TipoServizio)
VALUES (
                '97c645ea-e19c-411c-8539-5d21def970cc',
                'Animali ammessi'
        );