module Test.Generated.Main2183215905 exposing (main)

import PhotoGrooveTests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "PhotoGrooveTests" [PhotoGrooveTests.decoderTest,
    PhotoGrooveTests.noPhotosNoThumbnails,
    PhotoGrooveTests.sliders] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 21021128641863, processes = 2, paths = ["/home/couragemouse/PhotoGroove/tests/PhotoGrooveTests.elm"]}