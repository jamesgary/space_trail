module Main exposing (main)

import Html
import Navigation
import Time
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
            ( { state = Turn initTurnData }, Cmd.none )

        _ ->
            ( { state = Start }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickStart ->
            ( { state = Turn initTurnData }, Cmd.none )

        UrlChange url ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--Time.every (0.25 * Time.second) Tick
--AnimationFrame.times Tick
