import GHC.IO.FD (stdout)
data Tree a = Empty | Node a [Tree a]

elements :: Tree a -> [a]
-- prints erorr on stdout
elements Empty = error "Empty tree"
elements (Node a ts) = a : concatMap elements ts

normalize :: Tree a -> Tree a
normalize Empty = Empty
normalize (Node a ts) = Node a (concatMap (aux . normalize) ts)
    where
        aux Empty = []
        aux t = [t]