module Main exposing (main)

-- No `import Platform` is necessary to reproduce the bug (apparently because
-- Elm implicitly imports `Platform`).


main : String
main =
    "Hi"
