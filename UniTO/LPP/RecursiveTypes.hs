maybeLength :: Maybe a -> Int
maybeLength Nothing  = 0
maybeLength (Just _) = 1

maybeMap :: (a -> b) -> Maybe a -> Maybe b
maybeMap _ Nothing  = Nothing
maybeMap f (Just x) = Just (f x)

maybeFilter :: (a -> Bool) -> Maybe a -> Maybe a
maybeFilter p (Just x) | p x = Just x
maybeFilter _ _              = Nothing

somma :: Either Int Float -> Either Int Float -> Either Int Float
somma (Left m)  (Left n)  = Left (m + n)
somma (Left m)  (Right n) = Right (fromIntegral m + n)
somma (Right m) (Left n)  = Right (m + fromIntegral n)
somma (Right m) (Right n) = Right (m + n)

data List a = Nil | Cons a (List a)
    deriving Show

lengthL :: List a -> Int
lengthL Nil        = 0
lengthL (Cons _ a) = 1 + lengthL a

data Stream a = ConS a (Stream a)

forever :: a -> Stream a
forever x = ConS x (forever x)

from :: Enum a => a -> Stream a
from x = ConS x (from (succ x))

takeS :: Int -> Stream a -> [a]
takeS 0 _ = []
takeS n (ConS e s) = e : takeS (n - 1) s