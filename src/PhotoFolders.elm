module PhotoFolders exposing (main)
 
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Dict exposing (Dict)
 
 
type alias Model =
    { selectedPhotoUrl : Maybe String
    , photos : Dict String Photo
    , root : Folder
    }
 
 
initialModel : Model
initialModel =
    { selectedPhotoUrl = Nothing 
    , photos = Dict.empty
    , root = Folder { name = "Loading...", photoUrls = [], subfolders = [] } 
    }
 
 
init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Http.get
        { url = "http://elm-in-action.com/folders/list"
        , expect = Http.expectJson GotInitialModel modelDecoder
        }
    )
 
 
modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed
        { selectedPhotoUrl = Just "trevi"
        , photos = Dict.fromList
             [ ( "trevi", { title = "Trevi", relatedUrls = [ "coli", "fresco" ], size = 34, url ="trevi" } )
             , ( "fresco", { title = "Fresco", relatedUrls = [ "trevi" ], size = 46, url ="fresco" } )
             , ( "coli", { title = "Coliseum", relatedUrls = [ "trevi", "fresco" ], size = 36, url ="coli" } )
             ]
        , root =
            Folder { name = "Photos", photoUrls = [], subfolders = [
                Folder { name = "2016", photoUrls = [ "trevi", "coli" ], subfolders = [
                Folder { name = "outdoors", photoUrls = [], subfolders = [] },
                Folder { name = "indoors", photoUrls = [ "fresco" ], subfolders = [] }
            ]},
            Folder { name = "2017", photoUrls = [], subfolders = [
                Folder { name = "outdoors", photoUrls = [], subfolders = [] },
                Folder { name = "indoors", photoUrls = [], subfolders = [] }
            ]}
        ]}
        }
 
type Msg
    = ClickedPhoto String
    | GotInitialModel (Result Http.Error Model)
 
 
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedPhoto url ->
            ( { model | selectedPhotoUrl = Just url }, Cmd.none )
 
        GotInitialModel (Ok newModel) ->
            ( newModel, Cmd.none )
 
        GotInitialModel (Err _) ->
            ( model, Cmd.none )

type Folder =
    Folder
        { name : String
        , photoUrls : List String
        , subfolders : List Folder
        }

view : Model -> Html Msg
view model =
    let
        photoByUrl : String -> Maybe Photo
        photoByUrl url =
            Dict.get url model.photos
 
        selectedPhoto : Html Msg
        selectedPhoto =
            case Maybe.andThen photoByUrl model.selectedPhotoUrl of
                Just photo ->
                    viewSelectedPhoto photo
 
                Nothing ->
                    text ""
    in
    div [ class "content" ]
        [ div [ class "selected-photo" ] [ selectedPhoto ] ]
 
main : Program () Model Msg
main =
    Browser.element { init = init, view = view, update = update, subscriptions = \_ -> Sub.none }

type alias Photo =
    { title : String
    , size : Int
    , relatedUrls : List String
    , url : String
    }
 
viewSelectedPhoto : Photo -> Html Msg
viewSelectedPhoto photo =
    div
        [ class "selected-photo" ]
        [ h2 [] [ text photo.title ]
        , img [src (urlPrefix ++ "photos/" ++ photo.url ++ "/full") ] []
        , span [] [ text (String.fromInt photo.size ++ "KB") ]
        , h3 [] [ text "Related" ]
        , div [ class "related-photos" ]
            (List.map viewRelatedPhoto photo.relatedUrls)
        ]
 
 
viewRelatedPhoto : String -> Html Msg
viewRelatedPhoto url =
    img
        [ class "related-photo"
        , onClick (ClickedPhoto url)
        , src (urlPrefix ++ "photos/" ++ url ++ "/thumb")
        ]
        []

viewFolder : Folder -> Html Msg
viewFolder (Folder folder) =
    let
        subfolders =
            List.map viewFolder folder.subfolders
    in
    div [ class "folder" ]
        [ label [] [ text folder.name ]
        , div [ class "subfolders" ] subfolders
        ]
 
 
urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


