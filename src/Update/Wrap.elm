module Update.Wrap exposing (all, selection)

import Action
import Array
import Model exposing (Model, Selection(..))
import Update.Function as Function
import Wrap exposing (WrapParams)


all : Model -> Model
all model =
    let
        params =
            { maximumWidth = maxWrapWidth model, optimalWidth = optimumWrapWidth model, stringWidth = String.length }

        lines =
            Wrap.stringArray params model.lines
    in
    { model | lines = lines }


selection : Model -> Model
selection model =
    case model.selection of
        Selection p1 p2 ->
            let
                params =
                    { maximumWidth = maxWrapWidth model
                    , optimalWidth = optimumWrapWidth model
                    , stringWidth = String.length
                    }

                ( _, selectedText ) =
                    Action.deleteSelection model.selection model.lines

                newLines =
                    Wrap.stringArray params selectedText

                n =
                    Array.length newLines

                c =
                    Array.get (n - 1) newLines
                        |> Maybe.map String.length
                        |> Maybe.withDefault 0

                newCursor =
                    { line = p1.line + n - 1, column = c }
            in
            Function.replaceLines { model | cursor = newCursor } newLines

        _ ->
            model


maxWrapWidth : Model -> Int
maxWrapWidth model =
    charactersPerLine model.width model.fontSize
        - 3
        |> truncate


optimumWrapWidth : Model -> Int
optimumWrapWidth model =
    charactersPerLine model.width model.fontSize
        - 6
        |> truncate


charactersPerLine : Float -> Float -> Float
charactersPerLine screenWidth fontSize =
    (1.55 * screenWidth) / fontSize
