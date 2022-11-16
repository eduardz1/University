module Polymorphism where

open import Library.Bool
open import Library.Nat

id-Bool : Bool → Bool
id-Bool = λ (b : Bool) → b

id : ∀(A : Set) -> (x : A) -> A
id A x = x

-- _ : ℕ
-- _ = id 0 -- errore perché 0 non è un tipo ma un elemento di ℕ
-- _ = id ℕ 0 -- ok
-- _ = id _ 0 -- funziona ancora perché il tipo si può dedurre

id' : ∀{A : Set} -> (x : A) -> A -- nota che adesso usiamo le parentesi graffe, il tipo può eessere implicito
id' x = x -- stessa definizione di pirma ma non è più necessario specificare la A