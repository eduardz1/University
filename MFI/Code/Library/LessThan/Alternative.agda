module Library.LessThan.Alternative where

open import Library.Nat
open import Library.LessThan

infix 4 _<='_ _<'_

data _<='_ : ℕ -> ℕ -> Set where
  le-refl' : {n : ℕ}   -> n <=' n
  le-succ' : {m n : ℕ} -> m <=' n -> m <=' succ n

_<'_ : ℕ -> ℕ -> Set
x <' y = succ x <=' y

zero<=' : {x : ℕ} -> 0 <=' x
zero<=' {zero}   = le-refl'
zero<=' {succ x} = le-succ' zero<='

succ<=' : {x y : ℕ} -> x <=' y -> succ x <=' succ y
succ<=' le-refl'     = le-refl'
succ<=' (le-succ' p) = le-succ' (succ<=' p)

<=to<=' : {x y : ℕ} -> x <= y -> x <=' y
<=to<=' le-zero     = zero<='
<=to<=' (le-succ p) = succ<=' (<=to<=' p)

<='to<= : {x y : ℕ} -> x <=' y -> x <= y
<='to<= le-refl' = le-refl
<='to<= (le-succ' p) = le-succ-r (<='to<= p)
