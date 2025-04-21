module SevenSegment.Config exposing
    ( Config, init, withoutBevel, withColors
    , backgroundColor, foregroundColor, includeBevel, widthPixels
    )

{-| Configuration for a seven-segment display.

@docs Config, init, withoutBevel, withColors
@docs backgroundColor, foregroundColor, includeBevel, widthPixels

-}

import SevenSegment.Color exposing (Color)


{-| Configuration for a seven-segment display.
-}
type Config
    = Config ConfigRecord


type alias ConfigRecord =
    { foregroundColor : Color
    , backgroundColor : Color
    , widthPixels : Int
    , includeBevel : Bool
    }


{-| Default configuration for a red seven-segment display with a bevel. Specify the width in pixels. The display is roughly twice the width in height.
-}
init : { widthPixels : Int } -> Config
init r =
    Config
        { foregroundColor = { red = 255, green = 0, blue = 0 }
        , backgroundColor = { red = 0, green = 0, blue = 0 }
        , widthPixels = r.widthPixels
        , includeBevel = True
        }


{-| Remove the default bevel.
-}
withoutBevel : Config -> Config
withoutBevel =
    modify <| \r -> { r | includeBevel = False }


{-| Change the default red-on-black configuration.
-}
withColors :
    { foregroundColor : Color
    , backgroundColor : Color
    }
    -> Config
    -> Config
withColors c =
    modify <| \r -> { r | foregroundColor = c.foregroundColor, backgroundColor = c.backgroundColor }


{-| Read the foreground color out of the Config.
-}
foregroundColor : Config -> Color
foregroundColor (Config r) =
    r.foregroundColor


{-| Read the background color out of the Config.
-}
backgroundColor : Config -> Color
backgroundColor (Config r) =
    r.backgroundColor


{-| Read the width in pixels out of the Config.
-}
widthPixels : Config -> Int
widthPixels (Config r) =
    r.widthPixels


{-| Read the includeBevel out of the Config.
-}
includeBevel : Config -> Bool
includeBevel (Config r) =
    r.includeBevel


modify : (ConfigRecord -> ConfigRecord) -> Config -> Config
modify f (Config r) =
    Config <| f r
