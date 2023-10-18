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
head ([] , not-empty) = ex-falso (not-empty refl) -- devo dimostrare che [] != [] == ¬ ( [] == [] ) == ( [] == [] ) -> ⊥
head ((x :: _) , _) = x

tail : ∀{A : Set} -> List⁺ A -> List A
tail ([] , not-empty) = ex-falso (not-empty refl)
tail ((_ :: xs) , _) = xs

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

open import Library.Equality.Reasoning

∣-trans : ∀{x y z : ℕ} -> x ∣ y -> y ∣ z -> x ∣ z
∣-trans (p , refl) (q , refl) = q * p , symm (*-assoc q p _)
-- ∣-trans x y z (p , p₁) (q , q₁) = (q * p) , th
--    where 
--       th : (q * p) * x == z
--       th = 
--          begin
--             (q * p) * x
--          ⟨ *-assoc q p x ⟩==
--             q * (p * x)
--          ==⟨ cong (λ k -> q * k) p₁ ⟩
--             q * y
--          ==⟨ q₁ ⟩
--             z
--          end

+-succ-neq : ∀{x y : ℕ} -> x + succ y != x
+-succ-neq {succ x} {y} h = +-succ-neq (succ-injective h) -- succ-injective : {x y : ℕ} -> succ x == succ y -> x == y
-- can split x : x -> 0 is implicitly false
-- we don´t really need y

*-zero-neq-one : ∀(x : ℕ) -> x * 0 != 1 -- equivalent to (x * 0 == 1) -> ⊥
*-zero-neq-one (succ x) h = *-zero-neq-one x h

*-one : ∀(x y : ℕ) -> x * y == 1 -> x == 1 ∧ y == 1
*-one (succ x) zero hp = ex-falso (*-zero-neq-one x hp) -- devo dimostrare succ x == 1 ∧ zero == 1 dove quest'ultimo è un assurdo
*-one (succ zero) (succ zero) hp = refl , refl -- (succ x) * y == 1 -> succ x == 1 ∧ y == 1 

*-same : ∀(x y : ℕ) -> x * y == y -> x == 1 ∨ y == 0
*-same zero zero hp = inr refl
*-same (succ x) zero hp = inr refl
*-same (succ zero) (succ y) hp = inl refl
*-same (succ (succ x)) (succ y) hp = ex-falso (+-succ-neq k)
   where
      k : y + succ (y + x * succ y) == y
      k = succ-injective hp

∣-antisymm : ∀{x y : ℕ} -> x ∣ y -> y ∣ x -> x == y
∣-antisymm (zero , x₁) (zero , x₃) = {!   !}
∣-antisymm (zero , x₁) (succ x₂ , x₃) = {!   !}
∣-antisymm (succ x , x₁) (zero , x₃) = {!   !}
∣-antisymm (succ x , x₁) (succ x₂ , x₃) = {!   !}


funct : ∀{A : Set} -> A -> Set
funct x = {!   !}

_ : ∀(x : Set) -> ∃[ x ] (funct x)
_ = {!   !}