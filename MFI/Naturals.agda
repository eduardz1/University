module Naturals where

open import Library.Equality
open import Library.Equality.Reasoning

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
  --------------------------------------[cong]
  succ(x + (y + z)) == succ((x + y) + z)

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
+-unit-r (succ x)  = cong succ (+-unit-r x) -- il Goal è succ (x + 0) == succ (x + 0 + 0)

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
