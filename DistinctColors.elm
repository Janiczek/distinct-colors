module DistinctColors exposing (color, colors, nextColor)

{-| Generator of distinct colors.

@docs colors, color, nextColor

-}

import Color exposing (Color)
import Color.Hcl
import List.Extra
import Random.Pcg as Random exposing (Generator)


{-| Generates a list of colors distinct from each other (consecutively).
Nice for programmatically assigning colors to elements in a list (users, ...).

Algorithm: basically this:
<https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/>
But we're doing HCL instead of HSV.

-}
colors :
    { chroma : Float
    , luminance : Float
    , alpha : Float
    , numberOfColors : Int
    }
    -> Generator (List Color)
colors { chroma, luminance, alpha, numberOfColors } =
    if numberOfColors > 0 then
        firstColor chroma luminance alpha
            |> Random.map
                (\color ->
                    ( color, numberOfColors - 1 )
                        |> List.Extra.iterate
                            (\( color, numberOfColors ) ->
                                if numberOfColors > 0 then
                                    Just ( nextColor color, numberOfColors - 1 )
                                else
                                    Nothing
                            )
                        |> List.map Tuple.first
                )
    else
        Random.constant []


{-| Generate a color with given chroma, luminance, alpha and a random hue.
-}
color : { chroma : Float, luminance : Float, alpha : Float } -> Generator Color
color { chroma, luminance, alpha } =
    firstColor chroma luminance alpha



-- colors


firstColor : Float -> Float -> Float -> Generator Color
firstColor chroma luminance alpha =
    Random.map
        (hclColor chroma luminance alpha)
        firstHue


hclColor : Float -> Float -> Float -> Float -> Color
hclColor chroma luminance alpha hue =
    Color.Hcl.toColor
        { chroma = chroma
        , luminance = luminance
        , hue = hue
        , alpha = alpha
        }


{-| Moves the hue of the current color by 1/phi (0.618...) when hue is 0..1.

This means that we have to move the hue 222.49224 degrees when hue is 0..360.

-}
nextColor : Color -> Color
nextColor color =
    color
        |> Color.Hcl.fromColor
        |> (\color -> { color | hue = moveHue color.hue })
        |> Color.Hcl.toColor



-- hue


firstHue : Generator Float
firstHue =
    Random.float 0 360


{-| takes hue in degrees (0..360)
-}
moveHue : Float -> Float
moveHue hue =
    let
        added =
            hue + 222.492235949962
    in
    -- basically modulo 360 for floats...
    -- because the constant we're adding < 360, we know subtracting once will be enough
    if added > 360 then
        added - 360
    else
        added
