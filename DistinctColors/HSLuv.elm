module DistinctColors.HSLuv exposing (colors, nextColor, randomColor)

{-| Generator of distinct colors (using the **HSLuv** colorspace under the hood).

The ranges of saturation, lightness and alpha in the HSLuv colorspace are `0..1`.

    { saturation = 0.8
    , lightness = 0.7
    , alpha = 1.0
    }

Note that functions in this module work in the HSLuv colorspace. Its advantage
against HSL is that **changes in hue will result in colors of the same perceived
brightness.** And against HCL: **all argument combinations result in a color!**

For more information read [this comparison](http://www.hsluv.org/comparison/).
For perceptionally uniform colors switch to other modules in this package!

Algorithm behind moving the hues:
<https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/>

@docs nextColor, colors, randomColor

-}

import Color exposing (Color)
import HSLuv
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
    { saturation : Float
    , lightness : Float
    , alpha : Float
    }
    -> Generator Color
randomColor { saturation, lightness, alpha } =
    Internal.randomColor
        (\hue -> HSLuv.hsluva hue saturation lightness alpha)


{-| Generates a list of colors distinct from each other (consecutively).
Nice for programmatically assigning colors to elements in a list (users, ...).
-}
colors :
    { saturation : Float
    , lightness : Float
    , alpha : Float
    , numberOfColors : Int
    }
    -> Generator (List Color)
colors { saturation, lightness, alpha, numberOfColors } =
    Internal.colors
        (\hue -> HSLuv.hsluva hue saturation lightness alpha)
        nextColor
        numberOfColors


type alias Record =
    { hue : Float
    , saturation : Float
    , lightness : Float
    , alpha : Float
    }


colorToRecord : Color -> Record
colorToRecord color =
    HSLuv.toHsluv color


recordToColor : Record -> Color
recordToColor { hue, saturation, lightness, alpha } =
    HSLuv.hsluva hue saturation lightness alpha
