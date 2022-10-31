insiemeDelleParti :: [a] -> [[a]]
insiemeDelleParti [] = [[]]
insiemeDelleParti (x : xs) = [x : sl | sl <- pippo] ++ pippo -- listeCon_x ++ listeSenza_x
    where
        pippo = insiemeDelleParti xs