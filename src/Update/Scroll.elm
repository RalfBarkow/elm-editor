module Update.Scroll exposing
    ( jumpToBottom
    , jumpToHeightForSync
    , rollSearchSelectionBackward
    , rollSearchSelectionForward
    , sendLine
    , setEditorViewportForLine
    , toString
    )

import Array
import Browser.Dom as Dom
import Model exposing (Model, Msg(..), Position, Selection(..))
import RollingList
import Search
import Task exposing (Task)


setEditorViewportForLine : Float -> Int -> Cmd Msg
setEditorViewportForLine lineHeight lineNumber =
    let
        y =
            toFloat lineNumber * lineHeight
    in
    case y >= 0 of
        True ->
            Dom.setViewportOf "__editor__" 0 y
                |> Task.andThen (\_ -> Dom.getViewportOf "__editor__")
                |> Task.attempt (\info -> GotViewport info)

        False ->
            Cmd.none


{-| Search for str and scroll to first hit. Used internally.
-}
toString : String -> Model -> ( Model, Cmd Msg )
toString str model =
    let
        searchResults =
            Search.hits str model.lines
    in
    case List.head searchResults of
        Nothing ->
            ( { model | searchResults = RollingList.fromList [], searchTerm = str, selection = NoSelection }, Cmd.none )

        Just (Selection cursor end) ->
            ( { model
                | cursor = cursor
                , selection = Selection cursor end
                , searchResults = RollingList.fromList searchResults
                , searchTerm = str
                , searchResultIndex = 0
              }
            , setEditorViewportForLine model.lineHeight (max 0 (cursor.line - 5))
            )

        _ ->
            ( { model | searchResults = RollingList.fromList [], searchTerm = str, selection = NoSelection }, Cmd.none )


jumpToHeightForSync : Maybe String -> Position -> Selection -> Float -> Cmd Msg
jumpToHeightForSync currentLine cursor selection y =
    Dom.setViewportOf "__editor__" 0 (y - 80)
        |> Task.andThen (\_ -> Dom.getViewportOf "__editor__")
        |> Task.attempt (\info -> GotViewportForSync currentLine selection info)


jumpToBottom : Model -> Cmd Msg
jumpToBottom model =
    case model.cursor.line == (Array.length model.lines - 1) of
        False ->
            Cmd.none

        True ->
            Dom.getViewportOf "__editor__"
                |> Task.andThen (\info -> Dom.setViewportOf "__editor__" 0 info.scene.height)
                |> Task.attempt (\_ -> EditorNoOp)



--
--setViewportForElement : String -> Cmd Msg
--setViewportForElement id =
--    Dom.getViewportOf "__RENDERED_TEXT__"
--        |> Task.andThen (\vp -> getElementWithViewPort vp id)
--        |> Task.attempt SetViewPortForElement
--


getElementWithViewPort : Dom.Viewport -> String -> Task Dom.Error ( Dom.Element, Dom.Viewport )
getElementWithViewPort vp id =
    Dom.getElement id
        |> Task.map (\el -> ( el, vp ))


rollSearchSelectionForward : Model -> ( Model, Cmd Msg )
rollSearchSelectionForward model =
    let
        searchResults_ =
            RollingList.roll model.searchResults

        searchResultList =
            RollingList.toList searchResults_

        maxSearchHitIndex =
            searchResultList |> List.length |> (\x -> x - 1)

        newSearchResultIndex =
            if model.searchResultIndex >= maxSearchHitIndex then
                0

            else
                model.searchResultIndex + 1
    in
    case RollingList.current searchResults_ of
        Just (Selection cursor end) ->
            ( { model
                | cursor = cursor
                , selection = Selection cursor end
                , searchResults = searchResults_
                , searchResultIndex = newSearchResultIndex
              }
            , setEditorViewportForLine model.lineHeight (max 0 (cursor.line - 5))
            )

        _ ->
            ( model, Cmd.none )


rollSearchSelectionBackward : Model -> ( Model, Cmd Msg )
rollSearchSelectionBackward model =
    let
        searchResults_ =
            RollingList.rollBack model.searchResults

        searchResultList =
            RollingList.toList searchResults_

        maxSearchResultIndex =
            searchResultList |> List.length |> (\x -> x - 1)

        newSearchResultIndex =
            if model.searchResultIndex == 0 then
                maxSearchResultIndex

            else
                model.searchResultIndex - 1
    in
    case RollingList.current searchResults_ of
        Just (Selection cursor end) ->
            ( { model
                | cursor = cursor
                , selection = Selection cursor end
                , searchResults = searchResults_
                , searchResultIndex = newSearchResultIndex
              }
            , setEditorViewportForLine model.lineHeight (max 0 (cursor.line - 5))
            )

        _ ->
            ( model, Cmd.none )


sendLine : Model -> ( Model, Cmd Msg )
sendLine model =
    let
        y =
            max 0 (model.lineHeight * toFloat model.cursor.line - verticalOffsetInSourceText)

        newCursor =
            { line = model.cursor.line, column = 0 }

        currentLine =
            Array.get newCursor.line model.lines

        selection =
            case Maybe.map String.length currentLine of
                Just n ->
                    Selection newCursor (Position newCursor.line (n - 1))

                Nothing ->
                    NoSelection
    in
    ( { model | cursor = newCursor, selection = selection }, jumpToHeightForSync currentLine newCursor selection y )


verticalOffsetInSourceText =
    4
