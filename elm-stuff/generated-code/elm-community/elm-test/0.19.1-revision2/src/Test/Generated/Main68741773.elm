module Test.Generated.Main68741773 exposing (main)

import PhotoGrooveTests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "PhotoGrooveTests" [PhotoGrooveTests.decoderTest] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Just 5000, report = (ConsoleReport UseColor), seed = 234250179844098, processes = 2, paths = ["/home/couragemouse/PhotoGroove/tests/PhotoGrooveTests.elm"]}