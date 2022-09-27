import Distribution.Simple.Setup (falseArg)
-- orbite

annoTerra :: Float
annoTerra = 2 * pi * 150e6

vTerra :: Float
vTerra = annoTerra / (365 * 24)

annoMercurio :: Float
annoMercurio = 2 * pi * 58e6

vMercurio :: Float
vMercurio = annoMercurio / (88 * 24)

-- Fibonacci

f0 :: Int
f0 = 0

f1 :: Int
f1 = 1

f2 :: Int
f2 = f0 + f1

f3 :: Int
f3 = f1 + f2

f4 :: Int
f4 = f2 + f3

f5 :: Int
f5 = f3 + f4

f6 :: Int
f6 = f4 + f5

f7 :: Int
f7 = f5 + f6

-- funzioni con guardie, esercizi
-- 1
succOrAbs :: Int -> Int
succOrAbs n | even n = n + 1
            | otherwise = abs n

-- 2
giorni :: Int -> Int
giorni n | bisestile n = 366
         | otherwise = 365

bisestile :: Int -> Bool
bisestile n | n `mod` 4 == 0 && n `mod` 100 /= 0 = True
            | n `mod` 400 == 0 = True
            | otherwise = False

-- funzioni ricorsive esercizi

fattoriale :: Int -> Int
fattoriale n | n == 0 = 1
             | otherwise = n * fattoriale (n - 1)

fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n - 1) + fibonacci (n - 2)

--1
sommatoria :: Int -> Int
sommatoria 0 = 0
sommatoria n = n + sommatoria (n - 1)

--2
pow2 :: Int -> Int
pow2 0 = 1
pow2 n = 2 * pow2 (n - 1)

--3
bits :: Int -> Int
bits n | n == 0 = 0
       | even n = bits (n `div` 2)
       | otherwise = 1 + bits (n `div` 2)

--4
potenzaDi2 :: Int -> Bool
potenzaDi2 n | n == 0 = False
             | n == 1 = True
             | otherwise = even n && potenzaDi2 (n `div` 2)