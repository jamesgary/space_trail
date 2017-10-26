module Init exposing (init, initCrisis, initMap, initTurnData)

import Color
import Navigation
import Types exposing (..)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    case location.hash of
        "#mission" ->
            ( { state = Turn initTurnDataWithMission, jumpState = Still }, Cmd.none )

        "#turn" ->
            ( { state = Turn initTurnData, jumpState = Still }, Cmd.none )

        _ ->
            ( { state = Start, jumpState = Still }, Cmd.none )


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


initCrisis : Crisis
initCrisis =
    { title = "Heat Death"
    , description =
        """
        You awake one morning-cycle and find you can see your own breath. "We have a problem," your assistant informs you before you can even finish inserting your caffeine suppository. It seems the ship's temperature regulation systems are failing. The entire ship is losing heat and several populated sections of the ship are already freezing cold and getting colder. The Skillicus Machinicus assures you that the systems can be fixed - but not before people have died. Your navigator suggests that they move off-course and closer to the nearest star in order to warm the ship up while the engineers fix the systems – it will cost precious fuel but save lives. The Pickax proxy suggests disassembling some of your robots and using their batteries to power heating devices. What should we do?
        """
    , choices =
        [ { name = "Repair System"
          , effects =
                [ ( Lose, 10, Pop )
                ]
          }
        , { name = "Approach Star"
          , effects =
                [ ( Lose, 20, Fuel )
                ]
          }
        , { name = "Harvest batteries"
          , effects =
                [ ( Lose, 30, Robot )
                ]
          }
        ]
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
