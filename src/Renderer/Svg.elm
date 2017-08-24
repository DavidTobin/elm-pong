module Renderer.Svg exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Game exposing (..)
import Color.Convert exposing (..)
import Player exposing (..)


render : Game -> Svg a
render game =
    let
        size =
            toString game.board.size
    in
        svg
            [ width size
            , height size
            , "0 0 " ++ size ++ " " ++ size |> viewBox
            ]
            ([ renderBoard game.board
             , renderDebug game
             ]
                ++ List.map (\player -> renderPlayer player) game.players
            )


renderBoard : Board -> Svg a
renderBoard board =
    g []
        [ rect
            [ colorToCssRgb board.color |> fill
            , toString board.size |> width
            , toString board.size |> height
            ]
            []
        ]


renderDebug : Game -> Svg a
renderDebug game =
    g []
        [ text_
            [ x "0"
            , y <| toString <| game.board.size - 50
            , fill "white"
            ]
            [ toString game.players |> text
            ]
        ]


renderPlayer : Player -> Svg a
renderPlayer player =
    let
        ( xPos, yPos ) =
            player.position

        x_ =
            toString xPos

        y_ =
            toString yPos
    in
        g []
            [ rect
                [ colorToCssRgb player.color |> fill
                , width "5"
                , height "100"
                , x x_
                , y y_
                ]
                []
            ]
