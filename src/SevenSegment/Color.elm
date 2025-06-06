module SevenSegment.Color exposing
    ( Color
    , luminosity
    , toRGB, toRGBA
    )

{-| A very minimal / lightweight Color representation that should be easily interoperable with other color libraries.


## Constructor

@docs Color


## Analysis

@docs luminosity


## Convert to String

@docs toRGB, toRGBA

-}


{-| A very minimal / lightweight Color representation that should be easily interoperable with other color libraries. This is exposed as a simple
type alias because

  - There should be no reason for this to change in the future based on how it is used in this library.
  - It is not intended to be a rich Api.

-}
type alias Color =
    { red : Int, green : Int, blue : Int }


{-| Encode a color as an RGBA string.
-}
toRGBA : Float -> Color -> String
toRGBA alpha { red, green, blue } =
    String.concat
        [ "rgba("
        , String.join ", " <| List.map String.fromInt [ red, green, blue ] ++ [ String.fromFloat alpha ]
        , ")"
        ]


{-| Encode a color as an RGB string.
-}
toRGB : Color -> String
toRGB { red, green, blue } =
    String.concat
        [ "rgb("
        , String.join ", " <| List.map String.fromInt [ red, green, blue ]
        , ")"
        ]


{-| The luminosity (brightness) of a color as a value from 0..255.
-}
luminosity : Color -> Int
luminosity { red, green, blue } =
    ((blue * 11) + (red * 30) + (green * 59)) // 100
