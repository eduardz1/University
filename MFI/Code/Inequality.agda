module Inequality where

open import Library.Bool
open import Library.Nat
open import Library.Equality
open import Library.Logic

{-

Notazione: ≤ si scrive \<= oppure \le

                                   x ≤ y
[le-zero] ------    [le-succ] ---------------
          0 ≤ x               succ x ≤ succ y

coincide con la relazione definita da:

    x <= y <=> ∃ z . x + z == y

-}

data _<=_ : ℕ -> ℕ -> Set where
    le-zero : ∀{x : ℕ}
    
              --------
              -> 0 <= x

    le-succ : ∀{x y : ℕ}

              -> x <= y
              ------------------
              -> succ x <= succ y

_<=ₘ_ : ℕ -> ℕ -> Set
x <=ₘ y = ∃[ z ] x + z == y

le-sound : ∀{x y : ℕ} -> x <= y -> x <=ₘ y
le-sound le-zero = _ , refl -- raffino perché la feinizione dell'
                                    -- esistenziale è una coppia
le-sound (le-succ x<=y) with le-sound x<=y
...                     | z , refl = z , refl

{-

    Per ipotesi induttiva:

    x <= y -> ∃ z . x + z == y

    (succ x) + z == succ (x + z) == succ y

-}
