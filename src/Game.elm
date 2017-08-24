module Game exposing (..)

import Color exposing (..)
import Player exposing (..)
import Keyboard exposing (..)
import Time exposing (..)
import Settings exposing (..)


type alias Board =
    { color : Color
    , size : Int
    }


type alias Game =
    { board : Board
    , players : List Player
    }


type Msg
    = KeyPress KeyCode
    | Tick
    | PlayerMsg Player Player.Msg


update : Msg -> Game -> ( Game, Cmd Msg )
update msg game =
    case msg of
        KeyPress code ->
            game ! []

        PlayerMsg player playerMsg ->
            let
                ( updatedPlayer, playerCmds ) =
                    Player.update playerMsg player

                updatedPlayers =
                    List.map
                        (\p ->
                            if player == p then
                                updatedPlayer
                            else
                                p
                        )
                        game.players
            in
                { game | players = updatedPlayers } ! [ Cmd.map (\playerMsg -> PlayerMsg player playerMsg) playerCmds ]

        Tick ->
            game ! []


subscriptions : Game -> Sub Msg
subscriptions game =
    Sub.batch
        ([ presses (\key -> KeyPress key)
         , Time.every Settings.fps (\_ -> Tick)
         ]
            ++ List.map (\player -> Sub.map (\msg -> PlayerMsg player msg) (Player.subscriptions player)) game.players
        )
