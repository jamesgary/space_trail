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
    , visitingPlanet : Maybe Planet
    }


type alias Planet =
    { color : Color
    , pos : Pos
    , rad : Int
    , mission : Mission
    }


type alias Pos =
    { x : Int, y : Int }


type alias Mission =
    { description : String
    , choices : List Choice
    }


type alias Choice =
    { name : String
    , effects : List Effect
    }


type alias Effect =
    ( Operator, Int, Resource )


type Operator
    = Gain
    | Lose


type Resource
    = Ore
    | Spice
    | Food
    | Fuel
    | Pop
    | Robot


type Msg
    = ClickStart
    | UrlChange Navigation.Location
    | ClickPlanet Planet
    | Dismiss


initTurnData : TurnData
initTurnData =
    { ore = 420
    , spice = 69
    , food = 123
    , fuel = 999
    , pop = 27
    , robot = 101
    , planets =
        [ { color = Color.gray
          , pos = Pos 790 150
          , rad = 30
          , mission =
                { description = "This moon is rich in CALCIUM. Do you wish to mine?"
                , choices =
                    [ { name = "Mine away!"
                      , effects = [ ( Gain, 100, Ore ) ]
                      }
                    ]
                }
          }

        --, { color = Color.brown
        --  , pos = Pos 500 300
        --  , rad = 200
        --  , mission = "The spice flows deep in this planet. Do you wish to harvest?"
        --  }
        --, { color = Color.lightBlue
        --  , pos = Pos 1300 600
        --  , rad = 200
        --  , mission = "POOL PARTY!"
        --  }
        --, { color = Color.yellow
        --  , pos = Pos 0 2700
        --  , rad = 2000
        --  , mission = "The sun is too hot to travel to. You need LEVEL 4 SPACESUITS."
        --  }
        ]
    , visitingPlanet = Nothing
    }


px : number -> String
px num =
    toString num ++ "px"


strFromResource : Resource -> String
strFromResource resource =
    case resource of
        Ore ->
            "Ore"

        Spice ->
            "Spice"

        Food ->
            "Food"

        Fuel ->
            "Fuel"

        Pop ->
            "Pop"

        Robot ->
            "Robot"
