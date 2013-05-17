{-# LANGUAGE NoMonomorphismRestriction #-}

import qualified Data.Set     as Set
import qualified Data.Text    as T
import qualified Data.Text.IO as IO

import System.Environment (getArgs, getProgName)
import System.Exit


getInput "-" = IO.getContents
getInput f   = IO.readFile f


union     = foldr Set.union Set.empty
diff      = foldl1 Set.difference
intersect = foldl1 Set.intersection


using f = mapM_ IO.putStrLn .
          Set.toList .
          f .
          map (Set.fromList . T.lines)


op "-u" = union
op "-d" = diff
op "-i" = intersect


main = do
  args <- getArgs
  case args of
    []     -> usage >> exitFailure
    (x:fs) -> using (op x) =<< mapM getInput fs


usage = do
  name <- getProgName
  putStrLn ("USAGE: " ++ name ++ " op [<fil>...] [-]\n" ++
            "  where op one of -u, -d, -i")
