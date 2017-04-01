module AdditionPractice exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode
import Time exposing (Time)
import Random


main =
  Html.program
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model =
  { pair : ( Int, Int )
  , sum : Maybe Int
  , interval : Float
  }


init : ( Model, Cmd Msg )
init =
  Model ( 0, 0 ) Nothing 2.0 ! []



-- UPDATE


type Msg
  = NewPair Time
  | ShowSum Time
  | NewRandomPair ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NewPair _ ->
      model ! [ generateRandomPair ]

    ShowSum _ ->
      let
        ( int1, int2 ) =
          model.pair
      in
        { model | sum = Just <| int1 + int2 } ! []

    NewRandomPair pair ->
      { model | pair = pair, sum = Nothing } ! []


generateRandomPair : Cmd Msg
generateRandomPair =
  let
    int =
      Random.int 0 9

    pair =
      Random.pair int int
  in
    Random.generate NewRandomPair pair



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions { interval } =
  Sub.batch
    [ Time.every (2 * interval * Time.second) NewPair
    , Time.every (interval * Time.second) ShowSum
    ]



-- VIEW


view : Model -> Html Msg
view model =
  let
    styles =
      [ ( "text-align", "center" )
      , ( "font-family", "sans-serif" )
      , ( "font-weight", "bold" )
      , ( "font-size", "50px" )
      ]

    ( int1, int2 ) =
      model.pair
  in
    div [ style styles ]
      [ operand1 int1
      , operand2 int2
      , line
      , sum model.sum
      ]


operand1 : Int -> Html Msg
operand1 int =
  let
    styles =
      [ ( "margin-bottom", "0px" ) ]
  in
    p [ style styles ]
      [ span [ hidden ] [ text "+" ]
      , nbsp
      , text <| toString int
      ]


operand2 : Int -> Html Msg
operand2 int =
  let
    styles =
      [ ( "margin-top", "15px" )
      , ( "margin-bottom", "15px" )
      ]
  in
    p [ style styles ]
      [ span [] [ text "+" ]
      , nbsp
      , text <| toString int
      ]


line : Html Msg
line =
  let
    styles =
      [ ( "width", "20%" )
      , ( "border", "2px solid black" )
      ]
  in
    hr [ style styles ] []


sum : Maybe Int -> Html Msg
sum maybeSum =
  let
    styles =
      [ ( "margin-top", "15px" )
      , ( "margin-bottom", "15px" )
      ]
  in
    p [ style styles ]
      [ span [ hidden ] [ text "+" ]
      , nbsp
      , text <| Maybe.withDefault "" <| Maybe.map toString maybeSum
      ]


hidden : Html.Attribute Msg
hidden =
  style [ ( "visibility", "hidden" ) ]


nbsp : Html Msg
nbsp =
  span [ property "innerHTML" <| Json.Encode.string "&nbsp;" ] []
