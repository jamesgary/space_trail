module ViewMap exposing (viewPlanets)

import Color exposing (Color)
import Html exposing (Html)
import Svg exposing (circle, rect, svg)
import Svg.Attributes exposing (..)
import Types exposing (..)


viewPlanets : List Planet -> Html Msg
viewPlanets planets =
    svg
        [ class "map", viewBox "0 0 1600 900" ]
        (List.map viewPlanet planets)


viewPlanet : Planet -> Html Msg
viewPlanet { color, pos, rad } =
    circle
        [ class "planet"
        , cx <| toString pos.x
        , cy <| toString pos.y
        , r <| toString rad
        , fill <| colorString color
        ]
        []


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
