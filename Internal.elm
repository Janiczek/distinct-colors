module Internal exposing (colors, moveHue, nextColor, randomColor)

import Basics.Extra
import Color exposing (Color)
import List.Extra
import Random.Pcg as Random exposing (Generator)


firstHue : Generator Float
firstHue =
    Random.float 0 360


randomColor : (Float -> Color) -> Generator Color
randomColor makeColor =
    Random.map makeColor firstHue


nextColor : (Color -> a) -> (a -> a) -> (a -> Color) -> Color -> Color
nextColor colorToRecord changeRecord recordToColor color =
    color
        |> colorToRecord
        |> changeRecord
        |> recordToColor


moveHue : Float -> Float
moveHue hue =
    Basics.Extra.fmod (hue + 222.492235949962) 360


colors : (Float -> Color) -> (Color -> Color) -> Int -> Generator (List Color)
colors makeColor nextColor numberOfColors =
    let
        step : ( Color, Int ) -> Maybe ( Color, Int )
        step ( color, colorsLeft ) =
            if colorsLeft > 0 then
                Just ( nextColor color, colorsLeft - 1 )
            else
                Nothing
    in
    if numberOfColors > 0 then
        randomColor makeColor
            |> Random.map
                (\color ->
                    ( color, numberOfColors - 1 )
                        |> List.Extra.iterate step
                        |> List.map Tuple.first
                )
    else
        Random.constant []
