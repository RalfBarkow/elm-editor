module Update.File exposing (read, requestMarkdownFile, save)

import File exposing (File)
import File.Download as Download
import File.Select as Select
import Model exposing (Msg(..))
import Task



-- FILE I/O


read : File -> Cmd Msg
read file =
    Task.perform MarkdownLoaded (File.toString file)


requestMarkdownFile : Cmd Msg
requestMarkdownFile =
    Select.file [ "text/markdown" ] EditorRequestedFile


save : String -> Cmd msg
save markdown =
    Download.string "foo.md" "text/markdown" markdown
