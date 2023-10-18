module Esonero.OrWeakAnd where

open import Library.Logic
open import Library.Logic.Laws

{- 4 - PROPRIETA' ∨-weak-∧

   ESERCIZIO 4-1

   Si dimostri la seguente proprietà dei connettivi ∧ e ∨:
-}

∨-weak-∧ : ∀{A B C : Set} → (A ∨ B) ∧ C → A ∨ (B ∧ C)
∨-weak-∧ (no x , x₁) = no x
∨-weak-∧ (yes x , x₁) = yes (x , x₁)

{- ESERCIZIO 4-2

   Si consideri l'implicazione inversa di ∨-weak-∧:

   A ∨ (B ∧ C) → (A ∨ B) ∧ C

   Se ne dimostri la validità, se del caso, ovvero la si refuti
   producendo un controesempio consitente in un'opportuna scelta
   A', B', C' tali che:

   ¬ (A' ∨ (B' ∧ C') → (A' ∨ B') ∧ C')

   dimostrando quest'ultimo asserto.

-}

fun : ∀{A B C : Set} -> ¬ (A ∨ (B ∧ C) → (A ∨ B) ∧ C)
fun {A} {B} {C} hp = {! lemma  !}
   where
      lemma : ∀{A B C : Set} -> A ∨ B ∧ C -> (A ∨ B) ∧ C -> ⊥
      lemma p q = ex-falso {!   !}