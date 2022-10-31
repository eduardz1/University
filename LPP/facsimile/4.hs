summatory :: Num a => [a] -> a
summatory = aux 0 
    where 
        aux n (x:xs) = 2^n * x + aux (n+1) xs
        aux _ [] = 0


summatoryp :: Num a => [a] -> a
summatoryp [] = 0
summatoryp xs = sum (zipWith (*) (map (2^) [0..]) xs)