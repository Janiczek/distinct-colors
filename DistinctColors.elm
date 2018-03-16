module DistinctColors exposing (colors, nextColor)

{-| Generator of distinct colors.

@docs colors, nextColor

-}

import Color exposing (Color)
import List.Extra
import Random.Pcg as Random exposing (Generator)


{-| Generates a list of colors distinct from each other (consecutively).
Nice for programmatically assigning colors to elements in a list (users, ...).

Algorithm: basically this:
<https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/>
But we're doing HSL instead of HSV (because HSL was more readily available than HSV).
I don't know what effect does that have.

-}
colors :
    { saturation : Float
    , lightness : Float
    , numberOfColors : Int
    }
    -> Generator (List Color)
colors { saturation, lightness, numberOfColors } =
    if numberOfColors > 0 then
        firstColor saturation lightness
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



-- colors


firstColor : Float -> Float -> Generator Color
firstColor saturation lightness =
    Random.map
        (hslColor saturation lightness)
        firstHue


{-| takes hue as a number 0..1
-}
hslColor : Float -> Float -> Float -> Color
hslColor saturation lightness hue01 =
    Color.hsl (hue01 * 2 * pi) saturation lightness


{-| Moves the hue of the current color by 1/phi (0.618...)
-}
nextColor : Color -> Color
nextColor color =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        hue01 =
            hue / 2 / pi
    in
    hslColor saturation lightness (moveHue hue01)



-- hue


firstHue : Generator Float
firstHue =
    Random.float 0 1


moveHue : Float -> Float
moveHue hue01 =
    let
        added =
            hue01 + goldenRatioConjugate
    in
    -- basically modulo 1 for floats...
    -- because goldenRatioConjugate < 1, we know subtracting once will be enough
    if added > 1 then
        added - 1
    else
        added


{-| 1/phi or phi-1, pick your poison
-}
goldenRatioConjugate : Float
goldenRatioConjugate =
    0.618033988749895
