module DistinctColors.HCL exposing (colors, nextColor, randomColor)

{-| Generator of distinct colors (using the **HCL** - also known as CIELUV LCh -
colorspace under the hood).

The ranges of chroma, luminance and alpha in the HCL colorspace are `0..1`.

    { chroma = 0.8
    , luminance = 0.7
    , alpha = 1.0
    }

Note that functions in this module work in the HCL colorspace. Its advantage
against HSL is that **changes in hue will result in colors of the same perceived
brightness.** But it has a disadvantage against HSLuv: **not all argument
combinations result in a color!**

For more information read [this comparison](http://www.hsluv.org/comparison/).
For perceptionally uniform colors switch to other modules in this package!

Algorithm behind moving the hues:
<https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/>

@docs nextColor, colors, randomColor

-}

import Color exposing (Color)
import Color.HCL
import Internal
import Random.Pcg exposing (Generator)


{-| Moves the hue of the current color by 1/phi (0.618...) (assuming hue is 0..1).

This means that we have to move the hue 222.49224 degrees when hue is 0..360.

-}
nextColor : Color -> Color
nextColor color =
    Internal.nextColor
        colorToRecord
        (\record -> { record | hue = Internal.moveHue record.hue })
        recordToColor
        color


{-| Generate a color with given saturation, lightness, alpha and a random hue.
-}
randomColor :
    { chroma : Float
    , luminance : Float
    , alpha : Float
    }
    -> Generator Color
randomColor { chroma, luminance, alpha } =
    Internal.randomColor
        (\hue ->
            Color.HCL.toColor
                { hue = hue
                , chroma = chroma
                , luminance = luminance
                , alpha = alpha
                }
        )


{-| Generates a list of colors distinct from each other (consecutively).
Nice for programmatically assigning colors to elements in a list (users, ...).
-}
colors :
    { chroma : Float
    , luminance : Float
    , alpha : Float
    , numberOfColors : Int
    }
    -> Generator (List Color)
colors { chroma, luminance, alpha, numberOfColors } =
    Internal.colors
        (\hue ->
            Color.HCL.toColor
                { hue = hue
                , chroma = chroma
                , luminance = luminance
                , alpha = alpha
                }
        )
        nextColor
        numberOfColors


type alias Record =
    { hue : Float
    , luminance : Float
    , chroma : Float
    , alpha : Float
    }


colorToRecord : Color -> Record
colorToRecord color =
    Color.HCL.fromColor color


recordToColor : Record -> Color
recordToColor record =
    Color.HCL.toColor record
