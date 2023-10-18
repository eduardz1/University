module HoareCompleteness where

open import Library.Bool
open import Library.Nat
open import Library.Nat.Properties
open import Library.Logic
open import Library.Logic.Laws
open import Library.Equality
open import Library.Equality.Reasoning

open import AexpBexp
open import BigStep
open import HoareLogic
open import HoareSoundness


-- Completeness of Hoare Logic is the opposite of Soundness.
-- |= [ P ] c [ Q ] ==> |- [ P ] c [ Q ]

{-

    Idea di Dijkstra:
    i comandi sono delle trasformazioni di stato.

    Idea di Cook:
    usiamo le weakest precondition di Dijkstra.

    ⟦ P ⟧ = {s ∈ State | P s} ⟦ c ⟧ : State -> State (parziale, ad esempio 
                                                    'WHILE true DO' è indefinito
                                                     ovunque)

    ⟦ wp c Q ⟧ = {s ∈ State | ⟦ c ⟧(s) ∈ ⟦ Q ⟧} dove ⟦ c ⟧(s) = t se ⦅ c , s ⦆ => t

-}

wp : Com -> Assn -> Assn
wp c Q s = ∀ t -> ⦅ c , s ⦆ => t -> Q t

{-
    È ovvio che |= [ wp c Q ] c [ Q ] per definizione di wp.

    Verifichiamo che per ogni P

    |= [ P ] c [ Q ] -> P ==> wp c Q

    dove osserviamo che P ==> wp c Q equivale a ⟦ P ⟧ ⊆ ⟦ wp c Q ⟧

-}

Fact : ∀ {P c Q} -> |= [ P ] c [ Q ] -> (∀ s -> P s -> wp c Q s)
Fact {P} {c} {Q} ⊨PcQ s Ps = wp-c-Q-s
    where
        wp-c-Q-s : wp c Q s
        wp-c-Q-s = λ t → ⊨PcQ Ps

wp-lemma : ∀ c {Q} -> |- [ wp c Q ] c [ Q ]
{-
                           ---------------- H-Skip
    wp SKIP Q ==> Q        [ Q ] SKIP [ Q ]
    --------------------------------------- H-Str
           [ wp SKIP Q ] SKIP [ Q ]
-}
wp-lemma SKIP {Q} = H-Str S-prem H-Skip
    where
        S-prem : wp SKIP Q ==> Q
        S-prem s hp = hp s Skip -- hp = wp SKIP Q s
{-
                                                                 ------------------------------------------------- H-Loc
     wp (x := a) Q ==> (λ s → Q (s [ x ::= aval a s ]))          [ (λ s → Q (s [ x ::= aval a s ])) ] x := a [ Q ]
    -------------------------------------------------------------------------------------------------------------- H-Str
                        [ wp (x := a) Q ] x := a [ Q ]

-}
wp-lemma (x := a) {Q} = H-Str S-prem H-Loc
    where
        S-prem : wp (x := a) Q ==> (λ s → Q (s [ x ::= aval a s ]))
        S-prem s hp = hp (s [ x ::= aval a s ]) Loc -- hp = wp (x := a) Q s
{-
    se parto dal presupposto che: wp (c₁ :: c₂) Q ==> wp c₁ (wp c₂ Q)
    allora:

                                                    ---------------------------------- IH₁   -------------------- IH₂
                                                    [ wp c₁ (wp c₂ Q) ] c₁ [ wp c₂ Q ]       [ wp c₂ Q ] c₂ [ Q ]
                                                    ------------------------------------------------------------- H-Comp
    wp (c₁ :: c₂) Q ==> wp c₁ (wp c₂ Q)                            [ wp c₁ (wp c₂ Q) ] c₁ :: c₂ [ Q ]
    ------------------------------------------------------------------------------------------------- H-Str
                                    [ wp (c₁ :: c₂) Q ] c₁ :: c₂ [ Q ]
-}
wp-lemma (c₁ :: c₂) {Q} = H-Str L-prem (H-Comp IH₁ IH₂)
    where
        IH₁ : |- [ wp c₁ (wp c₂ Q) ] c₁ [ wp c₂ Q ]
        IH₁ = wp-lemma c₁ {wp c₂ Q}

        IH₂ : |- [ wp c₂ Q ] c₂ [ Q ]
        IH₂ = wp-lemma c₂ {Q}

        L-prem : wp (c₁ :: c₂) Q ==> wp c₁ (wp c₂ Q)
        L-prem s hp t ⦅c₁,s⦆⇒t r ⦅c₂,t⦆⇒r = hp r (Comp ⦅c₁,s⦆⇒t ⦅c₂,t⦆⇒r) -- hp = wp (c₁ :: c₂) Q s
{-
    [ P-true ] c₁ [ Q ]                   [ P-false ] c₂ [ Q ]
    ---------------------------------------------------------- H-If
    [ wp (IF b THEN c₁ ELSE c₂) Q ] IF b THEN c₁ ELSE c₂ [ Q ]

                           -------------------- IH1
    P-true ==> wp c₁ Q     [ wp c₁ Q ] c₁ [ Q ]
    ------------------------------------------- H-Str
                 [ P-true ] c₁ [ Q ]

    analogamente per P-false e wp c₁ Q
-}
wp-lemma (IF b THEN c₁ ELSE c₂) {Q} = H-If T-prem F-prem
    where
        P-true  = (λ s → wp (IF b THEN c₁ ELSE c₂) Q s ∧ bval b s == true)
        P-false = (λ s → wp (IF b THEN c₁ ELSE c₂) Q s ∧ bval b s == false)

        IH₁ : |- [ wp c₁ Q ] c₁ [ Q ]
        IH₁ = wp-lemma c₁ {Q}

        IH₂ : |- [ wp c₂ Q ] c₂ [ Q ]
        IH₂ = wp-lemma c₂ {Q}

        lemma-T-prem : P-true ==> wp c₁ Q
        lemma-T-prem s (wpIf , b≡true) t ⦅c₁,s⦆⇒t = wpIf t (IfTrue b≡true ⦅c₁,s⦆⇒t)

        T-prem : |- [ P-true ] c₁ [ Q ]
        T-prem = H-Str lemma-T-prem IH₁

        lemma-F-prem : P-false ==> wp c₂ Q
        lemma-F-prem s (wpIf , b≡false) t ⦅c₂,s⦆⇒t = wpIf t (IfFalse b≡false ⦅c₂,s⦆⇒t)
        
        F-prem : |- [ P-false ] c₂ [ Q ]
        F-prem = H-Str lemma-F-prem IH₂
{-
                            ------------------ IH
    P-true ==> wp c P       [ wp c P ] c [ P ]
    ------------------------------------------ H-Str
            [ P-True ] c [ P ]
    ------------------------------ H-While
    [ P ] WHILE b DO c [ P-false ]                    P-false ==> Q
    --------------------------------------------------------------- H-Weak
            [ wp (WHILE b DO c) Q ] WHILE b DO c [ Q ]

    P s ≡ wp (WHILE b DO c) Q s ≡ ∀ t -> ⦅ WHILE b DO c , s ⦆ ⇒ t -> Q t

-}
wp-lemma (WHILE b DO c) {Q} = H-Weak (H-While (H-Str PwcP IH)) PfalseQ
  where
    P = wp (WHILE b DO c) Q
    P-true  = λ s → P s ∧ bval b s == true
    P-false = λ s → P s ∧ bval b s == false

    IH : |- [ wp c P ] c [ P ]
    IH = wp-lemma c {P}

    PwcP : P-true ==> wp c P
    PwcP s (Ps , b=true) t ⦅c,s⦆⇒t r ⦅WHILEbDOc,t⦆⇒r = Ps r (WhileTrue b=true ⦅c,s⦆⇒t ⦅WHILEbDOc,t⦆⇒r) 

    PfalseQ : P-false ==> Q
    PfalseQ s (Ps , b=false) = Ps s (WhileFalse b=false)


-- Possiamo adesso dimostrare il teorema di completezza

{-
    Fin qui abbiamo stabilito:

    Fact : ∀{P c Q} → |= [ P ] c [ Q ] → (∀ s → P s → wp c Q s)

    wp-lemma : ∀ c {Q} → |- [ wp c Q ] c [ Q ]


    Usiamo questi due lemmi come segue:
    
      Fact ⊨PcQ           wp-lemma c {Q}
    ------------       ------------------
    P ==> wp c Q       [ wp c Q ] c [ Q ]
    ------------------------------------- H-Str
             [ P ] c [ Q ]
-}

completeness : ∀ (c : Com) {P Q : Assn} -> |= [ P ] c [ Q ] -> |- [ P ] c [ Q ]
completeness c {P} {Q} ⊨PcQ = H-Str prem lemma
    where
        prem : P ==> wp c Q
        prem = Fact ⊨PcQ

        lemma : |- [ wp c Q ] c [ Q ]
        lemma = wp-lemma c {Q}
