module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import Types exposing (..)


view : Model -> Html Msg
view model =
    case model.state of
        Start ->
            viewStart


viewStart : Html Msg
viewStart =
    div [ class "start" ]
        [ h1 [] [ text "Space Trail" ]
        , div [ class "btn start-btn" ] [ text "Start" ]
        ]


px : number -> String
px num =
    toString num ++ "px"
