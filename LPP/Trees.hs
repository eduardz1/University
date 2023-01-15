-- https://boystrange.github.io/LPP/Alberi

data Tree a = Leaf | Branch a (Tree a) (Tree a)
    deriving Show

empty :: Tree a -> Bool
empty Leaf = True
empty _    = False

depth :: Tree a -> Int
depth Leaf             = 0
depth (Branch _ t₁ t₂) = 1 + max (depth t₁) (depth t₂)

elements :: Tree a -> [a]
elements Leaf             = []
elements (Branch x t₁ t₂) = elements t₁ ++ [x] ++ elements t₂

-- returns the biggest element in a binary search tree
tmax :: Tree a -> a
tmax Leaf              = error "tmax: empty tree"
tmax (Branch x _ Leaf) = x
tmax (Branch _ _ t)    = tmax t

-- insert for a binary search tree
insert :: Ord a => a -> Tree a -> Tree a
insert x Leaf = Branch x Leaf Leaf
insert x t@(Branch y t₁ t₂) | x == y    = t
                            | x < y     = Branch y (insert x t₁) t₂
                            | otherwise = Branch y t₁ (insert x t₂)

-- delete for a binary search tree
delete :: Ord a => a -> Tree a -> Tree a
delete _ Leaf = Leaf
delete x (Branch y t₁ t₂) | x < y = Branch y (delete x t₁) t₂
                          | x > y = Branch y t₁ (delete x t₂)
delete _ (Branch _ t Leaf) = t
delete _ (Branch _ Leaf t) = t
delete _ (Branch _ t₁ t₂)  = Branch y (delete y t₁) t₂
  where
    y = tmax t₁

tmin :: Tree a -> a
tmin Leaf              = error "tmin : empty tree"
tmin (Branch x Leaf _) = x
tmin (Branch _ _ t)    = tmin t

tminT :: Tree a -> Maybe a
tminT Leaf              = Nothing
tminT (Branch x Leaf _) = Just x
tminT (Branch _ _ t)    = tminT t

treeSort :: Ord a => [a] -> [a]
treeSort = elements . foldr insert Leaf

bst :: Ord a => Tree a -> Bool
bst Leaf = True
bst (Branch x t₁ t₂) = bst t₁ && bst t₂ &&
                       (empty t₁ || tmax t₁ < x) &&
                       (empty t₂ || x < tmin t₂)