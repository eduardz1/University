module Library.LessThan.Reasoning where

open import Library.Nat
open import Library.LessThan
open import Library.Equality

infix  1 begin_
infixr 2 _<=⟨⟩_ _<=⟨_⟩_ _==⟨_⟩_ _<⟨_⟩_ _<⟨⟩_
infix  3 _end

begin_ : {x y : ℕ} -> x <= y -> x <= y
begin_ p = p

_end : (x : ℕ) -> x <= x
_end _ = le-refl

_==⟨_⟩_ : (x : ℕ) {y z : ℕ} -> x == y -> y <= z -> x <= z
_==⟨_⟩_ _ refl p = p

_<=⟨_⟩_ : (x : ℕ) {y z : ℕ} -> x <= y -> y <= z -> x <= z
_<=⟨_⟩_ _ = le-trans

_<=⟨⟩_ : (x : ℕ) {y : ℕ} -> x <= y -> x <= y
_ <=⟨⟩ p = p

_<⟨_⟩_ : (x : ℕ) {y z : ℕ} -> x < y -> y <= z -> x < z
_<⟨_⟩_ _ = le-trans

_<⟨⟩_ : (x : ℕ) {y : ℕ} -> succ x <= y -> x < y
_ <⟨⟩ p = p

