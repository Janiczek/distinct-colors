# DistinctColors

Generates a list of colors distinct from each other (consecutively).
Nice for programmatically assigning colors to elements in a list (users, ...).

## Example

![Distinct colors for saturation 0.7 and lightness 0.8](https://github.com/Janiczek/distinct-colors/raw/master/doc/colors.png)

These colors have been generated for saturation `0.7` and lightness `0.8`.

## Algorithm

Basically [this](https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/), but we're doing HSL instead of HSV (because HSL was more readily available than HSV).

I don't know what effect does that have.
