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
++-unit-r [] = refl
++-unit-r (x :: xs) = cong (x ::_) (++-unit-r xs)

++-assoc : ∀{A : Set} (xs ys zs : List A) → (xs ++ ys) ++ zs == xs ++ (ys ++ zs)
++-assoc [] ys zs = refl
++-assoc (x :: xs) ys zs = cong (x ::_) (++-assoc xs ys zs)

reverse-++ : ∀{A : Set} (xs ys : List A) ->
             reverse (xs ++ ys) == reverse ys ++ reverse xs
reverse-++ [] ys = ++-unit-r (reverse ys) -- devo dimostrare che reverese ys == reverse ys ++ [] quindi faccio un lemma
reverse-++ (x :: xs) ys rewrite reverse-++ xs ys 
                              | ++-assoc (reverse ys) (reverse xs) (x :: []) = refl

reverse-onto : ∀{A : Set} -> List A -> List A -> List A
reverse-onto [] ys = ys
reverse-onto (x :: xs) ys = reverse-onto xs (x :: ys)

fast-reverse : ∀{A : Set} -> List A -> List A
fast-reverse xs = reverse-onto xs []

lemma-reverse-onto : ∀{A : Set} (xs ys : List A) -> reverse-onto xs ys == reverse xs ++ ys
lemma-reverse-onto [] ys = refl
lemma-reverse-onto (x :: xs) ys rewrite lemma-reverse-onto xs (x :: ys)
                                      | ++-assoc (reverse xs) ([ x ]) (ys) = refl

fast-reverse-correct : ∀{A : Set} (xs : List A) → fast-reverse xs == reverse xs
fast-reverse-correct [] = refl
fast-reverse-correct (x :: xs) rewrite fast-reverse-correct xs 
                                     | lemma-reverse-onto xs [ x ] = refl

map : ∀{A B : Set} → (f : A -> B) → List A → List B
map f [] = []
map f (x :: xs) = f x :: (map f xs)

-- vogliamo dimostrare che la lunghezza di una lista modificata da map è uguale alla lunghezza della lista originale
map-length : {A B : Set} (f : A -> B) (xs : List A) -> length (map f xs) == length xs
map-length f [] = refl
map-length f (x :: xs) = cong succ (map-length f xs)

-- voglio dimostrare che il map distribuisce rispetto all'operatore di concatenazione
map-++ : {A B : Set} (f : A -> B) (xs ys : List A) -> map f (xs ++ ys) == map f xs ++ map f ys
map-++ f [] ys = refl
map-++ f (x :: xs) ys rewrite map-++ f xs ys = refl -- faccio induzione sulla variabile di rango più elevato, ossia quella con più occorrenze a sinistra di una variabile definita a sinistra. ys non sta mai a sinistra dell'append mentre xs ci sta 1 volta esplicitamente e 2 volte implicitamente

map-reverse : ∀{A B : Set} (f : A -> B) (xs : List A) -> 
              map f (reverse xs) == reverse (map f xs)
map-reverse f [] = refl
map-reverse f (x :: xs) rewrite map-++ f (reverse xs) (x :: [])
                              | map-reverse f xs = refl

map-∘ : ∀{A B C : Set} (f : B -> C) (g : A -> B) (xs : List A) -> 
        (map f ∘ map g) xs == map (f ∘ g) xs
map-∘ f g [] = refl
map-∘ f g (x :: xs) rewrite map-∘ f g xs = refl
