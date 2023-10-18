module Library.Nat where

data ℕ : Set where
  zero : ℕ
  succ : ℕ -> ℕ

{-# BUILTIN NATURAL ℕ #-}

infixl 6 _+_ _-_
infixl 7 _*_
infixl 8 _^_

_+_ : ℕ -> ℕ -> ℕ
zero   + y = y
succ x + y = succ (x + y)

_-_ : ℕ -> ℕ -> ℕ
zero   - _      = 0
succ x - zero   = succ x
succ x - succ y = x - y

_*_ : ℕ -> ℕ -> ℕ
zero   * _ = 0
succ x * y = y + (x * y)

_^_ : ℕ -> ℕ -> ℕ
x ^ zero = 1
x ^ succ n = x * x ^ n

min : ℕ -> ℕ -> ℕ
min zero y = zero
min (succ x) zero = zero
min (succ x) (succ y) = succ (min x y)

max : ℕ -> ℕ -> ℕ
max zero y = y
max (succ x) zero = succ x
max (succ x) (succ y) = succ (max x y)

_! : ℕ -> ℕ
zero   ! = 1
succ n ! = n * (n !)
