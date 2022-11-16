es1 :: [a] -> [a]
es1 (x : _ : xs) = x : es1 xs
es1 xs = xs

es2 :: [a] -> [a]
es2 xs = map snd (filter (even . fst) (zip [0..] xs))