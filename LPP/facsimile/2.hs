inversioni :: Ord a => [a] -> Int
inversioni [] = 0
inversioni [x] = 0
inversioni (x : y : xs) = if y > x then 1 + inversioni (y : xs) else inversioni (y : xs)

inversionip :: Ord a => [a] -> Int
-- inversionip [] = 0
-- inversionip [x] = 0
-- inversionip (x : xs) = length (filter (uncurry (<)) (zip (x : xs) xs))
inversionip xs = length (filter (uncurry (<)) (zip xs (tail xs)))