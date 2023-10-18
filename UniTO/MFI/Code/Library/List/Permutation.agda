module Library.List.Permutation where

open import Library.Nat
open import Library.List
open import Library.List.Properties
open import Library.Logic
open import Library.Equality

infix  1 #begin_
infixr 2 _#⟨⟩_ _#⟨_⟩_
infix  3 _#end
infix  4 _#_

-- permutation = finite sequence of exchanges
data _#_ {A : Set} : List A -> List A -> Set where
  #refl  : {xs : List A} -> xs # xs
  #swap  : {x y : A} {xs : List A} -> x :: y :: xs # y :: x :: xs
  #cong  : {x : A} {xs ys : List A} -> xs # ys -> x :: xs # x :: ys
  #trans : {xs ys zs : List A} -> xs # ys -> ys # zs -> xs # zs

#symm : {A : Set} {xs ys : List A} -> xs # ys -> ys # xs
#symm #refl          = #refl
#symm #swap          = #swap
#symm (#cong ps)     = #cong (#symm ps)
#symm (#trans ps qs) = #trans (#symm qs) (#symm ps)

#begin_ : {A : Set} {xs ys : List A} -> xs # ys -> xs # ys
#begin_ ps = ps

_#end : {A : Set} (xs : List A) -> xs # xs
_#end xs = #refl

_#⟨_⟩_ : {A : Set} (xs : List A) {ys zs : List A} -> xs # ys -> ys # zs -> xs # zs
_#⟨_⟩_ _ = #trans

_#⟨⟩_ : {A : Set} (xs : List A) {ys : List A} -> xs # ys -> xs # ys
_ #⟨⟩ ps = ps

#length : {A : Set} {xs ys : List A} -> xs # ys -> length xs == length ys
#length #refl         = refl
#length #swap         = refl
#length (#cong π)     = cong succ (#length π)
#length (#trans π π') = tran (#length π) (#length π')

#push : {A : Set} {x : A} {xs ys : List A} -> x :: xs ++ ys # xs ++ x :: ys
#push {xs = []}     = #refl
#push {xs = _ :: _} = #trans #swap (#cong #push)

#all : {A : Set} {xs ys : List A} (P : A -> Set) -> xs # ys -> All P xs -> All P ys
#all P #refl         ps             = ps
#all P #swap         (px , py , ps) = py , px , ps
#all P (#cong π)     (px , ps)      = px , #all P π ps
#all P (#trans π π') ps             = #all P π' (#all P π ps)

++-permutation : {A : Set} (xs ys : List A) -> xs ++ ys # ys ++ xs
++-permutation [] ys rewrite ++-unit-r ys = #refl
++-permutation (x :: xs) ys =
  #begin
    (x :: xs) ++ ys #⟨⟩
    x :: xs ++ ys   #⟨ #push ⟩
    xs ++ x :: ys   #⟨ ++-permutation xs (x :: ys) ⟩
    (x :: ys) ++ xs #⟨⟩
    x :: ys ++ xs   #⟨ #push ⟩
    ys ++ x :: xs
  #end

#cong++r : {A : Set} {xs ys zs : List A} -> xs # ys -> zs ++ xs # zs ++ ys
#cong++r {zs = []} ps = ps
#cong++r {zs = x :: zs} ps = #cong (#cong++r ps)

#cong++l : {A : Set} {xs ys zs : List A} -> xs # ys -> xs ++ zs # ys ++ zs
#cong++l {_} {xs} {ys} {zs} π =
  #begin
    xs ++ zs #⟨ ++-permutation xs zs ⟩
    zs ++ xs #⟨ #cong++r π ⟩
    zs ++ ys #⟨ ++-permutation zs ys ⟩
    ys ++ zs
  #end

reverse-permutation : {A : Set} (xs : List A) -> reverse xs # xs
reverse-permutation [] = #refl
reverse-permutation (x :: xs) =
  #begin
    reverse (x :: xs)   #⟨⟩
    reverse xs ++ [ x ] #⟨ ++-permutation (reverse xs) [ x ] ⟩
    [ x ] ++ reverse xs #⟨⟩
    x :: reverse xs     #⟨ #cong (reverse-permutation xs) ⟩
    x :: xs
  #end
