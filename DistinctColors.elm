module DistinctColors exposing (colors)

{-| Generator of distinct colors.

@docs colors

-}

import Color exposing (Color)
import Random.Pcg as Random exposing (Generator)


{-| Generates a list of colors distinct from each other (consecutively).
Nice for programmatically assigning colors to elements in a list (users, ...).

Algorithm: basically this:
<https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/>
But we're doing HSL instead of HSV (because HSL was more readily available than HSV).
I don't know what effect does that have.

-}
colors : Float -> Float -> Int -> Generator (List Color)
colors saturation lightness amount =
    if amount > 0 then
        firstColor saturation lightness
            |> Random.andThen
                (\( color, hue ) ->
                    threadColors
                        saturation
                        lightness
                        [ color ]
                        (amount - 1)
                        hue
                )
    else
        Random.constant []


threadColors : Float -> Float -> List Color -> Int -> Float -> Generator (List Color)
threadColors saturation lightness colorsSoFar amount previousHue =
    if amount > 0 then
        dependentColor saturation lightness previousHue
            |> Random.andThen
                (\( color, hue ) ->
                    threadColors
                        saturation
                        lightness
                        (color :: colorsSoFar)
                        (amount - 1)
                        hue
                )
    else
        Random.constant colorsSoFar



-- colors


firstColor : Float -> Float -> Generator ( Color, Float )
firstColor saturation lightness =
    Random.map
        (colorAndHue saturation lightness)
        firstHue


dependentColor : Float -> Float -> Float -> Generator ( Color, Float )
dependentColor saturation lightness previousHue =
    Random.map
        (colorAndHue saturation lightness)
        (nextHue previousHue)


colorAndHue : Float -> Float -> Float -> ( Color, Float )
colorAndHue saturation lightness hue =
    ( hslColor saturation lightness hue, hue )


{-| takes hue as a number 0..1
-}
hslColor : Float -> Float -> Float -> Color
hslColor saturation lightness hue01 =
    Color.hsl (hue01 * 2 * pi) saturation lightness



-- hue


firstHue : Generator Float
firstHue =
    Random.float 0 1


nextHue : Float -> Generator Float
nextHue previousHue =
    Random.constant (moveHue previousHue)


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
