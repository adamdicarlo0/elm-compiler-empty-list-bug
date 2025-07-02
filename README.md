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
entry:

    "codegen/Gen"

which should be

    "codegen"

The extra path segment eats up the `Gen` prefix for `codegen/Gen/Platform.elm`.
Though the file declares itself as `module Gen.Platform`, its path seems to
indicate it should be the root `Platform` module.

When the `elm.json` entry is fixed, everything is fine.

## Comparison with Lamdera

Try `npm run lamdera` to attempt compiling with Lamdera (run `npm install`
first, if you don't have Lamdera handy):

    $ npm run lamdera

    > lamdera
    > lamdera make src/Main.elm

    Detected problems in 1 module.
    -- AMBIGUOUS IMPORT ----------------------------------------------- src/Main.elm

    You are trying to import a `Platform` module:

      ^
    But I found multiple modules with that name. One in the elm/core package, and
    another defined locally in the
    /home/adam/work/elm-compiler-repro/codegen/Gen/Platform.elm file. I do not have
    a way to choose between them.

    Try changing the name of the locally defined module to clear up the ambiguity?

Interestingly, the `^` pointing at the import points at nothing (there is no
`import Platform` in the program; it's only an implied import).
