module Main exposing (..)

import Html exposing (..)
import Svg exposing (Svg)
import Renderer.Svg exposing (..)
import Game exposing (Game, Board)
import Color exposing (..)
import Player exposing (..)
import Char exposing (..)


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
            Board black 750

        player1 =
            Player ( 38, 40 ) ( 50, 375 ) white Player.Nothing

        player2 =
            Player ( 37, 39 ) ( 700, 375 ) green Player.Nothing
    in
        { game = Game board [ player1, player2 ]
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
