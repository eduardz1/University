
import Data.Bifunctor
import Data.List

{-
Definire una funzione che, applicata a una lista di numeri di tipo Int,
restituisca una coppia le cui componenti sono il prodotto e la somma degli
elementi diversi da 0, rispettivamente. Non è consentito fare uso di funzioni
della libreria standard ad eccezione di min, max, div fst, snd e di quelle che
hanno un nome simbolico, come +, ., ecc.
-}

prodSum :: Integral a => [a] -> (a, a)
prodSum [] = (1, 0)
prodSum (x : xs) | x /= 0    = bimap (x *) (x +) (prodSum xs)
                 | otherwise = prodSum xs

prodSum' :: Integral a => [a] -> (a, a)
prodSum' xs = aux xs 1 0
    where
        aux [] p s = (p, s)
        aux (x : xss) p s | x /= 0    = aux xss (p * x) (s + x)
                          | otherwise = aux xss p s

prodSum'' :: Integral a => [a] -> (a, a)
prodSum'' xs = (product [ x | x <- xs, x /= 0], sum [ x | x <- xs, x /= 0])

prodSum''' :: Integral a => [a] -> (a, a)
prodSum''' xs = (product ps, sum ss)
    where
        (ps, ss) = unzip [ (x, x) | x <- xs, x /= 0]

{-
Definire una funzione f che , applicata a una lista di numeri di tipo Float,
restituiscre una coppia le cui componenti sono la lista dei reciroci dei numeri
non nulli ed il numeri di quelli nulli, rispettivamente. Non è consentito 
l'uso esplicito della ricorsione, ma si possono usare list comprehension e tutte
le funzioni definite nel modulo Prelude
-}

recZero :: (Fractional a, Eq a) => [a] -> ([a], Int)
recZero xs = ([ 1 / x | x <- xs, x /= 0], length [ x | x <- xs, x == 0])

recZero' :: (Fractional a, Eq a) => [a] -> ([a], Int)
recZero' xs = (map (1 /) (filter (/= 0) xs), length (filter (== 0) xs))

recZero'' :: (Fractional a, Eq a) => [a] -> ([a], Int)
recZero'' xs = (map (1 /) ps, length zs)
    where
        (ps, zs) = partition (/= 0) xs

recZero''' :: (Fractional a, Eq a) => [a] -> ([a], Int)
recZero''' [] = ([], 0)
recZero''' (x : xs) | x /= 0    = first ((1 / x) :) (recZero''' xs)
                    | otherwise = second (1 +) (recZero''' xs)

{-
Definire una funzione che, applicata a una lista non vuota di coppie di numeri
interi compresi tra 0 e 30, calcoli la media artimetica della seconda componente
delle coppie la cui rima componente è maggiore o uguale a 18. Risolvere 
l'esercizio senza fare uso di list comprehension e funzioni della libreria 
standard ad eccezione degli operatori relazionali <, <=, ... e di + e div
-}

media :: [(Int, Int)] -> Int
media xs = aux xs 0 1
    where
        aux [] acc l = acc `div` l
        aux ((x, y) : _) acc l | x >= 18   = aux xs (acc + y) (l + 1)
                               | otherwise = aux xs acc l

media' :: [(Int, Int)] -> Int
media' [] = 0
media' xs = sum [ y | (x, y) <- xs, x >= 18] `div` length [ y | (x, y) <- xs, x >= 18]

{-
Definire una funzione che, applicata a una lista xs, resituisca la sotto-lista 
contenente tutti e soli gli elementi di xs in posizione pari, nello stesso 
ordine in cui compaiono in xs e assumendo che il primo elemento della lista si 
trovi in posizione 0. È vietato l'uso esplicito della ricorsione, ma si possono
usare tutte le funzioni definite nel modulo Prelude
-}

pari :: [a] -> [a]
pari xs = [ x | (x, y) <- zip xs [0..], even y ]

pari' :: [a] -> [a]
pari' xs = map fst (filter (even . snd) $ zip xs [0..])

pari'' :: [a] -> [a]
pari'' []           = []
pari'' [ x ]        = [ x ]
pari'' (x : _ : xs) = x : pari'' xs
