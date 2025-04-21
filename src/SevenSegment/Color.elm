module SevenSegment.Color exposing
    ( luminosity
    , toRGB, toRGBA
    , Color
    )

{-| A very minimal / lightweight Color representation that should be easily interoperable with other color libraries.


## Analysis

@docs luminosity


## Convert to String

@docs toRGB, toRGBA

-}


{-| A very minimal / lightweight Color representation that should be easily interoperable with other color libraries.
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
