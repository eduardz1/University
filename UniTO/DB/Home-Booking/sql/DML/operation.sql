-- @block Calcolo per aggiornare il tasso di cancellazione di ciascun host che abbia effettuato almeno un soggiorno
WITH ElencoPrenotazioni as (
  SELECT Prenotazione.Stato as Stato,
    Utente.Email as Host
  FROM prenotazione
    INNER JOIN Alloggio on prenotazione.IDAlloggio = alloggio.idalloggio
    INNER JOIN Utente on Alloggio.Host = Utente.Email
  WHERE Utente.Host = TRUE
)
SELECT Host,
  Count(*) as Totale,
  Count(*) FILTER (
    WHERE Stato = 'Cancellato dall" host'
  ) as Cancellato,
  ROUND(
    (
      Count(*) FILTER (
        WHERE Stato = 'Cancellato dall" host'
      ) / Count(*)::numeric
    ) * 100,
    2
  ) as PercentualeCancellati
FROM ElencoPrenotazioni
GROUP BY Host;


-- @block Calcolo del numero di soggiorni di ogni host che abbia effettuato almeno un soggiorno
WITH ElencoPrenotazioni as (
  SELECT Prenotazione.DataInizio as DStart,
    Prenotazione.DataFine as DEnd,
    Prenotazione.Soggiorno,
    Prenotazione.Stato as Stato,
    Utente.Email as Host
  FROM prenotazione
    INNER JOIN Alloggio on prenotazione.IDAlloggio = alloggio.idalloggio
    INNER JOIN Utente on Alloggio.Host = Utente.Email
  WHERE Utente.Host = TRUE
    AND Soggiorno = TRUE
)
SELECT Host,
  SUM (DEnd::Date - DStart::Date) AS GiorniTotali,
  Count(*) As Soggiorni
FROM ElencoPrenotazioni
GROUP BY Host;