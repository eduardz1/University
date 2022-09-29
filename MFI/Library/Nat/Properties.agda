module Library.Nat.Properties where

open import Library.Nat
open import Library.Logic
open import Library.Equality
open import Library.Equality.Reasoning

succ-injective : ∀{x y : ℕ} -> succ x == succ y -> x == y
succ-injective refl = refl

+-assoc : ∀(x y z : ℕ) -> x + (y + z) == (x + y) + z
+-assoc zero y z = refl
+-assoc (succ x) y z = cong succ (+-assoc x y z)

+-succ : ∀(x y : ℕ) -> succ x + y == x + succ y
+-succ zero y = refl
+-succ (succ x) y = cong succ (+-succ x y)

+-unit-l : ∀(x : ℕ) -> 0 + x == x
+-unit-l _ = refl

+-unit-r : ∀(x : ℕ) -> x + 0 == x
+-unit-r zero = refl
+-unit-r (succ x) = cong succ (+-unit-r x)

+-comm : ∀(x y : ℕ) -> x + y == y + x
+-comm zero y = symm (+-unit-r y)
+-comm (succ x) y =
  begin
    succ x + y   ==⟨⟩
    succ (x + y) ==⟨ cong succ (+-comm x y) ⟩
    succ (y + x) ==⟨ +-succ y x ⟩
    y + succ x
  end

minus-zero : ∀(x : ℕ) -> x - 0 == x
minus-zero zero = refl
minus-zero (succ _) = refl

+-minus : ∀(x y : ℕ) -> x + y - x == y
+-minus zero y = minus-zero y
+-minus (succ x) y = +-minus x y

_=?_ : ∀(x y : ℕ) -> Decidable (x == y)
zero   =? zero   = inr refl
zero   =? succ y = inl λ ()
succ x =? zero   = inl (λ ())
succ x =? succ y with x =? y
... | inr eq = inr (cong succ eq)
... | inl ne = inl λ { refl -> ne refl }

infix 4 _=?_

*-unit-l : ∀(x : ℕ) -> 1 * x == x
*-unit-l x = +-unit-r x

*-unit-r : ∀(x : ℕ) -> x * 1 == x
*-unit-r zero = refl
*-unit-r (succ x) = cong succ (*-unit-r x)

*-zero-r : ∀(x : ℕ) -> 0 == x * 0
*-zero-r zero     = refl
*-zero-r (succ x) = *-zero-r x

*-dist-r : ∀(x y z : ℕ) -> (x + y) * z == x * z + y * z
*-dist-r zero y z = refl
*-dist-r (succ x) y z =
  begin
    (succ x + y) * z    ==⟨ refl ⟩
    succ (x + y) * z    ==⟨ refl ⟩
    z + (x + y) * z     ==⟨ cong (z +_) (*-dist-r x y z) ⟩
    z + (x * z + y * z) ==⟨ +-assoc z (x * z) (y * z) ⟩
    (z + x * z) + y * z ==⟨ refl ⟩
    succ x * z + y * z
  end

*-succ : ∀(x y : ℕ) -> x + x * y == x * succ y
*-succ zero y = refl
*-succ (succ x) y =
  begin
    succ x + (succ x * y)  ==⟨ refl ⟩
    succ x + (y + x * y)   ==⟨ refl ⟩
    succ (x + (y + x * y)) ==⟨ cong succ (+-assoc x y (x * y)) ⟩
    succ ((x + y) + x * y) ==⟨ cong (λ u -> succ (u + x * y)) (+-comm x y) ⟩
    succ ((y + x) + x * y)   ⟨ cong succ (+-assoc y x (x * y)) ⟩==
    succ (y + (x + x * y)) ==⟨ cong (λ u -> succ (y + u)) (*-succ x y) ⟩
    succ (y + x * succ y)  ==⟨ refl ⟩
    succ y + x * succ y    ==⟨ refl ⟩
    succ x * succ y
  end

*-comm : ∀(x y : ℕ) -> x * y == y * x
*-comm zero y     = *-zero-r y
*-comm (succ x) y =
  begin
    succ x * y ==⟨ refl ⟩
    y + x * y  ==⟨ cong (y +_) (*-comm x y) ⟩
    y + y * x  ==⟨ *-succ y x ⟩
    y * succ x
  end

*-assoc : ∀(x y z : ℕ) -> x * (y * z) == (x * y) * z
*-assoc zero y z = refl
*-assoc (succ x) y z =
  begin
    succ x * (y * z)    ==⟨ refl ⟩
    y * z + x * (y * z) ==⟨ cong (y * z +_) (*-assoc x y z) ⟩
    y * z + (x * y) * z   ⟨ *-dist-r y (x * y) z ⟩==
    (y + x * y) * z     ==⟨ refl ⟩
    (succ x * y) * z
  end

*-dist-l : ∀(x y z : ℕ) -> x * (y + z) == x * y + x * z
*-dist-l x y z =
  begin
    x * (y + z)   ==⟨ *-comm x (y + z) ⟩
    (y + z) * x   ==⟨ *-dist-r y z x ⟩
    y * x + z * x ==⟨ cong (_+ z * x) (*-comm y x) ⟩
    x * y + z * x ==⟨ cong (x * y +_) (*-comm z x) ⟩
    x * y + x * z
  end
