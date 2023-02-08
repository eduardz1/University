{-
Dato il tipo algebrico

data Tree a = Empty | Node a [Tree a]

per rappresentare alberi n-ari, diciamo che un albero è in forma normale se è 
Empty oppure se è costruito senza usare Empty. 
Definire una funzione
normalize :: Tree a -> Tree a

che trasformi un albero in forma normale, usando la ricorsione solo laddove è 
necessario e sfruttando il più possibile le funzioni del modulo Prelude. 
Se opportuno, è ammessa la definizione di funzioni ausiliarie.
-}

data Tree a = Empty | Node a [Tree a]

normalize :: Tree a -> Tree a
normalize Empty = Empty
normalize (Node a ts) = Node a (filter aux (map normalize ts))
   where
       aux Empty = False
       aux _ = True

{-
Definire una funzione che, applicata a una lista xs, restituisca la sotto-lista 
contenente tutti e soli gli elementi di xs in posizione pari, nello stesso 
ordine in cui compaiono in xs e assumendo che il primo elemento della lista si 
trovi in posizione 0. 
È vietato l’uso esplicito della ricorsione, ma si possono usare tutte le 
funzioni definite nel modulo Prelude.
-}
evenPositions :: [a] -> [a]
evenPositions xs = map snd (filter (even . fst) (zip [0..] xs))

{-
Definire una funzione inversioni che, applicata a una lista xs, 
calcoli il numero di inversioni di xs, ovvero il numero di elementi di xs 
immediatamente seguiti da un elemento più piccolo. 
È vietato fare uso esplicito della ricorsione, ma si possono usare tutte le 
funzioni definite nel modulo Prelude.
-}
inversioni :: Integral a => [a] -> Int
inversioni xs = length (filter (uncurry (>)) (zip xs (tail xs)))

{-
Definire una funzione di tipo

Integral a => [a] -> Maybe a

che trovi, se c’è, l’ultimo numero pari in una lista di numeri interi. 
È vietato fare uso esplicito della ricorsione, 
ma si possono usare tutte le funzioni definite nel modulo Prelude.
-}
lastEven :: Integral a => [a] -> Maybe a
lastEven = foldl (\acc x -> if even x then Just x else acc) Nothing

{-
Definire una funzione di tipo

Eq a => [a] -> [a] -> Bool

che, applicata a due list xs e ys, determini se esiste un elemento di xs che è 
diverso da ogni elemento di ys. 
È vietato fare uso esplicito della ricorsione, ma si possono usare tutte 
le funzioni definite nel modulo Prelude.
-}
unique :: Eq a => [a] -> [a] -> Bool
unique xs ys = any (`notElem` ys) xs

{-
Definire una funzione che, applicata a una lista xs, restituisca la sotto-lista
contenente tutti e soli gli elementi di xs in posizione pari, nello stesso 
ordine in cui compaiono in xs e assumendo che il primo elemento della lista si 
trovi in posizione 0. 
È vietato fare uso di funzioni della libreria standard ad eccezione di mod e 
quelle che hanno un nome simbolico, come +, ., ecc.
-}
evenPositionsNoLib :: [a] -> [a]
evenPositionsNoLib [] = []
evenPositionsNoLib [x] = [x]
evenPositionsNoLib (x : y : xs) = x : evenPositionsNoLib xs

{-
Definire una funzione inversioni che, applicata a una lista xs, calcoli il 
numero di inversioni di xs, ovvero il numero di elementi di xs immediatamente 
seguiti da un elemento più piccolo. È vietato fare uso di funzioni della 
libreria standard ad eccezione di mod e quelle che hanno un nome simbolico, 
come +, ., ecc. Fare in modo che inversioni abbia il tipo più generale possibile.
-}
inversioniNoLib :: Ord a => [a] -> Int
inversioniNoLib [] = 0
inversioniNoLib [x] = 0
inversioniNoLib (x : y : xs) | x > y = 1 + inversioniNoLib xs
                             | otherwise = inversioniNoLib xs

{-
Dato il tipo algebrico

data Tree a = Empty | Node a [Tree a]

per rappresentare alberi n-ari, definire una funzione
elements :: Tree a -> [a]

che calcoli la lista di tutti gli elementi contenuti nell’albero in un ordine a 
scelta. Usare la ricorsione solo laddove necessario, sfruttando il più 
possibile le funzioni del modulo Prelude.
-}
elements :: Tree a -> [a]
elements Empty = []
elements (Node a ts) = a : concatMap elements ts

{-
Definire una funzione di tipo

Integral a => [a] -> Maybe a

che trovi, se c’è, l’ultimo numero pari in una lista di numeri interi. 
È vietato fare uso di funzioni della libreria standard ad eccezione di mod e 
quelle che hanno un nome simbolico, come +, ., ecc.
-}
lastEvenNoLib :: Integral a => [a] -> Maybe a
lastEvenNoLib = aux Nothing
    where
        aux m [] = m
        aux m (x : xs) = if x `mod` 2 == 0 then aux (Just x) xs else aux m xs

{-
Definire una funzione di tipo

Eq a => [a] -> [a] -> Bool

che, applicata a due list xs e ys, determini se esiste un elemento di xs che è 
diverso da ogni elemento di ys. 
È vietato fare uso di funzioni della libreria standard ad eccezione quelle che 
hanno un nome simbolico, come +, ., ecc.
-}
uniqueNoLib :: Eq a => [a] -> [a] -> Bool
uniqueNoLib [] _ = False
uniqueNoLib _ [] = True -- not needed but faster this way
uniqueNoLib (x : xs) ys = check x ys || uniqueNoLib xs ys
    where
        check _ [] = True
        check z (w : ws) = z /= w && check z ws

{-
a function that takes a base 8 number represented as an array of numbers from 0 to 7 as a parameter and returns the same number in base 10
-}
dieci :: [Int] -> Int
dieci = foldl (\acc x -> acc * 8 + x) 0

dieci' :: [Int] -> Int
dieci' = aux 0
    where
        aux acc [] = acc
        aux acc (x : xs) = aux (acc * 8 + x) xs
