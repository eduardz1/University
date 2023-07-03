module BigStep where

open import Library.Bool
open import Library.Nat
open import Library.Nat.Properties
open import Library.Logic
open import Library.Logic.Laws
open import Library.Equality
open import Library.Equality.Reasoning

open import AexpBexp

-- The syntax of the commands is defined as follows:
-- Com ∋ c, c' ::= SKIP | x := a | c :: c' | IF b THEN c ELSE c' | WHILE b DO c

data Com : Set where
  SKIP  : Com                             -- inaction
  _:=_  : Vname → Aexp → Com              -- assignment
  _::_  : Com → Com → Com                 -- sequence
  IF_THEN_ELSE_ : Bexp → Com → Com → Com  -- conditional
  WHILE_DO_     : Bexp → Com → Com        -- iteration

--------------------------
-- Semantica Operazionale
--------------------------

data Config : Set where
    ⦅_,_⦆ : Com → State → Config

data _⇒_ : Config → State → Set  where

    Skip : ∀ {s}
         ----------------
         → ⦅ SKIP , s ⦆ ⇒ s

    Loc : ∀{x a s}
        ---------------------------------------
        → ⦅ x := a , s ⦆ ⇒ (s [ x ::= aval a s ])

    Comp : ∀{c₁ c₂ s₁ s₂ s₃}
         → ⦅ c₁ , s₁ ⦆ ⇒ s₂
         → ⦅ c₂ , s₂ ⦆ ⇒ s₃
           --------------------
         → ⦅ c₁ :: c₂ , s₁ ⦆ ⇒ s₃
       
    IfTrue : ∀{c₁ c₂ b s t}
           → bval b s == true
           → ⦅ c₁ , s ⦆ ⇒ t
             -------------------------------
           → ⦅ IF b THEN c₁ ELSE c₂ , s ⦆ ⇒ t
         
    IfFalse : ∀{c₁ c₂ b s t}
            → bval b s == false
            → ⦅ c₂ , s ⦆ ⇒ t
              -------------------------------
            → ⦅ IF b THEN c₁ ELSE c₂ , s ⦆ ⇒ t

    WhileFalse : ∀{c b s}
               → bval b s == false
                 -----------------------
               → ⦅ WHILE b DO c , s ⦆ ⇒ s
             
    WhileTrue  : ∀{c b s₁ s₂ s₃}
               → bval b s₁ == true
               → ⦅ c , s₁ ⦆ ⇒ s₂
               → ⦅ WHILE b DO c , s₂ ⦆ ⇒ s₃
                 ------------------------
               → ⦅ WHILE b DO c , s₁ ⦆ ⇒ s₃

infix 10 _⇒_

_=>_ = _⇒_

-- states that "while true" does not converge
lemma-while-true : ∀{c s t} -> ¬ (⦅ WHILE B true DO c , s ⦆ ⇒ t)
lemma-while-true (WhileTrue x hp₁ hp₂) = lemma-while-true hp₂


-- The relationship ⦅ c , s ⦆ ⇒ t is deterministic
true-neq-false : ¬ (true == false)
true-neq-false ()

theorem-det : ∀{c s t t'} -> ⦅ c , s ⦆ ⇒ t -> ⦅ c , s ⦆ ⇒ t' -> t == t'
theorem-det Skip Skip = refl
theorem-det Loc Loc   = refl
theorem-det (Comp h1 h2) (Comp h3 h4)
    rewrite theorem-det h1 h3
          | theorem-det h2 h4 = refl
theorem-det (IfTrue x h1) (IfTrue y h2)   = theorem-det h1 h2
theorem-det (IfFalse x h1) (IfFalse y h2) = theorem-det h1 h2
theorem-det (IfTrue x h1) (IfFalse y h2) rewrite x = ex-falso(true-neq-false y)
theorem-det (IfFalse x h1) (IfTrue y h2) rewrite y = ex-falso(true-neq-false x)
theorem-det (WhileFalse x) (WhileFalse y) = refl
theorem-det (WhileFalse x) (WhileTrue y h2 h3) rewrite y = ex-falso(true-neq-false x)
theorem-det (WhileTrue x h1 h2) (WhileFalse y) rewrite x = ex-falso(true-neq-false y)
theorem-det (WhileTrue x h1 h2) (WhileTrue y h3 h4) 
    rewrite theorem-det h1 h3
          | theorem-det h2 h4 = refl

---------------
-- Equivalence
---------------

-- For example we want to optimize a piece of code to make it run faster
-- without modifying the logic behind it

-- c ∼ c' if they behave in the same way 
_∼_ : Com -> Com -> Set -- written as \sim
c ∼ c' = ∀{s t} -> ( ⦅ c , s ⦆ => t <=> ⦅ c' , s ⦆ => t )

infixl 19 _∼_

lemma-if-true : ∀(c₁ c₂ : Com) -> IF B true THEN c₁ ELSE c₂ ∼ c₁
lemma-if-true c₁ c₂ {s} {t} = only-if , if
    where
        only-if : ⦅ IF B true THEN c₁ ELSE c₂ , s ⦆ => t -> ⦅ c₁ , s ⦆ => t
        only-if (IfTrue x hp) = hp

        if : ⦅ c₁ , s ⦆ => t -> ⦅ IF B true THEN c₁ ELSE c₂ , s ⦆ => t
        if hp = IfTrue refl hp

-- only true in our language because every expression terminates, say for 
-- example we're evaluating this in C, the boolean expression b might never
-- terminate or might diverge
lemma-if-c-c : ∀(b : Bexp) (c : Com) -> IF b THEN c ELSE c ∼ c
lemma-if-c-c b c {s} {t} = only-if , if
    where
        only-if : ⦅ IF b THEN c ELSE c , s ⦆ => t -> ⦅ c , s ⦆ => t
        only-if (IfTrue x hp)  = hp
        only-if (IfFalse x hp) = hp

        if : ⦅ c , s ⦆ => t -> ⦅ IF b THEN c ELSE c , s ⦆ => t
        if hp with lemma-bval-tot b s
        ... | inl x = IfTrue x hp
        ... | inr y = IfFalse y hp
