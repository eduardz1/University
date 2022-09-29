module Library.Bool where

data Bool : Set where
  true false : Bool

if_then_else_ : ∀{A : Set} -> Bool -> A -> A -> A
if true  then x else y = x
if false then x else y = y

not : Bool -> Bool
not x = if x then false else true

_&&_ : Bool -> Bool -> Bool
x && y = if x then y else false

_||_ : Bool -> Bool -> Bool
x || y = if x then true else y

_?=_ : Bool -> Bool -> Bool
true ?= true = true
true ?= false = false
false ?= true = false
false ?= false = true
