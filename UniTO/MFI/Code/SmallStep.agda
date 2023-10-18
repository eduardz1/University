module SmallStep where

open import Library.Bool
open import Library.Nat
open import Library.Nat.Properties
open import Library.Logic
open import Library.Logic.Laws
open import Library.Equality
open import Library.Equality.Reasoning

open import AexpBexp
open import BigStep

data _⟶_ : Config -> Config -> Set where  -- the symbol ⟶ is written \-->
    Loc : ∀{x a s}
          --------------------------------------------------
          -> ⦅ x := a , s ⦆ ⟶ ⦅ SKIP , s [ x ::= aval a s ] ⦆

    Comp₁ : ∀{c s}
            -------------------------------
            -> ⦅ SKIP :: c , s ⦆ ⟶ ⦅ c , s ⦆
        
    Comp₂ : ∀{c₁ c₁′ c₂ s s′}
            -> ⦅ c₁ , s ⦆ ⟶ ⦅ c₁′ , s′ ⦆
            ---------------------------------------
            -> ⦅ c₁ :: c₂ , s ⦆ ⟶ ⦅ c₁′ :: c₂ , s′ ⦆
        
    IfTrue  : ∀{b s c₁ c₂}
              -> bval b s == true
              -------------------------------------------
              -> ⦅ IF b THEN c₁ ELSE c₂ , s ⦆ ⟶ ⦅ c₁ , s ⦆
            
    IfFalse : ∀{b s c₁ c₂}
              -> bval b s == false
              -------------------------------------------
              -> ⦅ IF b THEN c₁ ELSE c₂ , s ⦆ ⟶ ⦅ c₂ , s ⦆
            
    While : ∀{b c s}
            --------------------------------------------------------------------------
            -> ⦅ WHILE b DO c , s ⦆ ⟶ ⦅ IF b THEN (c :: (WHILE b DO c)) ELSE SKIP , s ⦆


-- Definition of -->* as a reflexive and transitive closure of -->
-- ⦅ c , s ⦆ -->* ⦅ c' , s' ⦆ is equivalent to
-- ⦅ c , s ⦆ == ⦅ c₀ , s₀ ⦆ --> ⦅ c₁ , s₁ ⦆ --> ... --> ⦅ cₖ , sₖ ⦆ == ⦅ c' , s' ⦆

data  _⟶*_ : Config -> Config -> Set where
    ⟶*-refl : ∀ {c s} -> ⦅ c , s ⦆ ⟶* ⦅ c , s ⦆  -- reflexivity, case k == 0

    ⟶*-incl : ∀ {c₁ s₁ c₂ s₂ c₃ s₃} ->         -- including ⟶
                ⦅ c₁ , s₁ ⦆ ⟶ ⦅ c₂ , s₂ ⦆ ->
                ⦅ c₂ , s₂ ⦆ ⟶* ⦅ c₃ , s₃ ⦆ ->
                ---------------------------
                ⦅ c₁ , s₁ ⦆ ⟶* ⦅ c₃ , s₃ ⦆

⟶*-tran : ∀ {c₁ s₁ c₂ s₂ c₃ s₃} ->
          ⦅ c₁ , s₁ ⦆ ⟶* ⦅ c₂ , s₂ ⦆ ->
          ⦅ c₂ , s₂ ⦆ ⟶* ⦅ c₃ , s₃ ⦆ ->
          ⦅ c₁ , s₁ ⦆ ⟶* ⦅ c₃ , s₃ ⦆
⟶*-tran ⟶*-refl hp2 = hp2
⟶*-tran (⟶*-incl x hp1) hp2 = ⟶*-incl x (⟶*-tran hp1 hp2)

-- Relationship between big-step and small-step semantics in IMP
-- ∀ c, s, t . ⦅ c , s ⦆ => t <=> ⦅ c , s ⦆ -->* ⦅ SKIP , t ⦆

⦅_,_⦆∎ : ∀ c s -> ⦅ c , s ⦆ ⟶* ⦅ c , s ⦆
⦅ c , s ⦆∎ = ⟶*-refl

⦅_,_⦆⟶⟨_⟩_ : ∀ c s {c' c'' s' s''} ->
             ⦅ c , s ⦆ ⟶ ⦅ c' , s' ⦆ ->
             ⦅ c' , s' ⦆ ⟶* ⦅ c'' , s'' ⦆ ->
             ⦅ c , s ⦆ ⟶* ⦅ c'' , s'' ⦆
⦅ c , s ⦆⟶⟨ x ⟩ y = ⟶*-incl x y

⦅_,_⦆⟶*⟨_⟩_ : ∀ c s {c' c'' s' s''} ->
             ⦅ c , s ⦆ ⟶* ⦅ c' , s' ⦆ ->
             ⦅ c' , s' ⦆ ⟶* ⦅ c'' , s'' ⦆ ->
             ⦅ c , s ⦆ ⟶* ⦅ c'' , s'' ⦆

⦅ c , s ⦆⟶*⟨ x ⟩ y = ⟶*-tran x y

lemma-small-big : ∀{c₁ c₂ s₁ s₂ t} -> ⦅ c₁ , s₁ ⦆ ⟶ ⦅ c₂ , s₂ ⦆ -> 
                                      ⦅ c₂ , s₂ ⦆ => t -> 
                                      ⦅ c₁ , s₁ ⦆ => t
lemma-small-big Loc Skip  = Loc
lemma-small-big Comp₁ hp₂ = Comp Skip hp₂
lemma-small-big (Comp₂ hp₁) (Comp hp₂ hp₃) = Comp (lemma-small-big hp₁ hp₂) hp₃
lemma-small-big (IfTrue x) hp₂  = IfTrue x hp₂
lemma-small-big (IfFalse x) hp₂ = IfFalse x hp₂
lemma-small-big While (IfTrue x (Comp hp₂ hp₃)) = WhileTrue x hp₂ hp₃
lemma-small-big While (IfFalse x Skip) = WhileFalse x

theorem-small-big : ∀{c s t} -> ⦅ c , s ⦆ ⟶* ⦅ SKIP , t ⦆ -> ⦅ c , s ⦆ => t
theorem-small-big ⟶*-refl        = Skip
theorem-small-big (⟶*-incl x hp) = lemma-small-big x (theorem-small-big hp)

lemma-big-small : ∀{c c' c'' s s'} ->
                  ⦅ c , s ⦆ ⟶* ⦅ c' , s' ⦆ ->
                  ⦅ c :: c'' , s ⦆ ⟶* ⦅ c' :: c'' , s' ⦆
lemma-big-small ⟶*-refl = ⟶*-refl
lemma-big-small (⟶*-incl x hp) = ⟶*-incl (Comp₂ x) (lemma-big-small hp)

theorem-big-small : ∀{c s t} -> ⦅ c , s ⦆ => t -> ⦅ c , s ⦆ ⟶* ⦅ SKIP , t ⦆
theorem-big-small Skip = ⟶*-refl
theorem-big-small Loc = ⟶*-incl Loc ⟶*-refl
theorem-big-small (Comp {c₁} {c₂} {s₁} {s₂} {s₃} hyp hyp₁) =
                  ⦅ c₁ :: c₂ , s₁ ⦆⟶*⟨ lemma-big-small (theorem-big-small hyp)⟩
                  -- (theorem-big-small hyp) : ⦅ c₁ , s₁ ⦆ ⟶* ⦅ SKIP , s₂ ⦆
                  ⦅ SKIP :: c₂ , s₂ ⦆⟶⟨ Comp₁ ⟩
                  ⦅ c₂ , s₂ ⦆⟶*⟨ theorem-big-small hyp₁ ⟩
                  ⦅ SKIP , s₃ ⦆∎ 
theorem-big-small (IfTrue x hp) = ⟶*-incl (IfTrue x) (theorem-big-small hp)
theorem-big-small (IfFalse x hp) = ⟶*-incl (IfFalse x) (theorem-big-small hp)
theorem-big-small (WhileFalse x) = ⟶*-incl While (⟶*-incl (IfFalse x) ⟶*-refl)
theorem-big-small (WhileTrue {c} {b} {s} {s₂} {s₃} x hyp hyp₁) =
                  ⦅ WHILE b DO c , s ⦆⟶⟨ While ⟩
                  ⦅ IF b THEN c :: (WHILE b DO c) ELSE SKIP , s ⦆⟶⟨ IfTrue x ⟩
                  ⦅ c :: (WHILE b DO c) , s ⦆⟶*⟨ lemma-big-small (theorem-big-small hyp)⟩
                  ⦅ SKIP :: (WHILE b DO c) , s₂ ⦆⟶⟨ Comp₁ ⟩
                  ⦅ WHILE b DO c , s₂ ⦆⟶*⟨ theorem-big-small hyp₁ ⟩
                  ⦅ SKIP , s₃ ⦆∎

corollary : ∀{c s t} -> ⦅ c , s ⦆ ⟶* ⦅ SKIP , t ⦆ <=> ⦅ c , s ⦆ => t
corollary = theorem-small-big , theorem-big-small