module Ball exposing (..)

import Color exposing (..)


type alias Coords =
    ( Int, Int )


type alias Ball =
    { size : Int
    , position : Coords
    , color : Color
    }
