module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick)
import Json.Decode as Decode
import Types exposing (..)
import ViewCrisis
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
viewTurn ({ planets, state } as turnData) =
    let
        ( monitorClass, missionClass ) =
            --case turnData.mission of
            --    Just mission ->
            --        ( "map-container hidden", "mission-container" )
            --    Nothing ->
            ( "monitor-container", "mission-container hidden" )
    in
    div [ class "screen screen-turn" ]
        [ div [ class "affinities-container" ]
            [ viewAffinities turnData.affinities
            , viewCouncilButton
            ]
        , div [ class monitorClass ]
            (case state of
                Idle ->
                    [ div [ class "bg" ]
                        [ div [ class "stars" ] []
                        , div [ class "twinkling" ] []
                        ]
                    , div [ class "planets-container" ]
                        [ ViewMap.viewPlanets turnData.planets ]
                    ]

                OnMission mission ->
                    [ viewMission mission ]

                FacingCrisis crisis hoveredAction ->
                    [ ViewCrisis.viewCrisis crisis hoveredAction ]

                _ ->
                    []
            )
        , div [ class "controls-container" ]
            [ viewStats turnData
            , viewJumpButton
            ]

        --, div [ class missionClass ]
        --    [ viewMission turnData.mission
        --    , viewCrisis turnData.crisis
        --    ]
        ]


viewCouncilButton : Html Msg
viewCouncilButton =
    div [ class "btn btn-fancy btn-view-council", onClick VisitCouncil ] [ text "Council" ]


viewJumpButton : Html Msg
viewJumpButton =
    div [ class "btn btn-fancy btn-jump", onClick InitiateJump ] [ text "JUMP" ]


viewMission : Mission -> Html Msg
viewMission mission =
    div [ onMouseDown, class "mission", style [ ( "background-color", colorString mission.planet.color ) ] ]
        [ div
            [ class "miner"
            , style
                [ ( "top", px mission.map.miner.pos.y )
                , ( "left", px mission.map.miner.pos.x )
                ]
            ]
            []
        , div
            [ class "btn btn-end-mission", onClick EndMission ]
            [ text "End Mission" ]
        ]


viewStats : TurnData -> Html Msg
viewStats { ore, spice, food, fuel, pop, robot } =
    table [ class "stats" ]
        (List.concat
            [ viewStat "pop" pop
            , viewStat "food" food
            , viewStat "fuel" fuel
            , viewStat "ore" ore
            , viewStat "spice" spice
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


viewAffinities : Affinities -> Html Msg
viewAffinities { theBelly, theShield, theWay, theGarden, thePick, theMutex, theBrains, theForge } =
    table [ class "stats stats-affinities" ]
        (List.concat
            [ viewAffinity "The Pick" "the-pick" thePick
            , viewAffinity "The Forge" "the-forge" theForge
            , viewAffinity "The Shield" "the-shield" theShield
            , viewAffinity "The Garden" "the-garden" theGarden
            , viewAffinity "The Mutex" "the-mutex" theMutex
            , viewAffinity "The Brains" "the-brains" theBrains
            , viewAffinity "The Way" "the-way" theWay
            , viewAffinity "The Belly" "the-belly" theBelly
            ]
        )


viewAffinity : String -> String -> Int -> List (Html Msg)
viewAffinity title className val =
    [ tr []
        [ td [ class <| "stat stat-title stat-" ++ className ] [ text <| title ++ ":" ]
        , td [ class <| "stat stat-val stat-" ++ className ] [ text <| toString val ]
        ]
    ]


px : number -> String
px num =
    toString num ++ "px"


onMouseDown : Attribute Msg
onMouseDown =
    on "mousedown" (Decode.map ClickMap decodeClickLocation)



--onMouseUp : Attribute Msg
--onMouseUp =
--    on "mouseup" (Decode.map MouseUp decodeClickLocation)


decodeClickLocation : Decode.Decoder ( Float, Float )
decodeClickLocation =
    Decode.map2 (,)
        (Decode.at [ "offsetX" ] Decode.float)
        (Decode.at [ "offsetY" ] Decode.float)



--Decode.map2 (,)
--    (Decode.map2 (/)
--        (Decode.at [ "offsetX" ] Decode.float)
--        (Decode.at [ "target", "clientWidth" ] Decode.float)
--    )
--    (Decode.map2 (/)
--        (Decode.at [ "offsetY" ] Decode.float)
--        (Decode.at [ "target", "clientHeight" ] Decode.float)
--    )
