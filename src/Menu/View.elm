module Menu.View exposing (toItemGroups, viewContextMenu)

import ContextMenu exposing (ContextMenu)
import Html as H exposing (Attribute, Html)
import Menu.Config
import Menu.Style
import Model exposing (Config, Context(..), Hover(..), Model, Msg(..), Position, Selection(..))


viewContextMenu : Float -> Model -> Html Msg
viewContextMenu width model =
    H.div
        []
        [ H.div
            (ContextMenu.open ContextMenuMsg Background :: Menu.Style.backgroundStyles)
            [ H.div
                (ContextMenu.open ContextMenuMsg Object :: Menu.Style.objectStyles width)
                []
            ]
        , H.div [] []
        , ContextMenu.view
            Menu.Config.winChrome
            ContextMenuMsg
            toItemGroups
            model.contextMenu
        ]



-- MENU --


toItemGroups : Context -> List (List ( ContextMenu.Item, Msg ))
toItemGroups context =
    case context of
        Object ->
            [ [ ( ContextMenu.item "Line Start" |> ContextMenu.shortcut "Ctrl-A", MoveToLineStart )
              , ( ContextMenu.item "Copy" |> ContextMenu.shortcut "Ctrl-C", Copy )
              , ( ContextMenu.item "Copy to system clipboard" |> ContextMenu.shortcut "Ctrl-shift-C", WriteToSystemClipBoard )
              , ( ContextMenu.item "Delete Forward" |> ContextMenu.shortcut "Ctrl-D", RemoveCharAfter )
              , ( ContextMenu.item "Line End" |> ContextMenu.shortcut "Ctrl-E", MoveToLineEnd )
              , ( ContextMenu.item "Kill Line" |> ContextMenu.shortcut "Ctrl-K", KillLine )
              , ( ContextMenu.item "Delete Line" |> ContextMenu.shortcut "Ctrl-U", DeleteLine )
              , ( ContextMenu.item "Paste" |> ContextMenu.shortcut "Ctrl-V", Paste )
              , ( ContextMenu.item "Paste from system clipboard" |> ContextMenu.shortcut "Ctrl-shift-V", Paste )
              , ( ContextMenu.item "Search" |> ContextMenu.shortcut "Ctrl-S", ToggleSearchPanel )
              , ( ContextMenu.item "Cut" |> ContextMenu.shortcut "Ctrl-X", Cut )
              , ( ContextMenu.item "Redo" |> ContextMenu.shortcut "Ctrl-Y", Redo )
              , ( ContextMenu.item "Undo" |> ContextMenu.shortcut "Ctrl-Z", Undo )
              , ( ContextMenu.item "Wrap" |> ContextMenu.shortcut "Ctrl-W", WrapSelection )
              , ( ContextMenu.item "Wrap all" |> ContextMenu.shortcut "Ctrl-shift-W", WrapAll )
              ]
            , [ ( ContextMenu.item "Clear" |> ContextMenu.shortcut "Ctrl-Opt-C", Clear )
              ]
            , [ ( ContextMenu.item "Move up" |> ContextMenu.shortcut "ArrowUp", MoveUp )
              , ( ContextMenu.item "Move down" |> ContextMenu.shortcut "ArrowDown", MoveDown )
              , ( ContextMenu.item "Move left" |> ContextMenu.shortcut "ArrowLeft", MoveLeft )
              , ( ContextMenu.item "Move Right" |> ContextMenu.shortcut "ArrowRight", MoveRight )
              ]
            , [ ( ContextMenu.item "Page up" |> ContextMenu.shortcut "Opt-ArrowUp", PageUp )
              , ( ContextMenu.item "Page down" |> ContextMenu.shortcut "Opt-ArrowDown", PageDown )
              , ( ContextMenu.item "Line start" |> ContextMenu.shortcut "Opt-ArrowLeft", MoveToLineStart )
              , ( ContextMenu.item "Line end" |> ContextMenu.shortcut "Opt-ArrowRight", MoveToLineEnd )
              ]
            , [ ( ContextMenu.item "First line" |> ContextMenu.shortcut "Ctrl-Opt-ArrowUp", FirstLine )
              , ( ContextMenu.item "Last line" |> ContextMenu.shortcut "Ctrl-Opt-ArrowDown", LastLine )
              ]

            --, [ ( ContextMenu.item "Open file" |> ContextMenu.shortcut "Ctrl-O", RequestFile )
            --  , ( ContextMenu.item "Save file" |> ContextMenu.shortcut "Ctrl-Opt-S", SaveFile )
            --  ]
            , [ ( ContextMenu.item "Toggle dark mode" |> ContextMenu.shortcut "Ctrl-Shift-D", ToggleDarkMode )
              ]
            ]

        Background ->
            [ [ ( ContextMenu.item "Nothing here yet", Item 8 )
              , ( ContextMenu.itemWithAnnotation "This editor is a work in progress" "Watch this space for more info:-)"
                    |> ContextMenu.disabled False
                , Item 7
                )
              ]
            ]
