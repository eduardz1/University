data Mossa = Sasso | Carta | Forbici
  deriving Show

vince :: Mossa -> Mossa -> Int
vince Sasso   Carta   = 2 -- vince il giocatore 2
vince Sasso   Forbici = 1 -- vince il giocatore 1
vince Carta   Sasso   = 1
vince Carta   Forbici = 2
vince Forbici Sasso   = 2
vince Forbici Carta   = 1
vince _       _       = 0 -- in tutti gli altri casi, parità

morra :: [Mossa] -> [Mossa] -> Int
morra [] [] = 0
morra _  [] = 1
morra [] _  = 2
morra (x : xs) (y : ys) | vincitore /= 0 = vincitore
                        | otherwise      = morra xs ys
  where
    vincitore = vince x y