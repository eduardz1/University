module Library.Logic.Laws where

open import Library.Logic

ex-falso : ∀{A : Set} -> ⊥ -> A
ex-falso ()

contradiction : ∀{A : Set} -> A -> ¬ A -> ⊥
contradiction x ¬x = ¬x x

contraposition : ∀{A B : Set} -> (A -> B) -> ¬ B -> ¬ A
contraposition f nb a = nb (f a)
