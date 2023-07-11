module HoareLogic where

open import Library.Bool
open import Library.Nat
open import Library.Nat.Properties
open import Library.Logic
open import Library.Logic.Laws 
open import Library.Equality
open import Library.Equality.Reasoning

open import AexpBexp
open import BigStep

-- Logica di Hoare

-- Tripla {P} c {Q} dove P, Q sono asserzioni, ossia predicati dello stato
-- c ∈ Com e la semantica della tripla consiste nell'affermazione
-- che ogni esecuzione di c a partire da un stotato s t.c. P s (P è vero di s)
-- se termina in uno stato t, allora Q t.

-- ^^^ Correttezza parziale

Assn = State -> Set

-- a ==' a' è vero in s se aval a s == aval a' s
_=='_ : Aexp → Aexp → Assn
a ==' a' = λ s → aval a s == aval a' s

data Triple : Set₁ where
    [_]_[_] : Assn -> Com -> Assn -> Triple

-- Implicazione dei predicati
_==>_ : Assn -> Assn -> Set
P ==> Q = ∀ s -> P s -> Q s

data |-_ : Triple -> Set₁ where 
    H-Skip : ∀ {P}
             ----------------------
             -> |- [ P ] SKIP [ P ]

    -- non è sufficiente scrivere -> [P] x := a [P[a/x]] perché a può contenere x
    -- ad esempio [X=2] X := 0 [X=0] non è valido
    -- la prima parte del predicato serve per rappresentara P[a/x] in Set
    H-Loc : ∀ {P a x}
            ----------------------------------------------------------
            -> |- [ (λ s -> P (s [ x ::= aval a s ])) ] (x := a) [ P ]

    H-Comp : ∀ {P Q R c₁ c₂}
             -> |- [ P ] c₁ [ Q ]
             -> |- [ Q ] c₂ [ R ]
             --------------------------
             -> |- [ P ] c₁ :: c₂ [ R ]

    H-If : ∀ {P b c₁ Q c₂}
           -> |- [ (λ s -> P s ∧ bval b s == true)  ] c₁ [ Q ]
           -> |- [ (λ s -> P s ∧ bval b s == false) ] c₂ [ Q ]
           ---------------------------------------------------
           -> |- [ P ] (IF b THEN c₁ ELSE c₂) [ Q ]

    H-While : ∀ {P b c}
              -> |- [ (λ s -> P s ∧ bval b s == true) ] c [ P ]
              ---------------------------------------------------------------
              -> |- [ P ] (WHILE b DO c) [ (λ s -> P s ∧ bval b s == false) ]

    H-Conseq : ∀ {P Q P' Q' : Assn} {c}
               -> P' ==> P  -- indebolimento / precondizione
               -> |- [ P ] c [ Q ]
               -> Q  ==> Q' -- rafforzamento / postcondizione
               ---------------------
               -> |- [ P' ] c [ Q' ]

-- Regole derivate

H-Str : ∀ {P Q P' : Assn} {c}
        -> P' ==> P
        -> |- [ P ] c [ Q ]
        -------------------
        -> |- [ P' ] c [ Q ]
H-Str hp1 hp2 = H-Conseq hp1 hp2 λ s z → z

H-Weak : ∀ {P Q Q' : Assn} {c}
         -> |- [ P ] c [ Q ]
         -> Q ==> Q'
         -------------------
         -> |- [ P ] c [ Q' ]
H-Weak = H-Conseq (λ s z → z)

H-While' : ∀ {P b c Q}
           -> |- [ (λ s -> P s ∧ bval b s == true) ] c [ P ]
           -> (∀ s -> (P s ∧ bval b s == false) -> Q s)
           -> |- [ P ] (WHILE b DO c) [ Q ]
H-While' hp1 hp2 = H-Weak (H-While hp1) hp2

-- Esempi
{- 
        |- {X = 1} Z := X [Z = 1] è derivabile in HL

        ------------------------------ H-Loc
        {(Z = 1) [Z/X]} Z := X {Z = 1}
-}

p0-0 : |- [ V X ==' N 1 ] Z := V X [ V Z ==' N 1 ]
p0-0 = H-Loc

{-
        ------------------------- H-Loc        ------------------------- H-Loc
        |- {X = 1} Z := X {Z = 1}              |- {Z = 1} Y := Z {Y = 1}
        ---------------------------------------------------------------- H-Comp
                |- {X = 1} Z := X ; Y := Z {Y = 1}
-}

p0-1 : |- [ V Z ==' N 1 ] Y := V Z [ V Y ==' N 1 ]
p0-1 = H-Loc

p0-2 : |- [ V X ==' N 1 ] (Z := V X) :: (Y := V Z) [ V Y ==' N 1 ]
p0-2 = H-Comp p0-0 p0-1

{-
        |- {⊤} IF X < Y THEN Z := Y ELSE Z := X {Z = max(X, Y)}
-}

-- trivial assertion, true in every state
⊤' : Assn
⊤' s = ⊤

max' : Aexp -> Aexp -> Aexp -> Assn
max' a₁ a₂ a₃ = λ s -> max (aval a₁ s) (aval a₂ s) == aval a₃ s

_∧'_ : Assn -> Assn -> Assn
P ∧' Q = λ s -> P s ∧ Q s
