module Boolean where

data Bool : Set where
  true : Bool
  false : Bool

not : Bool -> Bool
not true = false
not false = true

and : Bool -> Bool -> Bool
and true true = true
and _ _ = false

or : Bool → Bool → Bool
or false y = y
or true _ = true

_&&_ : Bool → Bool → Bool
true && y = y
false && _ = false

_||_ : Bool → Bool → Bool
false || y = y
true || _ = true

open import Library.Equality

-- Teorema ; true == true

true-eq : true == true
true-eq = refl

false-eq : false == false
false-eq = refl

-- Teorema : not true == false

-- attenzione perché stiamo dicendo non che i due membri sono uguali ma che
-- lo sono a meno di riduzioni, not true viene quindi ridotto a false
not-true-eq : not true == false
not-true-eq = refl

-- Teorema : not è involutivo ossia ∀(x : Bool) . not (not x) == x

not-inv : ∀(x : Bool) → not (not x) == x
not-inv true = refl
not-inv false = refl

-- Teorema : _&&_ è commutativo ossia ∀(x y : Bool) . x && y == y && x

&&-comm : ∀(x y : Bool) → x && y == y && x
&&-comm true true = refl
&&-comm true false = refl
&&-comm false true = refl
&&-comm false false = refl

-- Teorema ; legge di De Morgan : ∀(x y : Bool) . not (x && y) == not x || not y

not-&& : ∀(x y : Bool) → not (x && y) == not x || not y
not-&& true _ = refl
not-&& false _ = refl

not-|| : ∀(x y : Bool) → not (x || y) == not x && not y
not-|| true y = refl
not-|| false y = refl
