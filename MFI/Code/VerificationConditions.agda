module VerificationConditions where

open import Library.Bool
open import Library.Nat
open import Library.Logic
open import Library.Equality
open import Library.Equality.Reasoning

open import AexpBexp
open import BigStep
open import HoareLogic

data Acom : Set₁ where
    SKIP : Acom
    _:=_ : Vname -> Aexp -> Acom
    _::_ : Acom -> Acom -> Acom
    IF_THEN_ELSE_ : Bexp -> Acom -> Acom -> Acom 
    WHILE[_]_DO_  : Assn -> Bexp -> Acom -> Acom

-- strip prende un comando decorato e ne ritorna il comando non decorato
strip : Acom -> Com
strip SKIP = SKIP
strip (x := a) = x := a
strip (C₁ :: C₂) = strip C₁ :: strip C₂
strip (IF b THEN C₁ ELSE C₂) = IF b THEN strip C₁ ELSE strip C₂
strip (WHILE[ I ] b DO C) = WHILE b DO strip C

-- Pre-condition
-- pre C Q è una pre-condizione di strip C se tutti gli invarianti I che decorano
-- i WHILE in C sono effettivamente tali (semanticamente)
pre : Acom -> Assn -> Assn
pre SKIP Q = Q
pre (x := a) Q s = Q (s [ x ::= aval a s ])
pre (C₁ :: C₂) Q = pre C₁ (pre C₂ Q)
pre (IF b THEN C₁ ELSE C₂) Q s with bval b s
... | true  = pre C₁ Q s
... | false = pre C₂ Q s
pre (WHILE[ I ] b DO C) Q = I

-- vc C Q esprime le condizioni sotto le quali gli invarianti I
-- inclusi in C soddisfano la definizione di invariante così
-- come formalizzata dalla regola H-While
vc : Acom -> Assn -> Set
vc SKIP Q = ⊤
vc (x := a) Q = ⊤
vc (C₁ :: C₂) Q = vc C₁ (pre C₂ Q) ∧ vc C₂ Q
vc (IF b THEN C₁ ELSE C₂) Q = vc C₁ Q ∧ vc C₂ Q
{-
    pre (WHILE[ I ] b DO C) Q ≡ I
    
                                            vc C I
                                       ------------------- IH
        I ∧ b == true ==> pre C I      [ pre C I ] C [ I ]
        -------------------------------------------------- H-Str
            [ I ∧ b == true ] C [ I ]
        ------------------------------------- H-While
        [ I ] WHILE b DO C [ I ∧ b == false ]   I ∧ b == false ==> Q
        ------------------------------------------------------------- H-Weak
                            [ I ] WHILE b DO C [ Q ]
-}
vc (WHILE[ I ] b DO C) Q = (∀ s -> I s ∧ bval b s == true  -> pre C I s) ∧
                           (∀ s -> I s ∧ bval b s == false -> Q s) ∧
                           vc C I

vc-sound : ∀ {Q : Assn} C -> vc C Q -> |- [ pre C Q ] strip C [ Q ]
vc-sound SKIP _ = H-Skip
vc-sound (x := a) _ = H-Loc
{-
    [ pre C₁ (pre C₂ Q) ] C₁ [ pre C₂ Q ]    [ pre C₂ Q ] C₂ [ Q ]
    -------------------------------------------------------------- H-Comp
                [ pre C₁ (pre C₂ Q) ] C₁ :: C₂ [ Q ]

    pre (C₁ :: C₂) Q ≡  pre C₁ (pre C₂ Q)
-}
vc-sound {Q} (C₁ :: C₂) (hp1 , hp2) = H-Comp HI1 HI2
    where
        HI1 : |- [ pre C₁ (pre C₂ Q) ] strip C₁ [ pre C₂ Q ]
        HI1 = vc-sound C₁ hp1

        HI2 : |- [ pre C₂ Q ] strip C₂ [ Q ]
        HI2 = vc-sound C₂ hp2
vc-sound {Q} (IF b THEN C₁ ELSE C₂) (hp1 , hp2) = H-If if-true if-false
    where
        IH1 : |- [ pre C₁ Q ] strip C₁ [ Q ]
        IH1 = vc-sound C₁ hp1

        case-true : ∀ s -> pre (IF b THEN C₁ ELSE C₂) Q s ∧ bval b s == true -> pre C₁ Q s
        case-true s (hp3 , hp4) rewrite hp4 = hp3

        -- hp4 : bval b s == true
        -- hp3 : pre (IF b THEN c₁ ELSE c₂) Q s | bval b s

        if-true : |- [ (λ s -> pre (IF b THEN C₁ ELSE C₂) Q s ∧ bval b s == true) ] strip C₁ [ Q ]
        if-true = H-Str case-true IH1
    
        IH2 : |- [ pre C₂ Q ] strip C₂ [ Q ]
        IH2 = vc-sound C₂ hp2

        case-false : ∀ s -> pre (IF b THEN C₁ ELSE C₂) Q s ∧ bval b s == false -> pre C₂ Q s
        case-false s (hp5 , hp6) rewrite hp6 = hp5
    
        -- hp6 : bval b s == false
        -- hp5 : pre (IF b THEN C₁ ELSE C₂) Q s | bval b s

        if-false : |- [ (λ s -> pre (IF b THEN C₁ ELSE C₂) Q s ∧ bval b s == false) ] strip C₂ [ Q ]
        if-false = H-Str case-false IH2
{-
    hp3 : vc C I
    hp2 : (s : State) -> I s ∧ bval b s == false -> Q s
    hp1 : (s : State) -> I s ∧ bval b s == true -> pre C I s
-}
vc-sound {Q} (WHILE[ I ] b DO C) (hp1 , hp2 , hp3) = H-Weak while-concl hp2
    where
        IH : |- [ pre C I ] strip C [ I ]
        IH = vc-sound C hp3

        while-concl : |- [ I ] WHILE b DO strip C [ (λ s -> I s ∧ bval b s == false) ]
        while-concl = H-While (H-Str hp1 IH)
{- 
    In pratica per verificare che |- [ P ] c [ Q ] 
    si parte da un comando annotato C tale che strip C ≡ c si  dimostra che

    vc C Q
    
    P ==> pre C Q

    La conclusione segue dal lemma vc-sound e dalla regola H-Str
    
-}