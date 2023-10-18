module Esonero.MultMono where

open import Library.Nat
open import Library.Nat.Properties

{- 2 - MONOTONICITA' DELLA MOLTIPLICAZIONE

   Si rammenti la definizione induttiva dell'ordine ≤ sui naturali:
-}

data _≤_ : ℕ → ℕ → Set where

  le-zero : ∀{x : ℕ}
             ------
            → 0 ≤ x
  
  le-succ : ∀{x y : ℕ}
            → x ≤ y
             ----------------
            → succ x ≤ succ y

infix 4 _≤_

{- La relazione così definita è un ordine totale, ed in particolare è transitiva: -}
le-trans : ∀{x y z : ℕ} → x ≤ y → y ≤ z → x ≤ z
le-trans le-zero              _        = le-zero
le-trans (le-succ hyp1) (le-succ hyp2) = le-succ (le-trans hyp1 hyp2)

{- Si consideri la seguente dimostrazione della monotonicità dell'addizione: -}

+-mono-r : ∀(m n p : ℕ) → m ≤ n → p + m ≤ p + n
+-mono-r m n zero hyp     = hyp
+-mono-r m n (succ p) hyp = le-succ (+-mono-r m n p hyp)

+-mono-l : ∀(m n p : ℕ) → m ≤ n → m + p ≤ n + p
+-mono-l m n p hyp
  rewrite +-comm m p | +-comm n p = +-mono-r m n p hyp

+-mono : ∀(m n p q : ℕ) → m ≤ n → p ≤ q → m + p ≤ n + q
+-mono m n p q hyp1 hyp2
   = le-trans (+-mono-l m n p hyp1) (+-mono-r p q n hyp2 )

{- ESERCIZIO 2

   Prendendo spunto dalla dimostrazione di +-mono si stabilisca il seguente teorema:
-}

*-mono-r : ∀(m n p : ℕ) -> m ≤ n -> p * m ≤ p * n
*-mono-r m n zero hp = le-zero
*-mono-r m n (succ p) hp = +-mono m n (p * m) (p * n) hp (*-mono-r m n p hp)

*-mono-l : ∀(m n p : ℕ) -> m ≤ n -> m * p ≤ n * p
*-mono-l m n p hp rewrite *-comm m p | *-comm n p = *-mono-r m n p hp

*-mono : ∀(m n p q : ℕ) → m ≤ n → p ≤ q → m * p ≤ n * q
*-mono m n p q hp₁ hp₂ = le-trans (*-mono-l m n p hp₁) (*-mono-r p q n hp₂)

{- Suggerimento: enunciare e provare il lemma *-mono-r analogamente
   a +-mono-r, in cui torna utile impiegare +-mono.
   Quindi si enunci e dimostri il lemma *-mono-l simile a +-mono-l usando la proprietà
   *-comm in Nat.Properties che stabilisce la commutatività di *.
-}

