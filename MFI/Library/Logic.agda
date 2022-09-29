module Library.Logic where

infixr 1 _<=>_
infix  2 _∨_ Σ-syntax ∃-syntax
infixr 3 _∧_
infixr 4 _,_

-- BOTTOM

data ⊥ : Set where

-- TOP

data ⊤ : Set where
  <> : ⊤

-- SIGMA TYPE

data Σ (A : Set) (P : A -> Set) : Set where
  _,_ : ∀(x : A) -> P x -> Σ A P

Σ-syntax : ∀(A : Set) (P : A -> Set) -> Set
Σ-syntax = Σ

syntax Σ-syntax A (λ x -> P) = Σ[ x ∈ A ] P

fst : ∀{A : Set} {P : A -> Set} -> Σ A P -> A
fst (x , _) = x

snd : ∀{A : Set} {P : A -> Set} (p : Σ A P) -> P (fst p)
snd (_ , y) = y

-- EXISTENTIAL

∃ : ∀{A : Set} -> (A -> Set) -> Set
∃ = Σ _

∃-syntax : ∀{A : Set} -> (A -> Set) -> Set
∃-syntax = ∃

syntax ∃-syntax (λ x -> B) = ∃[ x ] B

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
