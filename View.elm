module View exposing (view)

import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)
import ViewMap


view : Model -> Html Msg
view { state, jumpState } =
    let
        classname =
            case jumpState of
                Still ->
                    "elm"

                Jumping ->
                    "elm elm-jumping"
    in
    div [ class classname ]
        [ case state of
            Start ->
                viewStart

            Turn turnData ->
                viewTurn turnData
        ]


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
        , div [ class "controls-container" ]
            [ viewStats turnData
            , viewJumpButton
            ]
        , viewVisitingPlanet turnData.visitingPlanet
        , viewCrisis turnData.crisis
        ]


viewJumpButton : Html Msg
viewJumpButton =
    div [ class "btn btn-jump", onClick InitiateJump ] [ text "JUMP" ]


viewVisitingPlanet : Maybe Planet -> Html Msg
viewVisitingPlanet maybePlanet =
    case maybePlanet of
        Just planet ->
            div [ class "modal" ]
                [ p [] [ text "MINIGAME STUFF GO HERE" ]
                , div [ class "btn", onClick Dismiss ] [ text "hell yeah" ]
                , div [ class "btn", onClick Dismiss ] [ text "hell no" ]
                ]

        Nothing ->
            div [ class "modal modal-hidden" ] []


viewCrisis : Maybe Crisis -> Html Msg
viewCrisis crisis =
    case crisis of
        Just { title, description, choices } ->
            div [ class "modal" ]
                (List.concat
                    [ [ h1 [] [ text title ] ]
                    , [ p [] [ text description ] ]
                    , List.map viewChoice choices

                    --, [ div [ class "btn", onClick Dismiss ] [ text "Cancel" ] ]
                    ]
                )

        Nothing ->
            div [] []


viewChoice : Choice -> Html Msg
viewChoice { name, effects } =
    div [ class "btn", onClick (ResolveCrisis effects) ]
        [ text name
        , div [ class "hint" ] (List.map viewEffect effects)
        ]


viewEffect : Effect -> Html Msg
viewEffect ( op, amt, resource ) =
    let
        ( opText, opClass ) =
            case op of
                Gain ->
                    ( "Gain", "gain" )

                Lose ->
                    ( "Lose", "lose" )

        effectText =
            opText ++ " " ++ toString amt ++ " " ++ strFromResource resource
    in
    span []
        [ span [] [ text effectText ]
        ]



--<span class="gain">Gain <span="class"="ore">100 Ore</span></span>


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
