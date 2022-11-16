module Library.LessThan where

open import Library.Nat
open import Library.Nat.Properties
open import Library.Logic
open import Library.Logic.Laws
open import Library.Equality

infix 4 _<=_ _>=_ _<_ _>_

data _<=_ : ℕ -> ℕ -> Set where
  le-zero : {x : ℕ}   -> 0 <= x
  le-succ : {x y : ℕ} -> x <= y -> succ x <= succ y

_>=_ : ℕ -> ℕ -> Set
x >= y = y <= x

le-refl : {n : ℕ} -> n <= n
le-refl {zero}   = le-zero
le-refl {succ _} = le-succ le-refl

le-antisymm : {m n : ℕ} -> m <= n -> n <= m -> m == n
le-antisymm le-zero     le-zero     = refl
le-antisymm (le-succ p) (le-succ q) = cong succ (le-antisymm p q)

le-trans : {m n o : ℕ} -> m <= n -> n <= o -> m <= o
le-trans le-zero     _           = le-zero
le-trans (le-succ p) (le-succ q) = le-succ (le-trans p q)

le-total : (m n : ℕ) -> m <= n ∨ n <= m
le-total zero n = inl le-zero
le-total (succ m) zero = inr le-zero
le-total (succ m) (succ n) with le-total m n
... | inl le = inl (le-succ le)
... | inr ge = inr (le-succ ge)

le-succ-r : {m n : ℕ} -> m <= n -> m <= succ n
le-succ-r le-zero = le-zero
le-succ-r (le-succ p) = le-succ (le-succ-r p)

le-plus : (x y : ℕ) -> x <= x + y
le-plus zero     y = le-zero
le-plus (succ x) y = le-succ (le-plus x y)

_<=?_ : (x y : ℕ) -> Decidable (x <= y)
zero <=? y = inr le-zero
succ x <=? zero = inl λ ()
succ x <=? succ y with x <=? y
... | inr le = inr (le-succ le)
... | inl gt = inl λ { (le-succ p) -> gt p }

le-cong-+ : {x x' y y' : ℕ} -> x <= x' -> y <= y' -> x + y <= x' + y'
le-cong-+ le-zero le-zero = le-zero
le-cong-+ {_} {x'} {_} {succ y'} le-zero (le-succ q) rewrite symm (+-succ x' y') =
  le-succ (le-cong-+ le-zero q)
le-cong-+ (le-succ p) q = le-succ (le-cong-+ p q)

le-min : {x y z : ℕ} -> x <= y -> x <= z -> x <= min y z
le-min le-zero     q           = le-zero
le-min (le-succ p) (le-succ q) = le-succ (le-min p q)

le-max : {x y z : ℕ} -> x <= z -> y <= z -> max x y <= z
le-max le-zero     q           = q
le-max (le-succ p) le-zero     = le-succ p
le-max (le-succ p) (le-succ q) = le-succ (le-max p q)

-- STRICT INEQUALITY

_<_ : ℕ -> ℕ -> Set
x < y = succ x <= y

_>_ : ℕ -> ℕ -> Set
x > y = y < x

not-lt-ge : {x y : ℕ} -> ¬ (x < y) -> (y <= x)
not-lt-ge {_}      {zero}   p = le-zero
not-lt-ge {zero}   {succ _} p = ex-falso (p (le-succ le-zero))
not-lt-ge {succ _} {succ _} p = le-succ (not-lt-ge λ q -> p (le-succ q))

le-ne-lt : {x y : ℕ} -> x <= y -> x != y -> x < y
le-ne-lt {.0} {zero} le-zero ne = ex-falso (ne refl)
le-ne-lt {.0} {succ y} le-zero ne = le-succ le-zero
le-ne-lt {.(succ _)} {.(succ _)} (le-succ le) ne = le-succ (le-ne-lt le λ { refl → ne refl } )

_<?_ : (x y : ℕ) -> Decidable (x < y)
x <? y = succ x <=? y
