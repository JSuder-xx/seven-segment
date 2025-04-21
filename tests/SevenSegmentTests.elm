module SevenSegmentTests exposing (..)

import Expect
import SevenSegment exposing (digits, minus)
import Test exposing (..)


suite : Test
suite =
    describe "fromInt" <|
        List.concatMap
            (\( given, expected ) ->
                (test (String.fromInt given) <| \_ -> SevenSegment.fromInt given |> Expect.equal expected)
                    :: (let
                            negGiven =
                                -1 * given
                        in
                        if String.fromInt negGiven /= String.fromInt given then
                            [ test (String.fromInt negGiven) <| \_ -> SevenSegment.fromInt negGiven |> Expect.equal (minus :: expected) ]

                        else
                            []
                       )
            )
        <|
            [ ( 0, [ digits.d0 ] )
            , ( 5, [ digits.d5 ] )
            , ( 20, [ digits.d2, digits.d0 ] )
            , ( 29, [ digits.d2, digits.d9 ] )
            , ( 123, [ digits.d1, digits.d2, digits.d3 ] )
            , ( 99991, [ digits.d9, digits.d9, digits.d9, digits.d9, digits.d1 ] )
            , ( 99990, [ digits.d9, digits.d9, digits.d9, digits.d9, digits.d0 ] )
            ]
