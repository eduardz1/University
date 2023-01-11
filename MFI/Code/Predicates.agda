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

-- definizione matematica di even
Even-m : ℕ -> Set
Even-m x = ∃[ y ] x == y * 2

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

Even-r : ℕ -> Set
Even-r zero = ⊤
Even-r (succ zero) = ⊥
Even-r (succ (succ n)) = Even-r n

-- dimostriamo che la metà di un numero pari moltiplicato per 2 è quel numero
theorem-p : ∀{x : ℕ} -> (ev : Even-p x == true) -> x == half x * 2
theorem-p {zero} ev = refl
theorem-p {succ (succ y)} ev = cong (succ ∘ succ) (theorem-p ev) -- sinoimo di "cong (λ x -> succ (succ x)) (theorem-p ev)"

theorem-i : ∀{x : ℕ} -> (ev : Even-i x) -> x == half x * 2
theorem-i even-zero = refl
theorem-i (even-succ ev) = cong (succ ∘ succ) (theorem-i ev)

theorem-r : ∀{x : ℕ} (ev : Even-r x) -> x == half x * 2
theorem-r {zero} ev = refl
theorem-r {succ (succ x)} ev = cong (succ ∘ succ) (theorem-r ev)

theorem-m : ∀{x : ℕ} -> (ev : Even-m x) -> x == half x * 2
theorem-m (x , refl) = cong (_* 2) (lem x)
    where
        lem : ∀ x -> x == half (x * 2)
        lem zero = refl
        lem (succ x) rewrite symm (lem x) = refl

p=>r : ∀(x : ℕ) -> Even-p x == true -> Even-r x
p=>r (zero) p = <>
p=>r (succ (succ x)) p = p=>r x p

r=>i : ∀(x : ℕ) -> Even-r x -> Even-i x
r=>i zero p = even-zero
r=>i (succ (succ x)) p = even-succ (r=>i x p)

i=>m : ∀{x : ℕ} -> Even-i x -> Even-m x
i=>m even-zero = zero , refl
i=>m (even-succ p) with i=>m p
... | x , refl = succ x , refl

m=>p : ∀{x : ℕ} -> Even-m x -> Even-p x == true
m=>p (x , refl) = lemma x
    where
        lemma : ∀(x : ℕ) -> Even-p (x * 2) == true
        lemma zero = refl
        lemma (succ x) = lemma x

-- Prove that x == 1 + x /2 * 2 when ¬ Even-i x holds.
not-even : ∀(x : ℕ) -> ¬ Even-i x -> x == 1 + half x * 2
not-even n p = {!  !}
