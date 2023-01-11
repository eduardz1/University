summatory :: Num a => [a] -> a
summatory = aux 0 
    where 
        aux n (x:xs) = 2^n * x + aux (n+1) xs
        aux _ [] = 0


summatoryp :: Num a => [a] -> a
summatoryp [] = 0
summatoryp xs = sum (zipWith (*) (map (2^) [0..]) xs)

ultimoPariLib :: Integral a => [a] -> Maybe a
-- ultimoPariLib = foldl aux Nothing
--     where
--         aux _ x | even x = Just x
--         aux ris _ = ris
ultimoPariLib = foldl (\acc x -> if even x then Just x else acc) Nothing

ultimoPari :: Integral a => [a] -> Maybe a
ultimoPari = aux Nothing
    where
        aux m [] = m
        aux m (x : xs) = if x `mod` 2 == 0 then aux (Just x) xs else aux m xs 

-- ritorna true se la prima lista è sottoinsieme della seconda
diversoLib :: Eq a => [a] -> [a] -> Bool
diversoLib xs ys = any (`notElem` ys) xs