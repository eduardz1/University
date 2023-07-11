module HoareSoundness where

open import Library.Bool
open import Library.Nat
open import Library.Nat.Properties
open import Library.Logic
open import Library.Logic.Laws
open import Library.Equality
open import Library.Equality.Reasoning

open import HoareLogic
open import AexpBexp
open import BigStep

-- Una triple {P} c {Q} è valida se per ogni s, t ∈ State se
-- s |= P e ⦅c, s⦆ => t allora t |= Q

-- ^^^ correttezza debole

|=_ : Triple -> Set
|= [ P ] c [ Q ] = ∀ {s t} -> P s -> ⦅ c , s ⦆ => t -> Q t

-- Teorema di correttezza: se |- [ P ] c [ Q ] allora |= [ P ] c [ Q ]
-- AKA se la tripla è derivabile allora è valida

lemma-Hoare-inv : ∀ {P : Assn} {s b c t} ->
                  -- P è invariante per c per tutti gli stati s' per cui b è 
                  -- vero e c converge a un qualche t' allora P è vero per t'
                  (∀{s' t'} -> (P s' ∧ bval b s' == true) -> ⦅ c , s' ⦆ ⇒ t' -> P t') ->
                  P s -> -- P è vero per s
                  ⦅ WHILE b DO c , s ⦆ ⇒ t -> -- WHILE b DO c converge a t
                  P t -- allora P è vero per t
lemma-Hoare-inv hp Ps (WhileFalse x) = Ps
lemma-Hoare-inv hp Ps (WhileTrue x cs⇒s' W') = lemma-Hoare-inv hp Ps' W'
    where
        Ps' = hp (Ps , x) cs⇒s'

lemma-Hoare-loop-exit : ∀ {b c s t} ->
                        ⦅ WHILE b DO c , s ⦆ ⇒ t -> -- se WHILE b DO c converge a t
                        bval b t == false -- allora b è falso per t dopo l'uscita
lemma-Hoare-loop-exit (WhileFalse x) = x
lemma-Hoare-loop-exit (WhileTrue x hp hp₁) = lemma-Hoare-loop-exit hp₁

lemma-Hoare-sound : ∀ {P c Q s t} -> |- [ P ] c [ Q ] -> P s -> ⦅ c , s ⦆ => t -> Q t
lemma-Hoare-sound H-Skip Ps Skip = Ps
lemma-Hoare-sound H-Loc Ps Loc   = Ps
lemma-Hoare-sound (H-Comp ⊢PcQ ⊢PcQ₁) Ps (Comp cs⇒t cs⇒t₁) = lemma-Hoare-sound ⊢PcQ₁ Ps₁ cs⇒t₁
    where
        Ps₁ = lemma-Hoare-sound ⊢PcQ Ps cs⇒t
lemma-Hoare-sound (H-If ⊢PcQ ⊢PcQ₁) Ps (IfTrue x cs⇒t)  = lemma-Hoare-sound ⊢PcQ  (Ps , x) cs⇒t
lemma-Hoare-sound (H-If ⊢PcQ ⊢PcQ₁) Ps (IfFalse x cs⇒t) = lemma-Hoare-sound ⊢PcQ₁ (Ps , x) cs⇒t
lemma-Hoare-sound (H-While ⊢PcQ) Ps (WhileFalse x) = Ps , x
lemma-Hoare-sound (H-While ⊢PcQ) Ps (WhileTrue x cs⇒t cs⇒t₁) = Pt , b-false
    where
        Ps₁ = lemma-Hoare-sound ⊢PcQ (Ps , x) cs⇒t
        Pt  = lemma-Hoare-inv (λ { (a , b) c -> lemma-Hoare-sound ⊢PcQ (a , b) c}) Ps₁ cs⇒t₁
        b-false = lemma-Hoare-loop-exit cs⇒t₁
lemma-Hoare-sound {s = s} {t = t} (H-Conseq P⇒P₁ ⊢P₁cQ₁ Q₁⇒Q) Ps cs⇒t = Qt
    {-
        P⇒P₁ : P ==> P₁
        ⊢P₁cQ₁ : |- [ P₁ ] c [ Q₁ ]
        Q₁⇒Q : Q₁ ==> Q
    -}
    where
        P₁s = P⇒P₁ s Ps -- P₁ s
        Q₁t = lemma-Hoare-sound ⊢P₁cQ₁ P₁s cs⇒t -- Q₁ t
        Qt  = Q₁⇒Q t Q₁t -- Q t

theorem-Hoare-sound : ∀ {P c Q} -> |- [ P ] c [ Q ] -> |= [ P ] c [ Q ]
theorem-Hoare-sound ⊢PcQ = lemma-Hoare-sound ⊢PcQ
