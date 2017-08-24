module Player exposing (..)

import Keyboard exposing (..)
import Color exposing (..)
import Time exposing (..)
import Settings exposing (..)


type alias Coords =
    ( Int, Int )


type alias Player =
    { controls : ( KeyCode, KeyCode )
    , position : Coords
    , color : Color
    , movement : Movement
    }


type Movement
    = Up
    | Down
    | Nothing


type Msg
    = KeyDown KeyCode
    | KeyUp KeyCode
    | Tick


update : Msg -> Player -> ( Player, Cmd Msg )
update msg player =
    case msg of
        KeyUp code ->
            updateKeyUp code player

        KeyDown code ->
            updateKeyDown code player

        Tick ->
            tick player


subscriptions : Player -> Sub Msg
subscriptions player =
    Sub.batch
        [ downs (\code -> KeyDown code)
        , ups (\code -> KeyUp code)
        , every Settings.fps (\_ -> Tick)
        ]


tick : Player -> ( Player, Cmd Msg )
tick player =
    let
        ( x, y ) =
            player.position
    in
        case player.movement of
            Up ->
                if (y - playerSpeed) >= 0 then
                    { player | position = ( x, y - playerSpeed ) } ! []
                else
                    player ! []

            Down ->
                if (y + playerSpeed) <= (boardSize - (boardSize // 8)) then
                    { player | position = ( x, y + playerSpeed ) } ! []
                else
                    player ! []

            _ ->
                player ! []


updateKeyUp : KeyCode -> Player -> ( Player, Cmd Msg )
updateKeyUp code player =
    let
        ( up, down ) =
            player.controls
    in
        if code == up || code == down then
            { player | movement = Nothing } ! []
        else
            player ! []


updateKeyDown : KeyCode -> Player -> ( Player, Cmd Msg )
updateKeyDown code player =
    let
        ( up, down ) =
            player.controls

        ( x, y ) =
            player.position
    in
        if code == up then
            { player | movement = Up } ! []
        else if code == down then
            { player | movement = Down } ! []
        else
            player ! []
