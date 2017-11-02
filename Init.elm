module Init exposing (init, initMap, initTurnData)

import Color
import Crises
import Navigation
import Random
import Types exposing (..)


init : Int -> Navigation.Location -> ( Model, Cmd Msg )
init timestamp location =
    let
        seed =
            Random.initialSeed timestamp
    in
    case location.hash of
        "#mission" ->
            ( { state = Turn initTurnDataWithMission
              , jumpState = Still
              , seed = seed
              }
            , Cmd.none
            )

        "#turn" ->
            ( { state = Turn initTurnData
              , jumpState = Still
              , seed = seed
              }
            , Cmd.none
            )

        "#crisis" ->
            let
                crisis =
                    List.head Crises.allCrises
                        |> Maybe.withDefault Crises.fallbackCrisis

                turnData =
                    { initTurnData | state = FacingCrisis crisis Nothing }
            in
            ( { state = Turn turnData
              , jumpState = Still
              , seed = seed
              }
            , Cmd.none
            )

        _ ->
            ( { state = Start
              , jumpState = Still
              , seed = seed
              }
            , Cmd.none
            )


initTurnData : TurnData
initTurnData =
    { ore = 420
    , spice = 69
    , food = 123
    , fuel = 999
    , pop = 27
    , robot = 101
    , affinities = initAffinities
    , planets =
        [ { color = Color.gray
          , pos = Pos 790 150
          , rad = 30
          }
        , { color = Color.brown
          , pos = Pos 500 300
          , rad = 200
          }
        , { color = Color.lightBlue
          , pos = Pos 1300 600
          , rad = 200
          }
        , { color = Color.yellow
          , pos = Pos 0 2700
          , rad = 2000
          }
        ]
    , state = Idle
    }


initTurnDataWithMission : TurnData
initTurnDataWithMission =
    { ore = 420
    , spice = 69
    , food = 123
    , fuel = 999
    , pop = 27
    , robot = 101
    , affinities = initAffinities
    , planets =
        [ { color = Color.gray
          , pos = Pos 790 150
          , rad = 30
          }
        , { color = Color.brown
          , pos = Pos 500 300
          , rad = 200
          }
        , { color = Color.lightBlue
          , pos = Pos 1300 600
          , rad = 200
          }
        , { color = Color.yellow
          , pos = Pos 0 2700
          , rad = 2000
          }
        ]
    , state =
        OnMission
            { planet =
                { color = Color.brown
                , pos = Pos 500 300
                , rad = 200
                }
            , map = initMap
            }
    }


initMap : Map
initMap =
    { width = 800
    , height = 450
    , miner =
        { pos = Pos 100 100
        , dest = Pos 100 100
        }
    }


initAffinities : Affinities
initAffinities =
    { theBelly = 0
    , theShield = 0
    , theWay = 0
    , theGarden = 0
    , thePick = 0
    , theMutex = 0
    , theBrains = 0
    , theForge = 0
    }
