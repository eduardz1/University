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
delete x (Branch _ t Leaf) = t
delete x (Branch _ Leaf t) = t
delete x (Branch _ t₁ t₂)  = Branch y (delete y t₁) t₂
  where
    y = tmax t₁