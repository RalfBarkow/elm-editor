module View.Widget exposing
    ( button
    , documentTypeButton
    , exportFileButton
    , loadDocumentButton
    , newDocumentButton
    , openFileButton
    , saveFileButton
    , syncLRButton
    , textField
    )

import Element
    exposing
        ( Element
        , alignRight
        , el
        , paddingXY
        , text
        , width
        )
import Element.Background as Background
import Element.Input as Input
import Html exposing (Attribute, Html)
import Html.Attributes as Attribute
import Html.Events as HE
import Types exposing (DocType(..), Msg(..))
import View.Style as Style


openFileButton model =
    button 90 "Open" RequestFile []


saveFileButton model =
    button 90 "Save" SaveFile []


exportFileButton model =
    case model.docType of
        MarkdownDoc ->
            Element.none

        MiniLaTeXDoc ->
            button 90 "Export" ExportFile []


newDocumentButton model =
    button 90 "New" NewDocument []


documentTypeButton model =
    let
        title =
            case model.docType of
                MarkdownDoc ->
                    "Markdown"

                MiniLaTeXDoc ->
                    "LaTeX"
    in
    button width title ToggleDocType [ Background.color Style.redColor ]


loadDocumentButton model width docTitle buttonLabel =
    let
        bgColor =
            case model.docTitle == docTitle of
                True ->
                    Style.redColor

                False ->
                    Style.grayColor
    in
    button width buttonLabel (Load docTitle) [ Background.color bgColor ]


syncLRButton model =
    button 50 "Sync L > R" SyncLR [ alignRight ]


button width str msg attr =
    Input.button
        ([ paddingXY 8 8
         , Background.color (Element.rgb255 90 90 100)
         ]
            ++ attr
        )
        { onPress = Just msg
        , label = el attr (text str)
        }


textField width str msg attr innerAttr =
    Html.div ([ Attribute.style "margin-bottom" "10px" ] ++ attr)
        [ Html.input
            ([ Attribute.style "height" "18px"
             , Attribute.style "width" (String.fromInt width ++ "px")
             , Attribute.type_ "text"
             , Attribute.placeholder str
             , Attribute.style "margin-right" "8px"
             , HE.onInput msg
             ]
                ++ innerAttr
            )
            []
        ]
