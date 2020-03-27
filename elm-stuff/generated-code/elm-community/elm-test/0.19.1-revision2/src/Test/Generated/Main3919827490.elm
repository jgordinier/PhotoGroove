module Test.Generated.Main3919827490 exposing (main)

import PhotoGrooveTests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "PhotoGrooveTests" [PhotoGrooveTests.clickThumbnail,
    PhotoGrooveTests.decoderTest,
    PhotoGrooveTests.noPhotosNoThumbnails,
    PhotoGrooveTests.sliders,
    PhotoGrooveTests.thumbnailsWork] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 320324552000874, processes = 2, paths = ["/home/couragemouse/PhotoGroove/tests/PhotoGrooveTests.elm"]}