module Main exposing (main)

import AnimationFrame
import Color
import Crises
import Html
import Init exposing (..)
import Navigation
import Process
import Random
import Task
import Time exposing (Time)
import Types exposing (..)
import View exposing (view)


main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ state, seed } as model) =
    case msg of
        ClickStart ->
            ( { model | state = Turn initTurnData, jumpState = Still }, Cmd.none )

        UrlChange url ->
            ( model, Cmd.none )

        ClickPlanet planet ->
            case state of
                Turn turnData ->
                    let
                        newState =
                            Turn { turnData | state = OnMission { planet = planet, map = initMap } }
                    in
                    ( { model | state = newState }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        Dismiss ->
            case state of
                Turn turnData ->
                    let
                        newState =
                            Turn { turnData | state = Idle }
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
                    let
                        ( crisisData, newSeed ) =
                            Random.step Crises.crisisGenerator seed

                        crisis =
                            case crisisData of
                                ( Just c, _ ) ->
                                    c

                                _ ->
                                    Crises.fallbackCrisis
                    in
                    --( { model | jumpState = Still, state = Turn { turnData | state = FacingCrisis Init.initCrisis } }, Cmd.none )
                    ( { model | seed = newSeed, jumpState = Still, state = Turn { turnData | state = FacingCrisis crisis } }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        ResolveCrisis effects ->
            case state of
                Turn turnData ->
                    let
                        newTurnData =
                            applyEffects effects turnData

                        newerTurnData =
                            { newTurnData | state = Idle }
                    in
                    ( { model | state = Turn newerTurnData }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        AdvanceCrisis crisis ->
            case state of
                Turn turnData ->
                    ( { model | state = Turn { turnData | state = FacingCrisis crisis } }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        ClickMap ( x, y ) ->
            case state of
                Turn turnData ->
                    case turnData.state of
                        OnMission mission ->
                            let
                                map =
                                    mission.map

                                miner =
                                    mission.map.miner

                                newMiner =
                                    { miner | dest = Pos (round x) (round y) }

                                newMap =
                                    { map | miner = newMiner }

                                newMission =
                                    { mission | map = newMap }

                                newTurnData =
                                    { turnData | state = OnMission newMission }
                            in
                            ( { model | state = Turn newTurnData }, Cmd.none )

                        _ ->
                            Debug.log "Should never happen!" ( model, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        EndMission ->
            case state of
                Turn turnData ->
                    let
                        newTurnData =
                            { turnData | state = Idle }
                    in
                    ( { model | state = Turn newTurnData }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        VisitCouncil ->
            ( model, Cmd.none )

        Tick time ->
            case state of
                Turn turnData ->
                    case turnData.state of
                        OnMission mission ->
                            let
                                map =
                                    mission.map

                                miner =
                                    mission.map.miner

                                newPos =
                                    calculatePosition miner.pos miner.dest time

                                newMiner =
                                    { miner | pos = newPos }

                                newMap =
                                    { map | miner = newMiner }

                                newMission =
                                    { mission | map = newMap }

                                newTurnData =
                                    { turnData | state = OnMission newMission }
                            in
                            ( { model | state = Turn newTurnData }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )


calculatePosition : Pos -> Pos -> Time.Time -> Pos
calculatePosition pos dest timeElapsed =
    let
        dragSpeed =
            0.09

        --1 - (baseWeight / (baseWeight + timeElapsed))
        distX =
            dest.x - pos.x

        distY =
            dest.y - pos.y

        newX =
            pos.x + round (dragSpeed * toFloat distX)

        newY =
            pos.y + round (dragSpeed * toFloat distY)
    in
    Pos newX newY


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

                BellyAff ->
                    turnData.affinities.theBelly

                ShieldAff ->
                    turnData.affinities.theShield

                WayAff ->
                    turnData.affinities.theWay

                GardenAff ->
                    turnData.affinities.theGarden

                PickAff ->
                    turnData.affinities.thePick

                MutexAff ->
                    turnData.affinities.theMutex

                BrainsAff ->
                    turnData.affinities.theBrains

                ForgeAff ->
                    turnData.affinities.theForge

        affinities =
            turnData.affinities
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

        BellyAff ->
            let
                newAffinities =
                    { affinities | theBelly = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }

        ShieldAff ->
            let
                newAffinities =
                    { affinities | theShield = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }

        WayAff ->
            let
                newAffinities =
                    { affinities | theWay = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }

        GardenAff ->
            let
                newAffinities =
                    { affinities | theGarden = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }

        PickAff ->
            let
                newAffinities =
                    { affinities | thePick = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }

        MutexAff ->
            let
                newAffinities =
                    { affinities | theMutex = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }

        BrainsAff ->
            let
                newAffinities =
                    { affinities | theBrains = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }

        ForgeAff ->
            let
                newAffinities =
                    { affinities | theForge = currentAmt + delta }
            in
            { turnData | affinities = newAffinities }


subscriptions : Model -> Sub Msg
subscriptions model =
    --Sub.none
    AnimationFrame.times Tick



--Time.every 100 Tick


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity



--Time.every (0.25 * Time.second) Tick
--AnimationFrame.times Tick
