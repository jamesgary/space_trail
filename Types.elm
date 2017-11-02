module Types exposing (..)

import Color exposing (Color)
import Navigation
import Random
import Time


type alias Model =
    { state : State
    , jumpState : JumpState

    --, crisisGenerator : Random.Generator ( Maybe Crisis, List Crisis )
    , seed : Random.Seed
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
    , affinities : Affinities
    , planets : List Planet
    , state : TurnState

    --, mission : Maybe Mission
    --, crisis : Maybe Crisis
    }


type alias Affinities =
    { theBelly : Int
    , theShield : Int
    , theWay : Int
    , theGarden : Int
    , thePick : Int
    , theMutex : Int
    , theBrains : Int
    , theForge : Int
    }


type TurnState
    = Idle
    | OnMission Mission
    | FacingCrisis Crisis (Maybe CrisisAction)
    | VisitingCouncil


type alias Mission =
    { planet : Planet
    , map : Map
    }


type alias Map =
    { width : Int
    , height : Int
    , miner : Miner
    }


type alias Miner =
    { pos : Pos
    , dest : Pos
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
    , body : CrisisBody
    }


type alias CrisisBody =
    { description : String
    , action : CrisisAction
    }


type CrisisAction
    = OK (List Effect)
    | Choices (List Choice)


type alias Choice =
    { name : String
    , consequence : CrisisBody
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
      -- affinities
    | BellyAff
    | ShieldAff
    | WayAff
    | GardenAff
    | PickAff
    | MutexAff
    | BrainsAff
    | ForgeAff



--type Faction
--    = TheBelly
--    | TheShield
--    | TheWay
--    | TheGarden
--    | ThePick
--    | TheMutex
--    | TheBrains
--    | TheForge


type Msg
    = ClickStart
    | UrlChange Navigation.Location
    | ClickPlanet Planet
    | Dismiss
    | InitiateJump
    | EndJump
    | ResolveCrisis (List Effect)
    | AdvanceCrisis CrisisBody
    | ClickMap MousePos
    | Tick Time.Time
    | EndMission
    | VisitCouncil
    | HoveredActionBtn CrisisAction
    | UnhoveredActionBtn


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

        BellyAff ->
            "Belly Affinity"

        ShieldAff ->
            "Shield Affinity"

        WayAff ->
            "Way Affinity"

        GardenAff ->
            "Garden Affinity"

        PickAff ->
            "Pick Affinity"

        MutexAff ->
            "Mutex Affinity"

        BrainsAff ->
            "Brains Affinity"

        ForgeAff ->
            "Forge Affinity"


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
