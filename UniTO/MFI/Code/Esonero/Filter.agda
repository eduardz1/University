module Esonero.Filter where

open import Library.Nat
open import Library.Bool
open import Library.Equality
open import Library.LessThan
open import Library.List

{- 3 - LUNGHEZZA DELLE LISTE PRODOTTE DA filter

   ESERCIZIO 3-1

   Si definisca la funzione:
-}

filter : ∀{A : Set} → (A → Bool) → List A → List A
filter p [] = []
filter p (x :: xs) = if p x then x :: filter p xs else filter p xs

{- che data una funzione booleana su A, p : A → Bool ed una lista xs : List A
   restituisce la lista degli x in xs tali che p x == true, nell'ordine relativo
   in cui sono elencati in xs.
-}


{- ESERCIZIO 3-2

   Usando la relazione ≤, definita come <= nella libreria LessThan:
-}

infix 4 _≤_

_≤_ : ℕ → ℕ → Set
x ≤ y = x <= y

le-trans' : ∀{x y z : ℕ} → x ≤ y → y ≤ z → x ≤ z
le-trans' le-zero              _        = le-zero
le-trans' (le-succ hyp1) (le-succ hyp2) = le-succ (le-trans hyp1 hyp2)

{- si dimostri il teorema: -}

length-filter : ∀{A : Set} → (p : A → Bool) → (xs : List A) →
                length (filter p xs) ≤ length xs
length-filter p [] = le-zero
length-filter p (x :: xs) with p x
... | true = le-succ (length-filter p xs)
... | false = {! le-trans (length (filter p xs) <= length xs) (length xs <= succ (length xs)) !}
-- length (filter p xs) <= length xs per hp
-- length xs <= succ (length xs) per def di ℕ