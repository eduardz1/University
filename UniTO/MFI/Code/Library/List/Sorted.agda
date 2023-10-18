module Library.List.Sorted (A : Set) (_≼_ : A -> A -> Set) where

open import Library.List
open import Library.Logic

-- infix 4 _≼*_ _*≼_

-- _≼*_ : A -> List A -> Set
-- x ≼* xs = all (x ≼_) xs

-- _*≼_ : List A -> A -> Set
-- xs *≼ x = all (_≼ x) xs

-- Sorted : List A -> Set
-- Sorted [] = ⊤
-- Sorted (x :: xs) = x ≼* xs ∧ Sorted xs

Sorted : List A -> Set
Sorted [] = ⊤
Sorted (x :: xs) = All (x ≼_) xs ∧ Sorted xs
