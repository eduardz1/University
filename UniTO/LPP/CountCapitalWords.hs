count :: String -> Int
count w = length filter w
    where
        filter w = [ x | x <- words w, let v = toUpper x, x == v]