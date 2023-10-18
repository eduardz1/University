allLessThanFirstElem :: [Int] -> Bool
allLessThanFirstElem [] = True
allLessThanFirstElem (x : xs) = aux xs x
    where
        aux [] _ = True
        aux (z : zs) y | z < y     = aux zs y
                       | otherwise = False

allLessThanFirstElem' :: [Int] -> Bool
allLessThanFirstElem' [] = True
allLessThanFirstElem' xs = all (<= head xs) (tail xs)
