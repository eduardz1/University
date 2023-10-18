module Negation where

open import Library.Bool
open import Library.Nat
open import Library.List
open import Library.Fun
open import Library.Equality
open import Library.Equality.Reasoning
open import ConjDisj

data ⊥ : Set where

ex-falso : ∀{A : Set} -> ⊥ -> A -- in un sistema incoerente qualsiasi cosa è dimostrabile
ex-falso = λ () -- absurde pattern

¬_ : Set -> Set
¬_ A = A -> ⊥

data ⊤ : Set where
    <> : ⊤

⊤-∧ : ∀{A : Set} -> ⊤ ∧ A <=> A
⊤-∧ {A} = only-if , if
    where
        only-if : ⊤ ∧ A -> A
        only-if = snd

        if : A -> ⊤ ∧ A
        if = _,_ <>

-- TODO: DIMOSTRARE che ⊥ ∨ A -> A

{-
    Regola di eliminazione del not ¬ E

    ¬A   A
    ------
       ⊥

-}
contradiction : ∀{A : Set} -> A -> ¬ A -> ⊥
contradiction x y = y x

contraposition : ∀{A B : Set} -> (A -> B) -> (¬ B -> ¬ A) -- equivalent to writing (A -> B) -> ¬ B -> ¬ A (3 arguments as we can see below)
contraposition x y z = y (x z)

double-negation : ∀{A : Set} -> A -> ¬ ¬ A -- non possiamo dimostrare l'inverso
double-negation x y = y x

Decidable : Set -> Set -- in realtà non appartiene a Set
Decidable A = ¬ A ∨ A

{-
    Bool-eq-decidable : ∀(x y : Bool) -> Decidable (x == y) -- l'eguaglianza tra booleani è decidibile
    Bool-eq-decidable true true = inr refl
    Bool-eq-decidable true false = inl (λ ())
    Bool-eq-decidable false true = inl (λ ())
    Bool-eq-decidable false false = inr refl
-}

-- Pattern permette di definire dei sinonimi
pattern yes x = inr x
pattern no x  = inl x

-- we can then rewrite Bool-eq-decidable as:
Bool-eq-decidable : ∀(x y : Bool) -> Decidable (x == y)
Bool-eq-decidable true true = yes refl
Bool-eq-decidable true false = no (λ ())
Bool-eq-decidable false true = no (λ ())
Bool-eq-decidable false false = yes refl
-- and that is more legibile, is it true that true == true? yes! using refl, is it true that true == false? no! using the absurdity pattern

Nat-eq-decidable : ∀(x y : ℕ) -> Decidable (x == y)
Nat-eq-decidable zero zero     = yes refl
Nat-eq-decidable zero (succ y) = no (λ ())
Nat-eq-decidable (succ x) zero = no (λ ())
Nat-eq-decidable (succ x) (succ y) with Nat-eq-decidable x y
... | yes p = yes (cong succ p) -- with goal as (succ x == succ y -> ⊥) ∨ (succ x == succ y), in this line we demonstrated the right side expression
... | no  q = no λ{refl → q refl} -- uso λ{z -> ?} and then C-c C-SPC and then C-c C-c on z

List-eq-decidable : ∀{A : Set} -> 
                    (∀(x y : A) -> Decidable (x == y)) -> 
                    ∀(xs ys : List A) -> 
                    Decidable (xs == ys)
List-eq-decidable p [] [] = yes refl
List-eq-decidable p [] (x :: ys) = no (λ ())
List-eq-decidable p (x :: xs) [] = no (λ ())
List-eq-decidable p (x :: xs) (y :: ys) with p x y | List-eq-decidable p xs ys 
... | no x     | yes y    = no λ{refl -> x refl}
... | _        | no y     = no λ{refl → y refl}
... | yes refl | yes refl = yes refl

ntop : ¬ ⊤ -> ⊥
ntop x = x <>

em-dn : (∀{A : Set} -> ¬ A ∨ A) -> ∀{A : Set} -> ¬ ¬ A -> A
em-dn em {A} dn with em {A}
... | inl x = ex-falso (dn x)
... | inr x = x

nndec : ∀{A : Set} -> ¬ ¬ Decidable A
nndec {A} = λ z → z (no (λ x → z (yes x)))

dn-em : (∀{A : Set} -> (¬ ¬ A -> A)) -> ∀{A : Set} -> Decidable A
dn-em p = p nndec
