module Inequality where

open import Library.Bool
open import Library.Nat
open import Library.Logic
open import Library.Equality
open import Library.Nat.Properties

infix 4 _<=_

data _<=_ : ℕ -> ℕ -> Set where
  le-zero : ∀{x : ℕ} -> 0 <= x
  le-succ : ∀{x y : ℕ} -> x <= y -> succ x <= succ y

--                                     x <= y
-- [le-zero] ------    [le-succ] --------------
--           0 <= x              1 + x <= 1 + y

_<=ₘ_ : ℕ -> ℕ -> Set
x <=ₘ y = ∃[ z ] x + z == y

le-correct : ∀{x y : ℕ} -> x <= y -> x <=ₘ y
le-correct le-zero = _ , refl
le-correct (le-succ le) with le-correct le
... | z , refl = z , refl

le-complete : ∀{x y : ℕ} -> x <=ₘ y -> x <= y
le-complete (z , refl) = lemma
    where
        lemma : ∀{x y : ℕ} -> x <= x + y
        lemma {zero}   = le-zero
        lemma {succ x} = le-succ lemma

-- Dimostrazione che la relazione <= è un ordine parziale
le-refl : ∀{x : ℕ} -> x <= x
le-refl {zero}   = le-zero
le-refl {succ x} = le-succ le-refl

le-antisymm : ∀{x y : ℕ} -> x <= y -> y <= x -> x == y
le-antisymm le-zero le-zero = refl
le-antisymm (le-succ hp₁) (le-succ hp₂) rewrite le-antisymm hp₁ hp₂ = refl

le-trans : ∀{x y z : ℕ} -> x <= y -> y <= z -> x <= z
le-trans le-zero _ = le-zero
le-trans (le-succ hp₁) (le-succ hp₂) = le-succ (le-trans hp₁ hp₂)

-- TODO: dimostrare che <= è una pre-congruenza ossia la somma è monotona
<=-cong : ∀{x y z : ℕ} -> x <= y -> x + z <= y + z
<=-cong le-zero = lemma
    where
        lemma : ∀{z y : ℕ} -> z <= y + z
        lemma {zero} = le-zero
        lemma {succ z} = {!   !}
<=-cong (le-succ hp) = le-succ (<=-cong hp)

-- La relazione <= è totale
le-total : ∀{x y : ℕ} -> x <= y ∨ y <= x
le-total {zero}   {_}      = inl le-zero
le-total {succ x} {zero}   = inr le-zero
le-total {succ x} {succ y} with le-total {x} {y}
... | inl x≤y = inl (le-succ x≤y)
... | inr y≤x = inr (le-succ y≤x)
