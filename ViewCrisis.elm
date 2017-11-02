module ViewCrisis exposing (viewCrisis)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onMouseOut, onMouseOver)
import Markdown
import Types exposing (..)


viewCrisis : Crisis -> Maybe CrisisAction -> Html Msg
viewCrisis { title, body } maybeAction =
    div [ class "crisis" ]
        [ h1 [ class "crisis-title" ] [ text title ]
        , Markdown.toHtml [ class "crisis-description" ] body.description
        , div [ class "crisis-consequence" ] (viewConsequence body.action maybeAction)
        , viewAction body.action
        ]


viewAction : CrisisAction -> Html Msg
viewAction action =
    div
        [ class "crisis-actions crisis-actions-ok"
        ]
        [ div [ class "btn-list" ]
            (case action of
                OK effects ->
                    [ div
                        [ class "btn"
                        , onMouseOver (HoveredActionBtn action)
                        , onMouseOut UnhoveredActionBtn
                        , onClick (ResolveCrisis effects)
                        ]
                        [ text "OK" ]
                    ]

                Choices choices ->
                    List.map viewChoice choices
            )
        ]


viewChoice : Choice -> Html Msg
viewChoice { name, consequence } =
    div
        [ class "btn"
        , onMouseOver (HoveredActionBtn consequence.action)
        , onMouseOut UnhoveredActionBtn
        , onClick (AdvanceCrisis consequence)
        ]
        [ text name ]


viewConsequence : CrisisAction -> Maybe CrisisAction -> List (Html Msg)
viewConsequence availableAction hoveredAction =
    case availableAction of
        -- always show consequences if the only action is "OK"
        OK effects ->
            List.map viewEffect effects

        _ ->
            case hoveredAction of
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
