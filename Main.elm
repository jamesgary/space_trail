module Main exposing (main)

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
        "#turn" ->
            ( { state = Turn initTurnData, jumpState = Still }, Cmd.none )

        _ ->
            ( { state = Start, jumpState = Still }, Cmd.none )


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
                            Turn { turnData | visitingPlanet = Just planet }
                    in
                    ( { model | state = newState }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )

        Dismiss ->
            case state of
                Turn turnData ->
                    let
                        newState =
                            Turn { turnData | visitingPlanet = Nothing }
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
                    ( { model | jumpState = Still }, Cmd.none )

                _ ->
                    Debug.log "Should never happen!" ( model, Cmd.none )


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
