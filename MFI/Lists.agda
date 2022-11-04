module Lists where 

open import Library.Fun
open import Library.Nat
open import Library.Equality
open import Library.Equality.Reasoning

data List (A : Set) : Set where
    [] : List A
    _::_ : A -> List A -> List A

infixr 5 _::_

-- esempio di lista: [0,1,2]
ll : List ℕ
ll = 0 :: 1 :: 2 :: []

length : ∀{A : Set} → List A → ℕ
length [] = 0
length (x :: xs) = succ (length xs)

[_] : ∀{A : Set} -> A -> List A
[_] = _:: []

_++_ : ∀{A : Set} → List A → List A → List A
[] ++ ys = ys
(x :: xs) ++ ys = x :: xs ++ ys

infixr 5 _++_

length-++ : ∀{A : Set} (xs ys : List A) → length (xs ++ ys) == length xs + length ys
length-++ [] ys = refl
length-++ (x :: xs) ys rewrite (length-++ xs ys) = refl -- si procede per induzione su xs

-- reverse naive, la complesità è polinomiale O(n^2)
-- T(n) = n - 1 + T(n - 1)
reverse : ∀{A : Set} → List A → List A
reverse [] = []
reverse (x :: xs) = (reverse xs) ++ (x :: [])

++-unit-r : ∀{A : Set} (xs : List A) → xs == xs ++ []
++-unit-r xs = {!  !}

++-assoc : ∀{A : Set} (xs ys zs : List A) → (xs ++ ys) ++ zs == xs ++ (ys ++ zs)
++-assoc xs ys zs = {!   !}

reverse-++ : ∀{A : Set} (xs ys : List A) → reverse (xs ++ ys) == reverse ys ++ reverse xs
reverse-++ [] ys = ++-unit-r (reverse ys) -- devo dimostrare che reverese ys == reverse ys ++ [] quindi faccio un lemma
reverse-++ (x :: xs) ys = 
    begin
      reverse (xs ++ ys) ++ [ x ] ==⟨ cong (λ z -> z ++ [ x ]) (reverse-++ xs ys) ⟩
      (reverse ys ++ reverse xs) ++ [ x ] ==⟨ ++-assoc (reverse ys) (reverse xs) [ x ] ⟩ 
      reverse ys ++ (reverse xs ++ [ x ])
    end