data ForseInt = Niente | Proprio Int
  deriving Show

testa :: [Int] -> ForseInt
testa [] = Niente
testa (x : _) = Proprio x

data Numero = I Int | F Float
    deriving Show

somma :: Numero -> Numero -> Numero
somma (I x) (I y) = I (x + y)
somma (I m) (F n) = F (fromIntegral m + n)
somma (F m) (I n) = F (m + fromIntegral n)
somma (F m) (F n) = F (m + n)

sommatoria :: [Numero] -> Numero
sommatoria = foldr somma (I 0)

proprio :: [ForseInt] -> [Int]
proprio [] = []
proprio (Niente : xs) =  proprio xs
proprio (Proprio x : xs) = x : proprio xs