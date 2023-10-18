-- @block
SELECT DISTINCT attrezzo
FROM vocescheda
    JOIN esercizio ON(vocescheda.esercizio = esercizio.nome)
    JOIN utente ON(
        vocescheda.nome = utente.nome
        AND vocescheda.cognome = vocescheda.cognome
    )
WHERE utente.sesso = 'maschio'
    AND vocescheda.ordine <= 3
    AND esercizio.attrezzo IS NOT NULL
ORDER BY esercizio.attrezzo DESC;
-- @block
SELECT esercizio.attrezzo,
    AVG(vocescheda.durata)
FROM esercizio
    JOIN vocescheda ON(esercizio.nome = vocescheda.esercizio)
WHERE attrezzo IS NOT NULL
    AND vocescheda.numripetizioni <= 20
    AND esercizio.tipo = 'posturale'
GROUP BY esercizio.attrezzo;
-- @block
WITH attrezzo_tempo AS(
    SELECT attrezzo,
        SUM(vocescheda.durata) AS somma_durata
    FROM vocescheda
        JOIN esercizio ON(vocescheda.esercizio = esercizio.nome)
    WHERE attrezzo IS NOT NULL
        AND esercizio.tipo = 'aerobico'
    GROUP BY attrezzo
) WITH schede_con_un_solo_attrezzo AS(
    SELECT attrezzo
    FROM vocescheda
        JOIN esercizio ON (vocescheda.esercizio = esercizio.nome)
        JOIN utente ON (
            vocescheda.nome = utente.nome
            AND vocescheda.cognome = vocescheda.cognome
        )
    GROUP BY (utente.nome, utente.cognome)
    HAVING COUNT(DISTINCT attrezzo) = 1
)
SELECT attrezzo
FROM atrezzo_tempo
    JOIN schede_con_un_solo_attrezzo ON(
        attrezzo_tempo.attrezzo = schede_con_un_solo_attrezzo.attrezzo
    )
WHERE somma_durata = (
        SELECT MAX(somma_durata)
        FROM attrezzo_tempo
    );