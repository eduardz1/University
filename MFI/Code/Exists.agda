module Exists where

open import Library.Fun
open import Library.Nat
open import Library.Bool
open import Library.Logic hiding (∃; ∃-syntax; Σ; fst; snd) -- nascondo le definizioni a scopo didattico
open import Library.Nat.Properties
open import Library.Logic.Laws
open import Library.Equality
open import Library.List

{-

    A : Set    x : A ⊢ B : Set
    ------------------------
       Π (x : A) B : Set


    Π in Agda di scrive ∀


    a : A     f a : B[a / x]
    ------------------------
       f : Π (x : A) B

-}

data Σ (A : Set) (B : A -> Set) : Set where
  _,_ : ∀(x : A) -> B x -> Σ A B

_×_ : Set -> Set -> Set
A × B = Σ A λ _ -> B

fst : ∀{A : Set} {B : A -> Set} -> Σ A B -> A
fst (x , _) = x

snd : ∀{A : Set} {B : A -> Set} (p : Σ A B) -> B (fst p)
snd (_ , y) = y

-- Esempi di uso dei tipi Σ
ℕ⁺ : Set
ℕ⁺ = Σ ℕ (_!= 0)

List⁺ : Set -> Set
List⁺ A = Σ (List A) (_!= [])

head : ∀{A : Set} -> List⁺ A -> A
head ([] , x₁) = ex-falso (x₁ refl) -- devo dimostrare che [] != [] == ¬ ( [] == [] ) == ( [] == [] ) -> ⊥
head ((x :: x₂) , x₁) = x

∃ : ∀{A : Set} (B : A -> Set) -> Set
∃ {A} B = Σ A B

∃-syntax = ∃
syntax ∃-syntax (λ x -> B) = ∃[ x ] B

pred : ∀(p : ℕ⁺) -> ∃[ z ] (fst p == succ z)
pred (zero , x₁) = ex-falso (x₁ refl)
pred (succ x , x₁) = x , refl

_∣_ : ℕ -> ℕ -> Set -- attenzione che non è | ma \|
x ∣ y = ∃[ z ] (z * x == y)

⊢refl : ∀ x -> x ∣ x
⊢refl x = 1 , +-unit-r x