module Types exposing (DocType(..), Model, Msg(..))

import Browser.Dom as Dom
import Editor exposing (Editor)
import File exposing (File)
import Outside
import Render exposing (RenderingData)
import Render.Types exposing (RenderMsg)



-- MODEL


type alias Model =
    { editor : Editor
    , renderingData : RenderingData
    , counter : Int
    , width : Float
    , height : Float
    , docTitle : String
    , docType : DocType
    , fileName : Maybe String
    , selectedId : ( Int, Int )
    , selectedId_ : String
    , message : String
    }


type DocType
    = MarkdownDoc
    | MiniLaTeXDoc



-- MSG


type Msg
    = NoOp
    | EditorMsg Editor.EditorMsg
    | WindowSize Int Int
    | Load String
    | ToggleDocType
    | NewDocument
    | SetViewPortForElement (Result Dom.Error ( Dom.Element, Dom.Viewport ))
    | RequestFile
    | RequestedFile File
    | DocumentLoaded String
    | SaveFile
    | ExportFile
    | SyncLR
    | Outside Outside.InfoForElm
    | LogErr String
    | RenderMsg RenderMsg
