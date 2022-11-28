module Predicates where

-- i predicati sono funzioni non saturate

open import Library.Fun
open import Library.Bool
open import Library.Nat
open import Library.List
open import Library.Logic
open import Library.Logic.Laws
open import Library.Equality

-- un predicato è una funzione che va da A a Set, è una proposizione
-- P : A -> Set (= Prop)

-- Definizione come programma di Even
Even-p : ℕ -> Bool
Even-p zero = true
Even-p (succ zero) = false
Even-p (succ (succ x)) = Even-p x

-- Definiamo half x come la parte intera inferiore di x / 2
half : ℕ -> ℕ
half zero = zero
half (succ zero) = zero
half (succ (succ x)) = succ (half x)

-- dimostriamo che la metà di un numero pari moltiplicato per 2 è quel numero
theorem-p : ∀{x : ℕ} -> (ev : Even-p x == true) -> x == half x * 2
theorem-p {zero} ev = refl
theorem-p {succ (succ y)} ev = cong (succ ∘ succ) (theorem-p ev) -- sinoimo di "cong (λ x -> succ (succ x)) (theorem-p ev)"

-- definizione matematica di even
Even-m : ℕ -> Set
Even-m x = ∃[ y ] x == y * 2

theorem-r : ∀{x : ℕ} -> (ev : Even-m x) -> x == half x * 2
theorem-r (x , refl) = cong (_* 2) (lem x)
    where
        lem : ∀ x -> x == half (x * 2)
        lem zero = refl
        lem (succ x) rewrite symm (lem x) = refl

-- definizione di even con un sistema di inferenza
{-
                                       Even-i x
    even-zero--------      even-succ---------------
             Even-i 0                Even-i (2 + x)

-}

data Even-i : ℕ -> Set where -- predicato induttivo, vale a dire predicato funzionale definito con data
    
    even-zero : --------
                Even-i 0

    even-succ : ∀{x : ℕ} 
                   → Even-i x
                ----------------
                → Even-i (2 + x)


_ : Even-i 4
_ = even-succ (even-succ even-zero)

{-      
    even-zero-----------
               Even-i 0
    even-succ-----------
               Even-i 2
    even-succ-----------
               Even-i 4

-}

-- dimostrare che qulacosa non vale è molto più difficile

_ : ¬ Even-i 1
_ = λ ()

_ : ¬ Even-i 3
_ = λ { (even-succ ())}

theorem-i : ∀{x : ℕ} -> (ev : Even-i x) -> x == half x * 2
theorem-i even-zero = refl
theorem-i (even-succ ev) = cong (succ ∘ succ) (theorem-i ev)