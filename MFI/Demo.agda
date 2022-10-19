module Demo where

open import Library.Equality
open import Library.Equality.Reasoning
open import Library.Nat
open import Library.Nat.Properties

-- definizione del fibonacciano in tempo O(φⁿ) dove φ è la sezione aurea

fibo : ℕ → ℕ
fibo 0 = 0
fibo 1 = 1
fibo (succ (succ n)) = fibo n + fibo (succ n)


{-  
    definizione del fibonacciano in tempo O(n) per mezzo di una funzione wrapper
    "fast-fibo"
    
    immagina m n come due indici che scorrono lungo la sequenza di fibonacci
    0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
    e k decresce man mano che m e n avanzano

    La versione equivalente in C con tail recursion è la seguente:

    int fibo(int n) {
        int m = 0, k = 1;
        while (n > 0) {
            k = m + k;
            m = k - m;
            n = n - 1;
        }
        return m;
    }

    In Agda c'è il problema della forte normalizzazione a ddifferenza di Haskell,
    ciò rende un po' più complicato definire ad esmepio il segno meno
-}

fibo-from : ℕ → ℕ → ℕ → ℕ -- isomorfo a ℕ × ℕ × ℕ → ℕ perché basato su Haskell
fibo-from m n 0 = m
fibo-from m n 1 = n
fibo-from m n (succ (succ k)) = fibo-from n (m + n) (succ k)

fast-fibo : ℕ → ℕ
fast-fibo n = fibo-from 0 1 n

-- dimostriamo adesso che fast-fibo e fibo sono equivalenti, leggi bene la
-- spiegazione che ha fatto Padovani sul libro

lemma : ∀(k i : ℕ) -> fibo-from (fibo k) (fibo (succ k)) i == fibo (i + k)
lemma k 0 = refl
lemma k 1 = refl
lemma k (succ (succ i)) =
  begin
    fibo-from (fibo (succ k)) (fibo k + fibo (succ k)) (succ i) ==⟨⟩
    fibo-from (fibo (succ k)) (fibo (succ (succ k))) (succ i)
      ==⟨ lemma (succ k) (succ i) ⟩ -- ricorsione cioè ipotesi induttiva
    fibo (succ i + succ k) ==⟨⟩ -- vuol dire nessuna legge è stata applicata salvo la riscrittura
    fibo (succ (i + succ k))
      ==⟨ cong (λ x -> fibo (succ x)) (+-comm i (succ k)) ⟩
    fibo (succ (succ k + i)) ==⟨⟩
    fibo (succ (succ (k + i)))
      ==⟨ cong (λ x -> fibo (succ (succ x))) (+-comm k i) ⟩
    fibo (succ (succ (i + k)))
  end

theorem : ∀(k : ℕ) -> fast-fibo k == fibo k
theorem k =
  begin
    fast-fibo k     ==⟨⟩
    fibo-from 0 1 k ==⟨ lemma 0 k ⟩
    fibo (k + 0)    ==⟨ cong fibo (+-unit-r k) ⟩
    fibo k
  end