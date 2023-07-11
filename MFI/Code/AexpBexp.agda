module AexpBexp where

open import Library.Bool
open import Library.Nat
open import Library.Nat.Properties
open import Library.Logic
open import Library.Equality
open import Library.Equality.Reasoning

Index = ℕ
data Vname : Set where
    Vn : Index -> Vname

X : Vname
X = Vn 0

Y : Vname
Y = Vn 1

Z : Vname
Z = Vn 2

_=ℕ_ : ℕ -> ℕ -> Bool
zero =ℕ zero     = true
zero =ℕ succ m   = false
succ n =ℕ zero   = false
succ n =ℕ succ m = n =ℕ m

_=Vn_ : (x y : Vname) -> Bool
Vn i =Vn Vn j = i =ℕ j

data Aexp : Set where
    N : ℕ -> Aexp                  -- numerals
    V : Vname -> Aexp              -- variables
    Plus : Aexp -> Aexp -> Aexp    -- sum

aexp0 : Aexp
aexp0 = Plus (V X) (Plus (N 1) (V Y))

Val = ℕ
State = Vname -> Val

-- Update function: s [ x ::= v ] where s ∈ State, x ∈ Vname, v ∈ Val
_[_::=_] : State -> Vname -> Val -> State
(s [ x ::= v ]) y = if x =Vn y then v else s y

st0 : State
st0 = λ x -> 0

st1 : State
st1 = st0 [ X ::= 1 ]

st2 : State
st2 = st1 [ Y ::= 2 ]  -- equivalently:  st2 = (st0 [ X ::= 1 ]) [ Y ::= 2 ]

-- arithmetic expression interpreter with only the
-- sum as an operator
aval : Aexp -> State -> Val
aval (N n) s       = n
aval (V vn) s      = s vn
aval (Plus a a₁) s = aval a s + aval a₁ s

aval-example1 : Val
aval-example1 = aval aexp0 st2

-- Sostitution: a [ a' / x ] where a, a' ∈ Aexp, x ∈ Vname is the sostitution of 
-- a' to x in a
_[_/_] : Aexp -> Aexp -> Vname -> Aexp
N n [ a' / x ] = N n
V y [ a' / x ] = if x =Vn y then a' else V y
Plus a₁ a₂ [ a' / x ] = Plus (a₁ [ a' / x ]) (a₂ [ a' / x ])

-- Substitution lemma
-- when we substitute a value for a variable in an arithmetic expression, 
-- the resulting expression evaluates to the same value as the original 
-- expression but with the updated value for the variable
lemma-subst-aexp : ∀(a a' : Aexp) (x : Vname) (s : State) -> 
                   aval (a [ a' / x ]) s == aval a (s [ x ::= aval a' s ])
lemma-subst-aexp (N n) a' x s = refl
lemma-subst-aexp (V y) a' x s with x =Vn y
... | true  = refl
... | false = refl
lemma-subst-aexp (Plus a₁ a₂) a' x s = cong2 _+_ (lemma-subst-aexp a₁ a' x s) (lemma-subst-aexp a₂ a' x s)


-- Boolean expressions: Bexp ∋ b, b' ::= B bc | Less a a' | Not b | And b b'
data Bexp : Set where
    B : Bool -> Bexp             -- boolean constants
    Less : Aexp -> Aexp -> Bexp  -- less than
    Not : Bexp -> Bexp           -- negation
    And : Bexp -> Bexp -> Bexp   -- conjunction

_<ℕ_ : ℕ -> ℕ -> Bool
zero <ℕ zero     = false
zero <ℕ succ m   = true
succ n <ℕ zero   = false
succ n <ℕ succ m = n <ℕ m

bval : Bexp -> State -> Bool
bval (B c) s        = c
bval (Less a₁ a₂) s = aval a₁ s <ℕ aval a₂ s
bval (Not b) s      = not (bval b s)
bval (And b₁ b₂) s  = bval b₁ s && bval b₂ s

bexp1 : Bexp
bexp1 = Not (Less (V X) (N 1))       -- not (X < 1)

bexp2 : Bexp
bexp2 = And bexp1 (Less (N 0) (V Y)) -- (not (X < 1)) && (0 < Y)

st3 : State
st3 = st2

st4 : State
st4 = st0

lemma-bval-tot : ∀(b : Bexp) (s : State) ->
                 bval b s == true ∨ bval b s == false
lemma-bval-tot b s with bval b s
... | true  = inl refl
... | false = inr refl

_[_/_]B : Bexp -> Aexp -> Vname -> Bexp
B b [ a / v ]B        = B b
Less x₁ x₂ [ a / x ]B = Less (x₁ [ a / x ]) (x₂ [ a / x ])
Not b [ a / v ]B      = Not (b [ a / v ]B)
And b₁ b₂ [ a / v ]B  = And (b₁ [ a / v ]B) (b₂ [ a / v ]B)

lemma-subst-bexp : ∀(b : Bexp) (a : Aexp) (x : Vname) (s : State) ->
                   bval (b [ a / x ]B) s == bval b (s [ x ::= aval a s ])
lemma-subst-bexp (B c) a x s = refl
lemma-subst-bexp (Less x₁ x₂) a x s rewrite lemma-subst-aexp x₁ a x s 
                                          | lemma-subst-aexp x₂ a x s = refl
lemma-subst-bexp (Not b) a x s rewrite lemma-subst-bexp b a x s = refl
lemma-subst-bexp (And b₁ b₂) a x s rewrite lemma-subst-bexp b₁ a x s 
                                         | lemma-subst-bexp b₂ a x s = refl
 