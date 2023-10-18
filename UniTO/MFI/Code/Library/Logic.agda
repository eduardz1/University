module Library.Logic where

infixr 1 _<=>_
infix  2 Σ-syntax ∃-syntax -- Σ₁-syntax ∃₁-syntax
infixr 2 _∨_
infixr 3 _∧_
infixr 4 _,_

-- BOTTOM

data ⊥ : Set where

-- TOP

data ⊤ : Set where
  <> : ⊤

-- SIGMA TYPE

data Σ {ℓ} (A : Set ℓ) (P : A -> Set) : Set ℓ where
  _,_ : ∀(x : A) -> P x -> Σ A P

Σ-syntax : ∀{ℓ} (A : Set ℓ) (P : A -> Set) -> Set ℓ
Σ-syntax = Σ

syntax Σ-syntax A (λ x -> P) = Σ[ x ∈ A ] P

fst : ∀{ℓ} {A : Set ℓ} {P : A -> Set} -> Σ A P -> A
fst (x , _) = x

snd : ∀{ℓ} {A : Set ℓ} {P : A -> Set} (p : Σ A P) -> P (fst p)
snd (_ , y) = y

-- EXISTENTIAL

∃ : ∀{ℓ} {A : Set ℓ} -> (A -> Set) -> Set ℓ
∃ = Σ _

∃-syntax : ∀{ℓ} {A : Set ℓ} -> (A -> Set) -> Set ℓ
∃-syntax = ∃

syntax ∃-syntax (λ x -> B) = ∃[ x ] B

-- -- SIGMA TYPE AND EXISTENTIAL OVER Set₁

-- data Σ₁ (A : Set₁) (P : A -> Set) : Set₁ where
--   _,_ : ∀(x : A) -> P x -> Σ₁ A P

-- Σ₁-syntax : ∀(A : Set₁) (P : A -> Set) -> Set₁
-- Σ₁-syntax = Σ₁

-- syntax Σ₁-syntax A (λ x -> P) = Σ₁[ x ∈ A ] P

-- fst₁ : ∀{A : Set₁} {P : A -> Set} -> Σ₁ A P -> A
-- fst₁ (x , _) = x

-- snd₁ : ∀{A : Set₁} {P : A -> Set} (p : Σ₁ A P) -> P (fst₁ p)
-- snd₁ (_ , y) = y


-- -- EXISTENTIAL

-- ∃₁ : ∀{A : Set₁} -> (A -> Set) -> Set₁
-- ∃₁ = Σ₁ _

-- ∃₁-syntax : ∀{A : Set₁} -> (A -> Set) -> Set₁
-- ∃₁-syntax = ∃₁

-- syntax ∃₁-syntax (λ x -> B) = ∃₁[ x ] B

-- CONJUNCTION

_∧_ : Set -> Set -> Set
A ∧ B = Σ A λ _ -> B

-- DISJUNCTION

data _∨_ (A B : Set) : Set where
  inl : A -> A ∨ B
  inr : B -> A ∨ B

-- NEGATION

¬_ : Set -> Set
¬_ A = A -> ⊥

-- DECIDABILITY

Decidable : Set -> Set
Decidable A = ¬ A ∨ A

pattern yes x = inr x
pattern no  x = inl x

-- DOUBLE IMPLICATION

_<=>_ : Set -> Set -> Set
A <=> B = (A -> B) ∧ (B -> A)
