module Lambda where

open import Library.Nat

-- Tipi Semplici
-- α è un tipo (atomico, ad esempio ℕ)
-- se A e B sono tipi, allora A -> B è un tipo

-- in Agda se A è un tipo semplice allora A : Set = Set₀ (Set₁ (Set₂ ...))

-- la freccia associa a destra:  A -> B -> C = A -> (B -> C)

-- x : A è un termine x di tipo A
-- se M : B e x : A allora λ (x : A) -> M : A -> B
-- se m : A -> B e N : A allora M N : B

-- l'applicazione associa a sinistra: M N P = (M N) P

{-

    M : A -> (B -> C)   N : A
    -------------------------
        M N : B -> C             L : B
        ------------------------------
                (M N) L : C

-}
