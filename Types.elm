module Types exposing (..)

import Color exposing (Color)
import Navigation


type alias Model =
    { state : State
    }


type State
    = Start
    | Turn TurnData


type alias TurnData =
    { ore : Int
    , spice : Int
    , food : Int
    , fuel : Int
    , pop : Int
    , robot : Int
    , planets : List Planet
    }


type alias Planet =
    { color : Color
    , pos : Pos
    , rad : Int
    }


type alias Pos =
    { x : Int, y : Int }


type Msg
    = ClickStart
    | UrlChange Navigation.Location


initTurnData : TurnData
initTurnData =
    { ore = 420
    , spice = 69
    , food = 123
    , fuel = 999
    , pop = 27
    , robot = 101
    , planets =
        [ { color = Color.lightRed
          , pos = Pos 300 300
          , rad = 30
          }
        , { color = Color.green
          , pos = Pos 300 300
          , rad = 300
          }
        ]
    }
