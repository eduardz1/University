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
succOrAbs n
  | even n = n + 1
  | otherwise = abs n

-- 2
giorni :: Int -> Int
giorni n
  | bisestile n = 366
  | otherwise = 365

bisestile :: Int -> Bool
bisestile n
  | n `mod` 4 == 0 && n `mod` 100 /= 0 = True
  | n `mod` 400 == 0 = True
  | otherwise = False

-- funzioni ricorsive esercizi

fattoriale :: Int -> Int
fattoriale n
  | n == 0 = 1
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
bits n
  | n == 0 = 0
  | even n = bits (n `div` 2)
  | otherwise = 1 + bits (n `div` 2)

--4
potenzaDi2 :: Int -> Bool
potenzaDi2 n
  | n == 0 = False
  | n == 1 = True
  | otherwise = even n && potenzaDi2 (n `div` 2)

-- dall'iterazione alla ricorsione

-- public static int fattoriale(int n) {
--     assert n >= 0;
--     int res = 1;
--     while (n > 0) {
--        res = res * n;
--        n = n - 1;
--     }
--     return res;
-- }

fattorialeR :: Int -> Int
fattorialeR = aux 1
  where
    aux res 0 = res
    aux res n = aux (res * n) (n - 1)

-- public static int bits(int n) {
--     assert n >= 0;
--     int bits = 0;
--     while (n > 0) {
--         bits = bits + n % 2;
--         n = n / 2;
--     }
--     return bits;
-- }

bitsR :: Int -> Int
bitsR = aux 0
  where
    aux bitss 0 = bitss
    aux bitss k = aux (bitss + k `mod` 2) (k `div` 2)

-- public static int euclide(int m, int n) {
--     assert m > 0 && n > 0;
--     while (m != n)
--         if (m < n) n -= m; else m -= n;
--     return n;
-- }

euclide :: Int -> Int -> Int
euclide m n
  | m == n = m
  | m < n = euclide m (n - m)
  | otherwise = euclide (m - n) n

quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x : xs) =
  quickSort (filter (< x) xs) ++ [x] ++ quickSort (filter (>= x) xs)

media :: [Int] -> Float
media xs = fromIntegral (sum xs) / fromIntegral (length xs) -- qui non va bene usare il `div` perché non stiamo dividendo due interi

fattorialeL :: Int -> Int
fattorialeL n = product [2 .. n]

intervallo :: Int -> Int -> [Int]
intervallo m n
  | m > n = []
  | otherwise = m : intervallo (m + 1) n -- oppure semplicemente = [m..n]

primo :: Int -> Bool
primo n = aux 2
  where
    aux k
      | k >= n = k == n
      | n `mod` k == 0 = False
      | otherwise = aux (k + 1)

primi :: Int -> [Int]
primi n = aux 2
  where
    aux k
      | k > n = []
      | primo k = k : aux (k + 1)
      | otherwise = aux (k + 1)

inverti :: [Int] -> [Int]
inverti [] = []
inverti (x : xs) = inverti xs ++ [x]

sommaCongiunta :: [Int] -> [Int] -> [Int]
sommaCongiunta [] [] = []
sommaCongiunta _ [] = []
sommaCongiunta [] _ = []
sommaCongiunta (x : xs) (y : ys) = x + y : sommaCongiunta xs ys