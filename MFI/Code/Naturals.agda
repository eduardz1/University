module Naturals where

open import Library.Equality
open import Library.Equality.Reasoning
open import Library.Fun

data ℕ : Set where
  zero : ℕ
  succ  : ℕ → ℕ

-- 2 si scrive succ (succ zero)

{-# BUILTIN NATURAL ℕ #-}

_ : 3 == succ (succ 1)
_ = refl

_+_ : ℕ → ℕ → ℕ
zero + y = y
succ x + y = succ (x + y)

infixl 6 _+_

_*_ : ℕ → ℕ → ℕ
zero * y = zero
succ x * y = y + x * y

infixl 7 _*_

-- Dimostrazione dell'associatività di _+_

+-assoc : ∀(x y z : ℕ) → x + (y + z) == (x + y) + z
+-assoc zero y z = refl  -- mi conviene dare precedenza alle variabili che occorrono a sx perché l'ho definita induttivamente sul secondo argomento, faccio induzione sulla x

-- Primo modo di dimostrare la tesi:
-- +-assoc (succ x) y z = cong succ (+-assoc x y z) -- regola di congrunza unita alla (chiamata ricorsiva == ipotesi induttiva)

{-

        x + (y + z) == (x + y) + z
  ----------------------------------------[cong]
  succ (x + (y + z)) == succ ((x + y) + z)

-}

-- Secondo modo per dimostrare la tesi:
{-
+-assoc (succ x) y z =
  begin
    (succ x) + (y + z) ==⟨⟩ -- nelle parentesi angolose bisogna mettere la giustificazione ma non mettiamo niente per indicare che le affermazioni valgono per definizione
    succ (x + (y + z)) ==⟨ cong succ (+-assoc x y z) ⟩ -- unico passo effetivamente significativo, tutto il resto può essere fatto automaticamente
    succ ((x + y) + z) ==⟨⟩
    (succ (x + y)) + z ==⟨⟩
    ((succ x) + y) + z
  end
-}

-- Terzo modo di dimostrare la tesi:
+-assoc (succ x) y z rewrite (+-assoc x y z) = refl

-- Dimostrazione della commutatività del +

+-unit-r : ∀(x : ℕ) → x == x + zero
+-unit-r zero =  refl
+-unit-r (succ x) = cong succ (+-unit-r x) -- il Goal è succ (x + 0) == succ (x + 0 + 0)

+-succ : ∀(x y : ℕ) → (succ x) + y == x + (succ y) -- nota che è lo stesso che mettiamo come quarto caso nel begin sottostante
+-succ zero y = refl
+-succ (succ x) y rewrite (+-succ x y) = refl


+-comm : ∀(x y : ℕ) → x + y == y + x
+-comm zero y = +-unit-r y -- Goal: y == y + zero, nota che per come è definito _+_ sappiamo che zero + y == y ma non sappiamo che y + zero == y, dobbiamo dimostrare la commutatività
+-comm (succ x) y =
  begin
    (succ x) + y ==⟨⟩
    succ (x + y) ==⟨ cong succ (+-comm x y)⟩
    succ (y + x) ==⟨⟩
    (succ y) + x ==⟨ +-succ y x ⟩ -- a questo punto il Goal (C-,) è y + succ x == y + succ x quindi lo tolgo perché è l'identità
    y + succ x
  end

-- Dimostrazione della commutatività del *

-- Lemma *-zero-r : ∀(x : ℕ) → zero == x * zero
*-zero-r : ∀(x : ℕ) → zero == x * zero
*-zero-r zero = refl
*-zero-r (succ x) = *-zero-r x -- voglio dimostrare che zero == succ x * zero

*-succ : ∀(y x : ℕ) → y + (y * x) == y * succ x
*-succ zero x = refl
*-succ (succ y) x =
  begin
    succ (y + (x + (y * x))) ==⟨ cong succ (+-assoc y x (y * x)) ⟩
    succ ((y + x) + (y * x)) ==⟨ cong (λ z -> succ (z + (y * x))) (+-comm y x) ⟩ 
    succ ((x + y) + (y * x)) ==⟨ cong succ (symm (+-assoc x y (y * x))) ⟩
    succ (x + (y + (y * x))) ==⟨ cong (λ z -> succ (x + z)) (*-succ y x) ⟩
    succ (x + (y * succ x))
  end

*-comm : ∀(x y : ℕ) → x * y == y * x
*-comm zero y = *-zero-r y
*-comm (succ x) y = -- come Goal abbiamo y + x * y == y * succ x
  begin
    (y + (x * y)) ==⟨ cong (λ z -> y + z) (*-comm x y) ⟩
    (y + (y * x)) ==⟨ *-succ y x ⟩
    (y * succ x)
  end

_-_ : ℕ -> ℕ -> ℕ
x - zero = x
zero - _ = zero
succ x - succ y = x - y

infixl 6 _-_

plus-minus-l : ∀(x y : ℕ) -> (x + y) - x == y
plus-minus-l zero y = refl
plus-minus-l (succ x) y = plus-minus-l x y

plus-minus-r : ∀(x y : ℕ) -> (x + y) - y == x
plus-minus-r x y rewrite +-comm x y = plus-minus-l y x

fact : ℕ -> ℕ
fact zero = 1
fact (succ n) = (succ n) * fact n

*-unit-l : ∀(x : ℕ) -> x == 1 * x
*-unit-l zero = refl
*-unit-l (succ x) = cong succ (*-unit-l x)

*-unit-r : ∀(x : ℕ) -> x == x * 1
*-unit-r zero = refl
*-unit-r (succ x) = cong succ (*-unit-r x)

*-dist-r : ∀(x y z : ℕ) -> (x + y) * z == x * z + y * z
*-dist-r zero y z = refl
*-dist-r (succ x) y z rewrite (*-dist-r) x y z = 
  begin
    z + (x * z + y * z)
  ==⟨ +-assoc z (x * z) (y * z) ⟩
    z + x * z + y * z
  end

*-dist-l : ∀(x y z : ℕ) -> x * (y + z) == x * y + x * z
*-dist-l x y z = 
  begin
    x * (y + z)
  ==⟨ *-comm x (y + z) ⟩
    (y + z) * x
  ==⟨ *-dist-r y z x ⟩
    y * x + z * x
  ==⟨ cong (_+ z * x) (*-comm y x) ⟩
    x * y + z * x
  ==⟨ cong (x * y +_) (*-comm z x) ⟩
    x * y + x * z
  end

*-assoc : ∀(x y z : ℕ) -> x * (y * z) == (x * y) * z
*-assoc zero y z = refl
*-assoc (succ x) y z rewrite *-assoc x y z = 
  begin
    y * z + x * y * z
  ==⟨ refl ⟩
    y * z + (x * y) * z
    ⟨ *-dist-r y (x * y) z ⟩==
    (y + x * y) * z
  end

infixl 8 _^_

_^_ : ℕ -> ℕ -> ℕ
_ ^ zero = 1
x ^ succ y = x * x ^ y

^-assoc : ∀(x m n : ℕ) -> x ^ m * x ^ n == x ^ (m + n)
^-assoc x zero n rewrite +-comm (x ^ n) zero = refl
^-assoc x (succ m) n =
  begin
    x ^ succ m * x ^ n
  ==⟨⟩
    x * x ^ m * x ^ n
  ⟨ *-assoc x (x ^ m) (x ^ n) ⟩==
    x * (x ^ m * x ^ n)
  ==⟨ cong (x *_) (^-assoc x m n) ⟩
    x * x ^ (m + n)
  ⟨⟩==
    x ^ (succ m + n)
  end

^-dist : ∀(x y n : ℕ) -> (x * y) ^ n == x ^ n * y ^ n
^-dist x y zero = refl
^-dist x y (succ n) =
  begin
    x * y * (x * y) ^ n
  ==⟨ cong (x * y *_) (^-dist x y n) ⟩
    x * y * (x ^ n * y ^ n)
  ==⟨ *-assoc (x * y) (x ^ n) (y ^ n) ⟩
    (x * y * x ^ n) * y ^ n
  ⟨ cong (_* y ^ n) (*-assoc x y (x ^ n)) ⟩==
    x * (y * x ^ n) * y ^ n
  ==⟨ cong (λ u -> x * u * y ^ n) (*-comm y (x ^ n)) ⟩
    x * (x ^ n * y) * y ^ n
  ==⟨ cong (_* y ^ n) (*-assoc x (x ^ n) y) ⟩
    ((x * x ^ n) * y) * y ^ n
  ⟨ *-assoc (x * x ^ n) y (y ^ n) ⟩==
    x * x ^ n * (y * y ^ n)
  end

^-trans : ∀(x m n : ℕ) -> x ^ m ^ n == x ^ (m * n)
^-trans x zero n = lemma n
  where
    lemma : ∀(n : ℕ) -> 1 ^ n == 1
    lemma zero = refl
    lemma (succ n) rewrite lemma n = refl
^-trans x (succ m) n rewrite ^-dist x (x ^ m) n = 
  begin
    x ^ n * x ^ m ^ n
  ==⟨ cong (x ^ n *_) (^-trans x m n) ⟩
    x ^ n * x ^ (m * n)
  ==⟨ ^-assoc x n (m * n) ⟩
    x ^ (n + m * n)
  end