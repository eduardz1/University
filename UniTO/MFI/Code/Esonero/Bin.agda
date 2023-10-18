module Esonero.Bin where

open import Library.Nat
open import Library.Nat.Properties
open import Library.Equality
open import Library.Equality.Reasoning
open import Library.Logic

{- 1 - STRINGHE BINARIE

   Si consideri il tipi di dato Bin per la rappresntazione dei naturali
   in notazione binaria:
   
-}

data Bin : Set where
  ⟨⟩ : Bin
  _O : Bin → Bin
  _I : Bin → Bin

{- Ad esempio, la stringa binaria 1011, che rappresenta il numero undici, è codificata come

⟨⟩ I O I I

Le rappresentazioni con stringhe binarie non sono uniche a causa degli zeri a sinistra,
che possono essere in numero arbitrario: anche la stringa 001011 ovvero la sua codifica

⟨⟩ O O I O I I

rappresnta lo stesso numero di 1011.
-}

{-  ESERCIZIO 1-1

Si definisca la funzione

inc : Bin → Bin

che converte una stringa binaria in una di quelle che rappresntano il numero naturale successivo
a quello rappresntatato dalla stringa data.

Ad esmpio, poché 1100 codifica il numero dodici, dovremmo avere

inc (⟨⟩ I O I I) ≡ ⟨⟩ I I O O
-}

inc : Bin → Bin
inc ⟨⟩ = ⟨⟩ I
inc (b O) = b I
inc (b I) = inc b O

{- Quindi, usando inc si definiscano le funzioni -}

_∣_ : ℕ -> ℕ -> Set
x ∣ y = ∃[ z ] (z * x == y)

to : ℕ → Bin
to zero = ⟨⟩ O
to (succ zero) = ⟨⟩ I
to (succ (succ n)) = {!   !}

from : Bin → ℕ
from ⟨⟩ = 0
from (b O) = 0 + 2 * from b
from (b I) = 1 + 2 * from b

{- La prima trasforma un naturale in una stringa binaria che lo rappresenti;
   la seconda effettua la trasformazione inversa.
   Nella definizione di to si rappresnti lo zero con ⟨⟩ O, metre in quella di from
   si assegni zero anche alla stringa ⟨⟩.

   Verificate con C-c C-n alcuni esempi di tali funzioni.
-}

{- ESERCIZIO 1-2

   Si considerino le seguenti equazioni, in cui n : ℕ e b : Bin:

   from (inc b) == suc (from b)
   to (from b) == b
   from (to n) == n

   Per ciascuna di esse si fornisca una dimostrazione, se vale, oppure
   un controesempio in caso contrario.
-}

lemma : ∀(b : Bin) -> from (inc b) + from (inc b) == succ (succ (from b + from b))
lemma b = {!   !}

eq1 : ∀(b : Bin) -> from (inc b) == succ (from b)
eq1 ⟨⟩ = refl
eq1 (b O) = refl
eq1 (b I) rewrite +-comm (from (inc b)) 0 
                | +-comm (from b) 0
                | lemma b = refl

eq2 : ∀(b : Bin) -> to (from b) == b
eq2 ⟨⟩ = {!   !}
eq2 (b O) = {!   !}
eq2 (b I) = {!   !}

eq3 : ∀(n : ℕ) -> from (to n) == n
eq3 zero = refl
eq3 (succ n) = {!   !}
