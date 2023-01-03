module ConjDisj where

open import Library.Nat
open import Library.Fun

-- Prop = Set = Type

-- Nella semantica BHK delle proposizioni logiche si ha che

-- A : Set è inizionisticamente valida se esiste un'evidenza e : A

-- implicazione f : A → B dove f è una traformazione tale che, dato a : A si ottiene f : a  : B
-- quantificaore universale: f : ∀(x : A) → B x se per ogni a : A si ha f a : B a dove B : A → Set

-- evidenze delle formule atomiche:
    -- eguaglianza: e : t == x se e è una derivazione nella logica equazionale di t == s

-- -----------
-- CONJUNCTION
-- -----------

data _∧_ (A B : Set) : Set where
  _,_ : A → B → A ∧ B

infixr 3 _∧_
infixr 4 _,_

fst : ∀{A B : Set} → A ∧ B → A
fst (x , y) = x
{-

Corrisponde a:

    A ∧ B
    -----∧E₁
      A

-}

snd : ∀{A B : Set} → A ∧ B → B
snd (x , y) = y
{-

Corrisponde a:

    A ∧ B
    -----∧E₂
      B

-}

-- -----------
-- DISJUNCTION
-- -----------

-- e : A ∨ B se e è un'evidenza di A oppure di B con l'indicazione di quelle delle due possiblità

{-

      A                B
    -----∨I₁    e    -----∨I₂
    A ∨ B            A ∨ B

-}

∧-comm : ∀{A B : Set} → A ∧ B → B ∧ A
∧-comm (x , x₁) = x₁ , x  -- qui devi partire da C-r per raffinare il goal, una volta fatto ciò puoi ricavare la soluzione automaticamente con C-a per entrambi i goal 
-- puoi anche scriverlo come: ∧-comm = λ x → snd x , fst x 


data _∨_ (A B : Set) : Set where
    inl : A -> A ∨ B -- "inject left"
    inr : B -> A ∨ B -- "inject right"

infixr 2 _∨_

-- Se x : A allora inl x : A + B; se y : B allora inr y : A + B

{-
                 [A]^i [B]^j
                  ⋮      ⋮
         A ∨ B    C     C
   -i,-j -----------------∨E
                  C

-}

∨-elim : ∀{A B C : Set} → (A → C) → (B → C) → A ∨ B → C
∨-elim f g (inl x) = f x -- "eliminate left", ho bisogno di una funzione da A a C quindi posso prendere f e applicarci x
∨-elim f g (inr x) = g x -- "eliminate right", ho bisogno di una funzione da B a C quindi posso prendere g e applicarci x


-- Distributività dell'and sull'or

_<=>_ : Set -> Set -> Set
A <=> B = (A -> B) ∧ (B -> A)

infix 2 _<=>_

∧∨-dist : ∀{A B C : Set} → (A ∧ (B ∨ C)) <=> ((A ∧ B) ∨ (A ∧ C))
∧∨-dist {A} {B} {C} = only-if , if
    where -- usato per definire helper functions
        only-if : A ∧ (B ∨ C) → (A ∧ B) ∨ (A ∧ C)
        only-if (x , inl x₁) = inl (x , x₁)
        only-if (x , inr x₁) = inr (x , x₁)

        if : (A ∧ B) ∨ (A ∧ C) → A ∧ (B ∨ C)
        if (inl (x , x₁)) = x , inl x₁
        if (inr (x , x₁)) = x , inr x₁