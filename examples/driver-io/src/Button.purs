module Example.Driver.IO.Button where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = Boolean

data Query a
  = Toggle a
  | IsOn (Boolean -> a)

data Message = Toggled Boolean

myButton :: forall m. H.Component HH.HTML Query Unit Message m
myButton =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    , initializer: Nothing
    , finalizer: Nothing
    }
  where

  initialState :: State
  initialState = false

  render :: State -> H.ComponentHTML (Query Unit) () m
  render state =
    let
      label = if state then "On" else "Off"
    in
      HH.button
        [ HP.title label
        , HE.onClick (HE.input_ Toggle)
        ]
        [ HH.text label ]

  eval :: Query ~> H.HalogenM State (Query Unit) () Message m
  eval = case _ of
    Toggle next -> do
      state <- H.get
      let nextState = not state
      H.put nextState
      H.raise $ Toggled nextState
      pure next
    IsOn reply -> do
      state <- H.get
      pure (reply state)
