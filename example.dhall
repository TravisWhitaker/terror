let Artifact
    : Type
    = < StaticLib :
          { artName : Text, arFlags : List Text }
      | DynLib :
          { artName : Text, ldFlags : List Text }
      | Exe :
          { artName : Text, ldFlags : List Text }
      | Test :
          { artName : Text, ldFlags : List Text, testFlags : List Text }
      >

let Module
    : Type
    = { modRelPath : Text, modCFlags : List Text, modArtifacts : List Artifact }

let noFlags = [] : List Text

let commonLdFlags = [ "-lm", "-pthread" ]

in  [ { modRelPath =
          "core"
      , modCFlags =
          [ "-Wall", "-Werror" ]
      , modArtifacts =
          [ Artifact.StaticLib { artName = "libExample.a", arFlags = noFlags }
          , Artifact.DynLib
            { artName = "libExample.so", ldFlags = commonLdFlags }
          , Artifact.Exe { artName = "example", ldFlags = commonLdFlags }
          , Artifact.Test
            { artName =
                "exampleTest"
            , ldFlags =
                commonLdFlags # [ "-lboost_test" ]
            , testFlags =
                [ "run-this-test" ]
            }
          ]
      }
    ]
