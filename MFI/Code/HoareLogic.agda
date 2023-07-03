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

Assn = State -> Set

-- a ==' a' è vero in s se aval a s == aval a' s

_=='_ : Aexp → Aexp → Assn
a ==' a' = λ s → aval a s == aval a' s


data Triple : Set₁ where
    [_]_[_] : Assn -> Com -> Assn -> Triple

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
               -> (∀ s -> P' s -> P s)
               -> |- [ P  ] c [ Q  ]
               -> (∀ s -> Q s -> Q' s)
               -----------------------
               -> |- [ P' ] c [ Q' ]