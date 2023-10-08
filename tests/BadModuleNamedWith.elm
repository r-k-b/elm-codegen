module BadModuleNamedWith exposing (dummyDecoder)

{-| This module produces Gen code containing:

```
, annotation = Just (Type.namedWith [ "JD" ] "Decoder" [ Type.string ])
```

which leads to generated code trying to `import JD`, which does not exist.

-}

import Json.Decode as JD


dummyDecoder : JD.Decoder String
dummyDecoder =
    JD.succeed ""
