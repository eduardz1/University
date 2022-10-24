module Boolean where

data Bool . Set where
    true : Bool
    false : Bool

not : Bool -> Bool
not true = false
not false = true

and : Bool -> Bool -> Bool
and true true = true
and _ _ = false
