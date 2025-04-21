module SevenSegment exposing
    ( NumberOfDigits(..), intView, view
    , SevenSegment, digits, minus, fromInt
    )

{-| A `SevenSegment` display renderer.


## View

@docs NumberOfDigits, intView, view


## Data

@docs SevenSegment, digits, minus, fromInt

-}

import Array
import Html exposing (Html, div, span)
import Html.Attributes exposing (style)
import SevenSegment.Color as Color
import SevenSegment.Config as Config exposing (Config, foregroundColor, widthPixels)


{-| A record of flags indicating which segments of a seven-segment display should be illuminated.

  - Segments prefixed with 'h' are horizontal segments.
  - Segments prefixed with 'v' are vertical segments.

-}
type alias SevenSegment =
    { hTop : Bool
    , hMiddle : Bool
    , hBottom : Bool
    , vUpperLeft : Bool
    , vUpperRight : Bool
    , vLowerLeft : Bool
    , vLowerRight : Bool
    }


empty : SevenSegment
empty =
    { hTop = False
    , hMiddle = False
    , hBottom = False
    , vUpperLeft = False
    , vUpperRight = False
    , vLowerLeft = False
    , vLowerRight = False
    }


hTop : SevenSegment -> SevenSegment
hTop s =
    { s | hTop = True }


hMiddle : SevenSegment -> SevenSegment
hMiddle s =
    { s | hMiddle = True }


hBottom : SevenSegment -> SevenSegment
hBottom s =
    { s | hBottom = True }


vUpperLeft : SevenSegment -> SevenSegment
vUpperLeft s =
    { s | vUpperLeft = True }


vUpperRight : SevenSegment -> SevenSegment
vUpperRight s =
    { s | vUpperRight = True }


vLowerLeft : SevenSegment -> SevenSegment
vLowerLeft s =
    { s | vLowerLeft = True }


vLowerRight : SevenSegment -> SevenSegment
vLowerRight s =
    { s | vLowerRight = True }


{-| The digits 0..9 as `SevenSegment` displays.
-}
digits : { d0 : SevenSegment, d1 : SevenSegment, d2 : SevenSegment, d3 : SevenSegment, d4 : SevenSegment, d5 : SevenSegment, d6 : SevenSegment, d7 : SevenSegment, d8 : SevenSegment, d9 : SevenSegment }
digits =
    let
        make : List (SevenSegment -> SevenSegment) -> SevenSegment
        make =
            List.foldl (<|) empty
    in
    { d0 = make [ hTop, hBottom, vUpperLeft, vUpperRight, vLowerLeft, vLowerRight ]
    , d1 = make [ vUpperRight, vLowerRight ]
    , d2 = make [ hTop, hMiddle, hBottom, vUpperRight, vLowerLeft ]
    , d3 = make [ hTop, hMiddle, hBottom, vUpperRight, vLowerRight ]
    , d4 = make [ hMiddle, vUpperLeft, vUpperRight, vLowerRight ]
    , d5 = make [ hTop, hMiddle, hBottom, vUpperLeft, vUpperRight ]
    , d6 = make [ hTop, hMiddle, hBottom, vUpperLeft, vUpperRight, vLowerRight ]
    , d7 = make [ hTop, vUpperRight, vLowerRight ]
    , d8 = make [ hTop, hMiddle, hBottom, vUpperLeft, vUpperRight, vLowerLeft, vLowerRight ]
    , d9 = make [ hTop, hMiddle, hBottom, vUpperLeft, vUpperRight, vLowerRight ]
    }


{-| The minus symbol.
-}
minus : SevenSegment
minus =
    hMiddle empty


digitsAll : Array.Array SevenSegment
digitsAll =
    Array.fromList [ digits.d0, digits.d1, digits.d2, digits.d3, digits.d4, digits.d5, digits.d6, digits.d7, digits.d8, digits.d9 ]


{-| Produce a list of `SevenSegment`s to display the value of the given integer (including a leading minus symbol if negative).
-}
fromInt : Int -> List SevenSegment
fromInt i =
    let
        go acc num =
            let
                next =
                    toDigit num :: acc
            in
            if num > 9 then
                go next (num // 10)

            else
                next

        toDigit =
            modBy 10 >> (\d -> Maybe.withDefault digits.d0 <| Array.get d digitsAll)
    in
    if i >= 0 then
        go [] i

    else
        minus :: (go [] <| abs i)


{-| Render a single seven-segment display.
-}
view : Config -> SevenSegment -> Html msg
view config segment =
    let
        widthPixels =
            Config.widthPixels config

        lineWidth =
            widthPixels // 5

        foregroundColor =
            Config.foregroundColor config

        borderPrefix =
            "solid " ++ pixels lineWidth ++ " "

        border location accessor =
            style ("border-" ++ location) <|
                borderPrefix
                    ++ Color.toRGBA
                        (if accessor segment then
                            1.0

                         else
                            0.15
                        )
                        foregroundColor

        pixels px =
            String.fromInt px ++ "px"

        widthPixelsStr =
            pixels widthPixels

        box additionalStyles =
            div
                (additionalStyles
                    ++ [ style "width" widthPixelsStr
                       , style "height" widthPixelsStr
                       ]
                )
                []

        bevel =
            if Config.includeBevel config then
                let
                    backgroundContrastColor =
                        if Color.luminosity (Config.backgroundColor config) > 127 then
                            { red = 0, green = 0, blue = 0 }

                        else
                            { red = 255, green = 255, blue = 255 }

                    highContrastBevel =
                        "solid 2px " ++ Color.toRGBA 0.8 backgroundContrastColor

                    lowContrastBevel =
                        "solid 2px " ++ Color.toRGBA 0.3 backgroundContrastColor
                in
                [ style "border-top" highContrastBevel
                , style "border-left" highContrastBevel
                , style "border-bottom" lowContrastBevel
                , style "border-right" lowContrastBevel
                ]

            else
                []
    in
    span
        (bevel
            ++ [ style "margin-left" <| pixels (widthPixels // 8)
               , style "display" "inline-block"
               , style "background-color" <| Color.toRGB <| Config.backgroundColor config
               , style "padding" "4px"
               ]
        )
        [ box
            [ border "top" .hTop
            , border "left" .vUpperLeft
            , border "right" .vUpperRight
            , border "bottom" .hMiddle
            ]
        , box
            [ border "left" .vLowerLeft
            , border "right" .vLowerRight
            , border "bottom" .hBottom
            ]
        ]


{-| Number of digits when rendering an integer with a seven-segment display. The number will be left padding to this value.
-}
type NumberOfDigits
    = NumberOfDigits Int


{-| Render an integer using a seven-segment display
-}
intView : Config -> NumberOfDigits -> Int -> Html msg
intView config (NumberOfDigits numberOfDigits) =
    fromInt
        >> padListLeftTo numberOfDigits digits.d0
        >> List.map (view config)
        >> span
            (style "display" "inline-block"
                :: (if Config.includeBevel config then
                        []

                    else
                        [ style "background-color" <| Color.toRGB <| Config.backgroundColor config ]
                   )
            )


padListLeftTo : Int -> a -> List a -> List a
padListLeftTo target padWith source =
    let
        len =
            List.length source
    in
    if len >= target then
        source

    else
        List.repeat (target - len) padWith ++ source
