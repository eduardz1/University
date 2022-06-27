-- @block
SELECT DISTINCT esercizio.tipo
FROM esercizio
    JOIN vocescheda ON(esercizio.nome = vocescheda.esercizio)
    JOIN utente ON(
        vocescheda.nome = utente.nome
        AND vocescheda.cognome = vocescheda.cognome
    )
WHERE utente.età >= 20
    AND utente.età <= 30
    AND utente.sesso = 'femmina';
-- @block
SELECT vocescheda.nome,
    vocescheda.cognome,
    AVG(vocescheda.durata)
FROM vocescheda
    JOIN esercizio ON(vocescheda.esercizio = esercizio.nome)
WHERE vocescheda.esercizio = 'aerobico'
GROUP BY vocescheda.nome,
    vocescheda.cognome
HAVING SUM(vocescheda.durata) > 60;
-- @block
WITH ultimo_esercizio AS(
    SELECT nome,
        cognome,
        numripetizione
    FROM vocescheda
    WHERE (nome, cognome, ordine) = (
            SELECT nome,
                cognome,
                MAX(ordine)
            FROM vocescheda
                JOIN esercizio ON(vocescheda.esercizio = esercizio.nome)
            WHERE attrezzo IS NULL
            GROUP BY nome,
                cognome
        )
)
SELECT nome,
    cognome
FROM ultimo_esercizio
WHERE numripetizioni = (
        SELECT MAX(numripetizioni)
        FROM ultimo_esercizio
    );