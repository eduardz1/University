es1 :: [a] -> [a]
es1 [] = []
es1 [x] = [x]
es1 (x : y : xs) = x : es1 xs

es2 :: [a] -> [a]
es2 xs = map snd (filter (even . fst) (zip [0..] xs))