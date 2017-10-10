module View exposing (view)

import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)


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
        [ viewMap turnData.planets
        , viewStats turnData
        ]


viewMap : List Planet -> Html Msg
viewMap planets =
    div [ class "map" ] (List.map viewPlanet planets)


viewPlanet : Planet -> Html Msg
viewPlanet { color, pos, rad } =
    div
        [ class "planet"
        , style
            (Debug.log "DAFAUQ"
                [ ( "top", px pos.y )
                , ( "left", px pos.x )
                , ( "width", px rad )
                , ( "height", px rad )
                , ( "background", colorString color )
                ]
            )
        ]
        []


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
