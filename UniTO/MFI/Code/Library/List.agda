module Library.List where

open import Library.Nat
open import Library.Logic

data List (A : Set) : Set where
  []   : List A
  _::_ : A -> List A -> List A

[_] : ∀{A : Set} -> A -> List A
[ x ] = x :: []

_++_ : ∀{A : Set} -> List A -> List A -> List A
[] ++ ys = ys
(x :: xs) ++ ys = x :: (xs ++ ys)

infixr 5 _::_ _++_

map : ∀{A B : Set} -> (A -> B) -> List A -> List B
map f []        = []
map f (x :: xs) = f x :: map f xs

reverse : ∀{A : Set} -> List A -> List A
reverse [] = []
reverse (x :: xs) = reverse xs ++ [ x ]

reverse-onto : ∀{A : Set} -> List A -> List A -> List A
reverse-onto []        ys = ys
reverse-onto (x :: xs) ys = reverse-onto xs (x :: ys)

fast-reverse : ∀{A : Set} -> List A -> List A
fast-reverse xs = reverse-onto xs []

length : ∀{A : Set} -> List A -> ℕ
length []        = 0
length (_ :: xs) = succ (length xs)

All : ∀{A : Set} -> (A -> Set) -> List A -> Set
All P [] = ⊤
All P (x :: xs) = P x ∧ All P xs

