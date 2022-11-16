module Library.WellFounded where

data Accessible {A : Set} (_<_ : A -> A -> Set) (x : A) : Set where
  acc : ((y : A) -> y < x -> Accessible _<_ y) -> Accessible _<_ x

WellFounded : {A : Set} -> (A -> A -> Set) -> Set
WellFounded {A} _<_ = (x : A) -> Accessible _<_ x

accessible-m : {A B : Set} (_<A_ : A -> A -> Set) (_<B_ : B -> B -> Set)
               (f : A -> B) -> ({x y : A} -> x <A y -> f x <B f y) ->
               (x : A) -> Accessible _<B_ (f x) -> Accessible _<A_ x
accessible-m _<A_ _<B_ f m x (acc g) =
  acc λ y lt -> accessible-m _<A_ _<B_ f m y (g (f y) (m lt))

well-founded-m : {A B : Set} (_<A_ : A -> A -> Set) (_<B_ : B -> B -> Set)
                 (f : A -> B) -> ({x y : A} -> x <A y -> f x <B f y) ->
                 WellFounded _<B_ -> WellFounded _<A_
well-founded-m _<A_ _<B_ f m wf x = accessible-m _<A_ _<B_ f m x (wf (f x))


-- induction principle

-- weak-induction : {P : ℕ -> Set} -> P 0 -> ((x : ℕ) -> P x -> P (succ x)) -> (x : ℕ) -> P x
-- weak-induction p f zero = p
-- weak-induction p f (succ x) = f x (weak-induction p f x)

-- strong-induction : {P : ℕ -> Set} ->
--   ((x : ℕ) -> ((y : ℕ) -> y < x -> P y) -> P x) ->
--   (x : ℕ) -> P x
-- strong-induction f x = {!!}
