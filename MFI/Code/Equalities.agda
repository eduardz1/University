module Equalities where

open import Library.Bool
open import Library.Nat
open import Library.List
open import Library.Logic

infix 4 _==_

data _==_ {A : Set} (x : A) : A → Set where
    refl : x == x

symm : ∀{A : Set} {x y : A} -> x == y -> y == x
symm {_} {x} {.x} refl = refl -- ha capito che eq deve essere una refl, se
                              -- scrivessi {x} {x} diventerebbe un pattern non
                              -- lineare perché verrebbe introdotta una variabile
                              -- due volte, con il punto va a denotare che a y
                              -- sostiuirà sempre x

trans : ∀{A : Set} {x y z : A} -> x == y -> y == z -> x == z
trans refl refl = refl

cong : ∀{A B : Set} (f : A -> B) {x y : A} -> x == y -> f x == f y
cong f refl = refl

subst : ∀{A : Set} (P : A -> Set) {x y : A} -> x == y -> P x -> P y 
-- non scriviamo P x == P y perché '==' è definito su tipi A non su Set
subst P refl hp = hp

succ-injective : ∀{x y : ℕ} -> succ x == succ y -> x == y
succ-injective refl = refl

_!=_ : ∀{A : Set} -> A -> A -> Set
x != y = ¬ (x == y)

zero-succ : ∀{x : ℕ} -> 0 != succ x
zero-succ () 

ne-ne : ∀{x y : ℕ} -> succ x != succ y -> x != y
ne-ne neq refl = neq refl

::-injective : ∀{A : Set} {x y : A} {xs ys : List A} -> x :: xs == y :: ys 
                                                     -> x == y ∧ xs == ys
::-injective refl = refl , refl

cong2 : ∀{A B C : Set} (f : A -> B -> C) 
        {x y : A} {u v : B} -> x == y -> u == v -> f x u == f y v
cong2 f refl refl = refl