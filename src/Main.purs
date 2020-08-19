module Main where

import Prelude
import Control.Monad.Rec.Loops (whileM_)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Ref as Ref
import Performance.Minibench (benchAffWith)

hundredMsOp ∷ Aff Unit
hundredMsOp =
  liftEffect do
    i <- Ref.new 0
    void
      $ whileM_ ((_ < 15000) <$> Ref.read i) do
          n <- Ref.read i
          liftEffect $ log ("hey: " <> show n)
          Ref.modify_ (_ + 1) i

benchmarkedAff ∷ Aff Unit
benchmarkedAff = do
  -- x <- pure unit -- uncommenting this line adds an additional 100ms to results in our application
  hundredMsOp

main ∷ Effect Unit
main =
  launchAff_ do
    benchAffWith 20 benchmarkedAff
