module Library.Fin where

open import Library.Nat using (ℕ; zero; succ)
open import Library.Logic
open import Library.Equality

data Fin : ℕ -> Set where
  zero : ∀{n : ℕ} -> Fin (succ n)
  succ : ∀{n : ℕ} -> Fin n -> Fin (succ n)

_=?_ : ∀{n : ℕ} (i j : Fin n) -> Decidable (i == j)
zero =? zero = inr refl
zero =? succ j = inl λ ()
succ i =? zero = inl (λ ())
succ i =? succ j with i =? j
... | inr refl = inr refl
... | inl neq  = inl  λ { refl -> neq refl }
