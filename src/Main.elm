module Main exposing (..)

import Html exposing (..)
import Svg exposing (Svg)
import Renderer.Svg exposing (..)
import Game exposing (Game, Board)
import Color exposing (..)
import Player exposing (..)
import Ball exposing (..)
import Char exposing (..)
import Settings exposing (..)


main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { game : Game }


type Msg
    = GameMsg Game.Msg
    | KeyPress


init : ( Model, Cmd Msg )
init =
    let
        board =
            Board black boardSize

        player1 =
            Player ( 38, 40 ) ( boardSize // 15, boardSize // 2 ) white Player.Nothing

        player2 =
            Player ( 37, 39 ) ( boardSize - (boardSize // 15), boardSize // 2 ) green Player.Nothing

        ball =
            Ball 5 ( boardSize // 2, boardSize // 2 ) white
    in
        { game = Game board [ player1, player2 ] [ ball ]
        }
            ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GameMsg m ->
            let
                ( updatedGame, gameCmds ) =
                    Game.update m model.game
            in
                { model | game = updatedGame }
                    ! [ Cmd.map (\gameMsg -> GameMsg gameMsg) gameCmds ]

        _ ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map (\msg -> GameMsg msg) (Game.subscriptions model.game) ]


view : Model -> Svg a
view model =
    render model.game
