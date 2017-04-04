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
  , sum : Int
  , clock : Int
  , ceiling : Int
  , delay : Int
  , showSum : Bool
  }


init : ( Model, Cmd Msg )
init =
  Model ( 0, 0 ) 0 0 9 2 False ! []



-- UPDATE


type Msg
  = Tick Time
  | SetPair ( Int, Int )
  | SetCeiling String
  | SetDelay String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Tick _ ->
      tick model

    SetPair (( i1, i2 ) as pair) ->
      { model | pair = pair, sum = i1 + i2 } ! []

    SetCeiling str ->
      { model | ceiling = Result.withDefault 9 <| String.toInt str } ! []

    SetDelay str ->
      { model | delay = Result.withDefault 2 <| String.toInt str } ! []


tick : Model -> ( Model, Cmd Msg )
tick ({ clock, delay } as oldModel) =
  let
    model =
      { oldModel | clock = oldModel.clock + 1 }
  in
    if clock == 1 then
      { model | showSum = False } ! [ generateRandomPair model ]
    else if clock == delay + 1 then
      { model | showSum = True } ! []
    else if clock > delay + 2 then
      tick { model | clock = 0 }
    else
      model ! []


generateRandomPair : Model -> Cmd Msg
generateRandomPair model =
  let
    int =
      Random.int 0 model.ceiling

    pair =
      Random.pair int int
  in
    Random.generate SetPair pair



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Time.every Time.second Tick



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
      , sum model
      , separator
      , ceilingInput model
      , delayInput model
      ]


separator : Html Msg
separator =
  div []
    [ br [] []
    , br [] []
    , br [] []
    , hr [] []
    ]


ceilingInput : Model -> Html Msg
ceilingInput model =
  input [ onInput SetCeiling, placeholder "Ceiling (default: 9)" ] []


delayInput : Model -> Html Msg
delayInput model =
  input [ onInput SetDelay, placeholder "Delay (default: 2s)" ] []


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


sum : Model -> Html Msg
sum model =
  let
    styles =
      [ ( "margin-top", "15px" )
      , ( "margin-bottom", "15px" )
      ]

    sum =
      if model.showSum then
        toString model.sum
      else
        ""
  in
    p [ style styles ]
      [ span [ hidden ] [ text "+" ]
      , nbsp
      , text sum
      ]


hidden : Html.Attribute Msg
hidden =
  style [ ( "visibility", "hidden" ) ]


nbsp : Html Msg
nbsp =
  span [ property "innerHTML" <| Json.Encode.string "&nbsp;" ] []
