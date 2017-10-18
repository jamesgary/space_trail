module Main exposing (main)

import Color
import Html
import Navigation
import Process
import Task
import Time exposing (Time)
import Types exposing (..)
import View exposing (view)


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


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
    , mission = Nothing
    , crisis = Nothing
    }


initTurnDataWithMission : TurnData
initTurnDataWithMission =
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
    , mission =
        Just
            { planet =
                { color = Color.brown
                , pos = Pos 500 300
                , rad = 200
                }
            , map = initMap
            }
    , crisis = Nothing
    }


initMap : Map
initMap =
    { width = 800
    , height = 450
    , miner = Pos 100 100
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


type alias Choice =
    { name : String
    , effects : List Effect
    }


type alias Effect =
    ( Operator, Int, Resource )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ state } as model) =
    case msg of
        ClickStart ->
            ( { state = Turn initTurnData, jumpState = Still }, Cmd.none )

        UrlChange url ->
            ( model, Cmd.none )

        ClickPlanet planet ->
            case state of
                Turn turnData ->
                    let
                        newState =
                            Turn { turnData | mission = Just { planet = planet, map = initMap } }
                    in
                    ( { model | state = newState }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        Dismiss ->
            case state of
                Turn turnData ->
                    let
                        newState =
                            Turn { turnData | mission = Nothing }
                    in
                    ( { model | state = newState }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        InitiateJump ->
            case state of
                Turn turnData ->
                    ( { model | jumpState = Jumping }
                    , delay (Time.second * 0.5) <| EndJump
                    )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        EndJump ->
            case state of
                Turn turnData ->
                    ( { model | jumpState = Still, state = Turn { turnData | crisis = Just initCrisis } }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        ResolveCrisis effects ->
            case state of
                Turn turnData ->
                    let
                        newTurnData =
                            applyEffects effects turnData

                        newerTurnData =
                            { newTurnData | crisis = Nothing }
                    in
                    ( { model | state = Turn newerTurnData }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )


applyEffects : List Effect -> TurnData -> TurnData
applyEffects effects turnData =
    List.foldr applyEffect turnData effects


applyEffect : Effect -> TurnData -> TurnData
applyEffect ( operator, amt, resource ) turnData =
    let
        delta =
            case operator of
                Gain ->
                    amt

                Lose ->
                    -1 * amt

        currentAmt =
            case resource of
                Ore ->
                    turnData.ore

                Spice ->
                    turnData.spice

                Food ->
                    turnData.food

                Fuel ->
                    turnData.fuel

                Pop ->
                    turnData.pop

                Robot ->
                    turnData.robot
    in
    case resource of
        Ore ->
            { turnData | ore = currentAmt + delta }

        Spice ->
            { turnData | spice = currentAmt + delta }

        Food ->
            { turnData | food = currentAmt + delta }

        Fuel ->
            { turnData | fuel = currentAmt + delta }

        Pop ->
            { turnData | pop = currentAmt + delta }

        Robot ->
            { turnData | robot = currentAmt + delta }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity



--Time.every (0.25 * Time.second) Tick
--AnimationFrame.times Tick
