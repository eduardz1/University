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
