module Library.Equality.Reasoning where

open import Library.Equality

infix  1 begin_
infixr 2 _==⟨⟩_ _⟨⟩==_ _==⟨_⟩_ _⟨_⟩==_
infix  3 _end

begin_ : {A : Set} {x y : A} -> x == y -> x == y
begin_ p = p

_end : {A : Set} (x : A) -> x == x
_end _ = refl

_==⟨_⟩_ : {A : Set} (x : A) {y z : A} -> x == y -> y == z -> x == z
_==⟨_⟩_ _ = tran

_⟨_⟩==_ : {A : Set} (x : A) {y z : A} -> y == x -> y == z -> x == z
_ ⟨ p ⟩== q = tran (symm p) q

_==⟨⟩_ : {A : Set} (x : A) {y : A} -> x == y -> x == y
_ ==⟨⟩ p = p

_⟨⟩==_ : {A : Set} (x : A) {y : A} -> y == x -> x == y
_ ⟨⟩== p = symm p
