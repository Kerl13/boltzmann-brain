-- | Author: Maciej Bendkowski <maciej.bendkowski@tcs.uj.edu.pl>
module Compiler.Text.Boltzmann
    ( Configuration(..)
    , compile 
    ) where

import System
import System.Boltzmann

import Compiler

import qualified Data.Map as M

writeType :: Show a => (String, [Cons a]) -> String
writeType (t,cons) = t ++ " = " ++ writeCons cons ++ "."

writeCons :: Show a => [Cons a] -> String
writeCons (con : con' : cs) = writeCon con ++ " | " ++ writeCons (con' : cs)
writeCons [con] = writeCon con 

parens :: Show a => a -> String
parens s = "(" ++ show s ++ ")"

writeCon :: Show a => Cons a -> String
writeCon con
  | null (args con) = func con ++ " " ++ parens (weight con)
  | otherwise = func con ++ " " ++ writeArgs (args con)
        ++ " " ++ parens (weight con)

writeArgs :: [Arg] -> String 
writeArgs [] = ""
writeArgs [Type t] = t
writeArgs (Type t : args) = t ++ " " ++ writeArgs args

writeSystem :: (Real a, Show a) => BoltzmannSystem b a -> IO ()
writeSystem sys = let sys' = system sys 
                      ts = M.toList (defs sys') in
                      mapM_ (putStrLn . writeType) ts

data Configuration b a = Configuration { paramSys :: BoltzmannSystem b a }

instance (Real a, Show a) => Compiler (Configuration b a) where
    compile = writeSystem . paramSys
