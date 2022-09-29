module Library.Vec where

open import Library.Fun using (_∘_)
open import Library.Nat
open import Library.Nat.Properties
open import Library.Fin
open import Library.Equality

data Vec (A : Set) : ℕ -> Set where
  []   : Vec A zero
  _::_ : ∀{n : ℕ} -> A -> Vec A n -> Vec A (succ n)

vector : ∀{A : Set} {n : ℕ} -> A -> Vec A n
vector {_} {zero} _ = []
vector {_} {succ n} x = x :: vector x

_++_ : ∀{A : Set} {m n : ℕ} -> Vec A m -> Vec A n -> Vec A (m + n)
[] ++ ys = ys
(x :: xs) ++ ys = x :: (xs ++ ys)

_!!_ : ∀{A : Set} {n : ℕ} -> Vec A n -> Fin n -> A
(x :: _)  !! zero   = x
(_ :: xs) !! succ i = xs !! i

head : ∀{A : Set} {n : ℕ} -> Vec A (succ n) -> A
head = _!! zero

tail : ∀{A : Set} {n : ℕ} -> Vec A (succ n) -> Vec A n
tail (_ :: xs) = xs

map : ∀{A B : Set} {n : ℕ} -> (A -> B) -> Vec A n -> Vec B n
map f []        = []
map f (x :: xs) = f x :: map f xs

zip-with : ∀{A B C : Set} {n : ℕ} -> (A -> B -> C) -> Vec A n -> Vec B n -> Vec C n
zip-with f []        []        = []
zip-with f (x :: xs) (y :: ys) = f x y :: zip-with f xs ys

foldr : ∀{A B : Set}{n : ℕ} -> (A -> B -> B) -> B -> Vec A n -> B
foldr f y [] = y
foldr f y (x :: xs) = f x (foldr f y xs)

module Ugh where

  coerce-::-cong : {A : Set} {m n : ℕ} {xs : Vec A m} {ys : Vec A n} (x : A) (eq : m == n) ->
    subst (Vec A) eq xs == ys -> subst (Vec A) (cong succ eq) (x :: xs) == (x :: ys)
  coerce-::-cong x refl refl = refl

  ++-associative : {A : Set} {m n o : ℕ} (xs : Vec A m) (ys : Vec A n) (zs : Vec A o) -> subst (Vec A) (+-assoc m n o) (xs ++ (ys ++ zs)) == (xs ++ ys) ++ zs
  ++-associative [] ys zs = refl
  ++-associative {_} {succ m} {n} {o} (x :: xs) ys zs = coerce-::-cong x (+-assoc m n o) (++-associative xs ys zs)

  infix 4 _~~_

  data _~~_ : {A B : Set} (x : A) (y : B) -> Set where
    refl : {A : Set} {x : A} -> x ~~ x

  ~~-cong : ∀{A B C : Set} (f : A -> B) {x y : A} -> x ~~ y -> f x ~~ f y
  ~~-cong f refl = refl

  ::-cong : {A : Set} {m n : ℕ} {xs : Vec A m} {ys : Vec A n} (x : A) (eq : m == n) ->
    xs ~~ ys -> x :: xs ~~ x :: ys
  ::-cong x refl refl = refl

  ++-associative' : {A : Set} {m n o : ℕ} (xs : Vec A m) (ys : Vec A n) (zs : Vec A o) -> xs ++ (ys ++ zs) ~~ (xs ++ ys) ++ zs
  ++-associative' [] ys zs = refl
  ++-associative' {_} {succ m} {n} {o} (x :: xs) ys zs = ::-cong x (+-assoc m n o) (++-associative' xs ys zs)


  lemma : {A : Set} {x y : A} -> x ~~ y -> x == y
  lemma refl = refl

-- TODO: infix ++ e !!

