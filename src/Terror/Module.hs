module Terror.Module where

data Artifact = StaticLib {
                  artName :: String
                , arFlags :: [String]
                }
              | DynLib {
                  artName :: String
                , ldFlags :: [String]
                }
              | Exe {
                  artName :: String
                , ldFlags :: [String]
                }
              | Test {
                  artName   :: String
                , ldFlags   :: [String]
                , testFlags :: [String]
                }
    deriving (Eq, Show)

data Module = Module {
    modRelPath :: FilePath
  , modCFlags :: [String]
  , modArtifacts :: [Artifact]
  } deriving (Eq, Show)
