module Renderer.Svg exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Game exposing (..)
import Color.Convert exposing (..)
import Player exposing (..)
import Ball exposing (..)
import Settings exposing (..)


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
                ++ List.map (\ball -> renderBall ball) game.balls
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


renderBall : Ball -> Svg a
renderBall ball =
    let
        ( x_, y_ ) =
            ball.position

        x =
            toString x_

        y =
            toString y_
    in
        g []
            [ circle
                [ toString ball.size |> r
                , cx x
                , cy y
                , colorToCssRgb ball.color |> fill
                ]
                []
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
                , height <| toString (boardSize // 7)
                , x x_
                , y y_
                ]
                []
            ]
