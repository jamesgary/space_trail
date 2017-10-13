module View exposing (view)

import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)
import ViewMap


view : Model -> Html Msg
view model =
    case model.state of
        Start ->
            viewStart

        Turn turnData ->
            viewTurn turnData


viewStart : Html Msg
viewStart =
    div [ class "screen screen-start" ]
        [ h1 [] [ text "Space Trail" ]
        , div [ class "btn start-btn", onClick ClickStart ] [ text "Start" ]
        ]


viewTurn : TurnData -> Html Msg
viewTurn turnData =
    div [ class "screen screen-turn" ]
        [ div [ class "map-container" ]
            [ div [ class "bg" ]
                [ div [ class "stars" ] []
                , div [ class "twinkling" ] []
                ]
            , div [ class "planets-container" ]
                [ ViewMap.viewPlanets turnData.planets ]
            ]
        , viewStats turnData
        , viewVisitingPlanet turnData.visitingPlanet
        ]


viewVisitingPlanet : Maybe Planet -> Html Msg
viewVisitingPlanet maybePlanet =
    case maybePlanet of
        Just planet ->
            div [ class "modal" ]
                [ p [] [ text planet.mission ]
                , div [ class "btn" ] [ text "OK" ]
                , div [ class "btn", onClick Dismiss ] [ text "Cancel" ]
                ]

        Nothing ->
            div [ class "modal modal-hidden" ] []


viewStats : TurnData -> Html Msg
viewStats { ore, spice, food, fuel, pop, robot } =
    table [ class "stats" ]
        (List.concat
            [ viewStat "ore" ore
            , viewStat "spice" spice
            , viewStat "food" food
            , viewStat "fuel" fuel
            , viewStat "pop" pop
            , viewStat "robot" robot
            ]
        )


viewStat : String -> Int -> List (Html Msg)
viewStat name val =
    [ tr []
        [ td [ class <| "stat stat-title stat-" ++ name ] [ text <| name ++ ":" ]
        , td [ class <| "stat stat-val stat-" ++ name ] [ text <| toString val ]
        ]
    ]


px : number -> String
px num =
    toString num ++ "px"
