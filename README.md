# DistinctColors

Generates a list of colors distinct from each other (consecutively).
Nice for programmatically assigning colors to elements in a list (users, ...).

## Example

![Distinct colors for saturation 0.7 and lightness 0.8](https://github.com/Janiczek/distinct-colors/raw/master/doc/colors.png)

These colors have been generated for chroma `70` and luminance `80`.

## Algorithm

Basically [this](https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/), but we're doing HCL instead of HSV.
