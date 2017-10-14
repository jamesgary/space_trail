module Types exposing (..)

import Color exposing (Color)
import Navigation


type alias Model =
    { state : State
    , jumpState : JumpState
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
    , crisis : Maybe Crisis
    }


type alias Planet =
    { color : Color
    , pos : Pos
    , rad : Int
    }


type alias Pos =
    { x : Int, y : Int }


type alias Crisis =
    { title : String
    , description : String
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
    | InitiateJump
    | EndJump
    | ResolveCrisis (List Effect)


type JumpState
    = Still
    | Jumping


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
