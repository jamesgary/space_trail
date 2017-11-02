module ViewCrisis exposing (viewCrisis)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onMouseOut, onMouseOver)
import Markdown
import Types exposing (..)


viewCrisis : Crisis -> Maybe CrisisAction -> Html Msg
viewCrisis { title, body } maybeAction =
    div [ class "crisis" ]
        [ h1 [ class "crisis-title" ] [ text title ]
        , Markdown.toHtml [ class "crisis-description" ] body.description
        , div [ class "crisis-consequence" ] (viewConsequence maybeAction)
        , viewAction body.action
        ]


viewAction : CrisisAction -> Html Msg
viewAction action =
    div
        [ class "crisis-actions crisis-actions-ok btn-list"
        ]
        (case action of
            OK effects ->
                [ div
                    [ class "btn"
                    , onMouseOver (HoveredActionBtn action)
                    , onMouseOut UnhoveredActionBtn
                    ]
                    [ text "OK" ]
                ]

            Choices choices ->
                List.map viewChoice choices
        )


viewChoice : Choice -> Html Msg
viewChoice { name, consequence } =
    div
        [ class "btn"
        , onMouseOver (HoveredActionBtn consequence.action)
        , onMouseOut UnhoveredActionBtn
        ]
        [ text name ]


viewConsequence : Maybe CrisisAction -> List (Html Msg)
viewConsequence maybeAction =
    case maybeAction of
        Just action ->
            case action of
                OK effects ->
                    List.map viewEffect effects

                Choices choices ->
                    List.map viewChoiceEffects choices
                        |> List.intersperse (p [] [ text "- or -" ])

        Nothing ->
            [ p [] [ text "..." ]
            ]


viewChoiceEffects : Choice -> Html Msg
viewChoiceEffects { consequence } =
    div [ class "choice-effect" ]
        (case consequence.action of
            OK effects ->
                List.map viewEffect effects

            Choices choices ->
                List.map viewChoiceEffects choices
        )


viewEffect : Effect -> Html Msg
viewEffect ( op, amt, resource ) =
    let
        ( opText, opClass ) =
            case op of
                Gain ->
                    ( "+", "gain" )

                Lose ->
                    ( "-", "lose" )

        effectText =
            opText ++ " " ++ toString amt ++ " " ++ strFromResource resource
    in
    li [ class "effect" ]
        [ span [ class opClass ] [ text (opText ++ toString amt) ]
        , span [] [ text " " ]
        , span [ class (strFromResource resource) ] [ text (strFromResource resource) ]
        ]
