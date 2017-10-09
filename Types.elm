module Types exposing (..)

import Time


type alias Model =
    { state : State
    }


type State
    = Start


type Msg
    = Noop
