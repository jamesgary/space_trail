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
    , mission : Maybe Mission
    , crisis : Maybe Crisis
    }


type alias Mission =
    { planet : Planet
    , map : Map
    }


type alias Map =
    { width : Int
    , height : Int
    , miner : Pos
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
    | ClickMap MousePos


type alias MousePos =
    ( Float, Float )


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


colorString : Color -> String
colorString color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color
    in
    "rgba("
        ++ toString red
        ++ ", "
        ++ toString green
        ++ ", "
        ++ toString blue
        ++ ", "
        ++ toString alpha
        ++ ")"
