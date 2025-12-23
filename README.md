# Elm compiler crash reproduction

When running `elm make src/Main.elm` (available via `npm test` as well), Elm
0.19.1 crashes before completing its error message:

    Detected problems in 1 module.
    -- AMBIGUOUS IMPORT ----------------------------------------------- src/Main.elm

    You are trying to import a `Platform` module:

    elm: Prelude.last: empty list
    CallStack (from HasCallStack):
      error, called at libraries/base/GHC/List.hs:1644:3 in base:GHC.List
      errorEmptyList, called at libraries/base/GHC/List.hs:158:13 in base:GHC.List
      lastError, called at libraries/base/GHC/List.hs:153:29 in base:GHC.List
      last, called at compiler/src/Reporting/Render/Code.hs:102:26 in main:Reporting.Render.Code

The `elm.json` file in this repository contains an errant `source-directories`
entry, `codegen/Gen`:

    "source-directories": [
        "src",
        "codegen/Gen"
    ],

The source directories _should_ be:

    "source-directories": [
        "src",
        "codegen"
    ],

The extra path segment eats up the `Gen` prefix for `codegen/Gen/Platform.elm`.
Though the file declares itself as `module Gen.Platform`, its path seems to
indicate it should be the root `Platform` module (due to the bad
`source-directories` entry).

When the `source-directories` entry is fixed, everything is fine.
