module Internal.Util exposing (..)

import Elm.Syntax.Declaration as Declaration
import Elm.Syntax.ModuleName as ModuleName
import Elm.Syntax.Node as Node exposing (Node(..))
import Elm.Syntax.Range exposing (emptyRange)


type Declaration
    = Declaration Expose (List Module) Declaration.Declaration


{-| -}
expose : Declaration -> Declaration
expose (Declaration _ imports body) =
    Declaration Exposed imports body


{-| -}
exposeConstructor : Declaration -> Declaration
exposeConstructor (Declaration metadata imports body) =
    Declaration ExposedConstructor imports body


type Module
    = Module ModuleName.ModuleName (Maybe String)


makeImport (Module name maybeAlias) =
    nodify
        { moduleName = nodify name
        , moduleAlias =
            Maybe.map
                (\al ->
                    nodify [ al ]
                )
                maybeAlias
        , exposingList = Nothing
        }


fullModName : Module -> String
fullModName (Module name _) =
    String.join "." name


getModule : Module -> ModuleName.ModuleName
getModule (Module name _) =
    name


type Expose
    = NotExposed
    | Exposed
    | ExposedConstructor


emptyModule : Module
emptyModule =
    inModule []


inModule : List String -> Module
inModule mods =
    Module (List.map formatType mods) Nothing


moduleAs : List String -> String -> Module
moduleAs mods modAlias =
    Module (List.map formatType mods) (Just modAlias)


unpack : Module -> ModuleName.ModuleName
unpack (Module name maybeAlias) =
    case maybeAlias of
        Nothing ->
            name

        Just modAlias ->
            [ modAlias ]


denode : Node a -> a
denode =
    Node.value


denodeAll : List (Node a) -> List a
denodeAll =
    List.map denode


denodeMaybe : Maybe (Node a) -> Maybe a
denodeMaybe =
    Maybe.map denode


nodify : a -> Node a
nodify exp =
    Node emptyRange exp


nodifyAll : List a -> List (Node a)
nodifyAll =
    List.map nodify


nodifyMaybe : Maybe a -> Maybe (Node a)
nodifyMaybe =
    Maybe.map nodify


nodifyTuple : ( a, b ) -> ( Node a, Node b )
nodifyTuple ( a, b ) =
    ( nodify a, nodify b )


formatValue : String -> String
formatValue str =
    String.toLower (String.left 1 str) ++ String.dropLeft 1 str


formatType : String -> String
formatType str =
    String.toUpper (String.left 1 str) ++ String.dropLeft 1 str
