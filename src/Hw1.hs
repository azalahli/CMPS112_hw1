{- | CSE 130: Intro to Haskell Assignment.
     Do not change the skeleton code!

     You may only replace the `error "TBD:..."` parts.

     For this assignment, you may use any library function on integers
     but only the following library functions on lists:

     length
     (++)
     (==)

 -}

module Hw1 where

import Prelude  hiding (replicate, sum, reverse)

-- | Sum the elements of a list
--
-- >>> sumList [1, 2, 3, 4]
-- 10
--
-- >>> sumList [1, -2, 3, 5]
-- 7
--
-- >>> sumList [1, 3, 5, 7, 9, 11]
-- 36

sumList :: [Int] -> Int
sumList [] = 0
sumList (x:xs) = x + sumList xs
--anyways, readme helps (sumlist post setup commit)

-- | `digitsOfInt n` should return `[]` if `n` is not positive,
--    and otherwise returns the list of digits of `n` in the
--    order in which they appear in `n`.
--
-- >>> digitsOfInt 3124
-- [3, 1, 2, 4]
--
-- >>> digitsOfInt 352663
-- [3, 5, 2, 6, 6, 3]

digitsOfInt :: Int -> [Int]
digitsOfInt n = if n <= 0
    then []
    else digitsOfInt(div n 10) ++ (mod n 10):[]
{-
digitsOfInt 0 = [0]
digitsOfInt n = digitsOfInt(div n 10) ++ (mod n 10):[]
-}
    {-|
digitsOfInt n = if n < 0
    then []
    else map digitToInt (show n)
-}
-- show n = [char]
-- need to apply digitToInt w/o map
-- if we can't operate on lists with anything but == ++ and length, this method is probably not viable
    -- also questionable legality on char -> int library function
    -- recursion somehow
        -- easy to get one digit via % 10
            -- div instead of / because ghci is asking me for a Fractional Int?

            --last note, the policy for any function on ints seems odd if we can import anything
                --under that policy, we could import someone elses function that uses said list operators,
                --so long as we did not use those operators.

-- | `digits n` retruns the list of digits of `n`
--
-- >>> digits 31243
-- [3,1,2,4,3]
--
-- digits (-23422)
-- [2, 3, 4, 2, 2]

digits :: Int -> [Int]
digits n = digitsOfInt (abs n)


-- | From http://mathworld.wolfram.com/AdditivePersistence.html
--   Consider the process of taking a number, adding its digits,
--   then adding the digits of the number derived from it, etc.,
--   until the remaining number has only one digit.
--   The number of additions required to obtain a single digit
--   from a number n is called the additive persistence of n,
--   and the digit obtained is called the digital root of n.
--   For example, the sequence obtained from the starting number
--   9876 is (9876, 30, 3), so 9876 has
--   an additive persistence of 2 and
--   a digital root of 3.
--
-- NOTE: assume additivePersistence & digitalRoot are only called with positive numbers

-- >>> additivePersistence 9876
-- 2

additivePersistence :: Int -> Int
additivePersistence n = if (length (digitsOfInt (sumList(digitsOfInt n)))) <= 1
    then if (length (digitsOfInt (sumList(digitsOfInt n)))) == 1
        then 1
            else 0
    else 1 + (additivePersistence(sumList(digitsOfInt n)))
--additivePersistence n = 2
--why is it so hard to count the number of recursions
-- i suspect returning 2 is enough for this
-- it is.
-- using the wolfram test cases of 0, 1, 19, 199, <untestable number>
-- pretty sure this is it but offset by one
--oh fuck me, its <= 1 because zero returns an empty list
{-
Ok, modules loaded: Hw1.
*Hw1 Hw1> additivePersistence 0
0
*Hw1 Hw1> additivePersistence 1
1
*Hw1 Hw1> additivePersistence 19
2
*Hw1 Hw1> additivePersistence 199
3
*Hw1 Hw1> additivePersistence 9876
2
*Hw1 Hw1>
-}

-- | digitalRoot n is the digit obtained at the end of the sequence
--   computing the additivePersistence
--
-- >>> digitalRoot 9876
-- 3
digitalRoot :: Int -> Int
digitalRoot n = if (length (digitsOfInt (sumList(digitsOfInt n)))) <= 1
    then (sumList(digitsOfInt n))
    else digitalRoot (sumList(digitsOfInt n))
-- interesting to note that the then statement can be replaced with a zero
-- even more interesting to note that this can be only the else statement.
-- additivePersistence n = sumList(digitsOfInt (sumList(digitsOfInt n))) is a valid digital root function
-- it is not valid, needed larger numbers
-- i am more convinved this is correct

-- | listReverse [x1,x2,...,xn] returns [xn,...,x2,x1]
--
-- >>> listReverse []
-- []
--
-- >>> listReverse [1,2,3,4]
-- [4,3,2,1]
--
-- >>> listReverse ["i", "want", "to", "ride", "my", "bicycle"]
-- ["bicycle", "my", "ride", "to", "want", "i"]

listReverse :: [a] -> [a]
listReverse[] = []
listReverse (x:xs) = (listReverse xs) ++ x:[]

-- | In Haskell, a `String` is a simply a list of `Char`, that is:
--
-- >>> ['h', 'a', 's', 'k', 'e', 'l', 'l']
-- "haskell"
--
-- >>> palindrome "malayalam"
-- True
--
-- >>> palindrome "myxomatosis"
-- False

palindrome :: String -> Bool
palindrome w = w == listReverse w
