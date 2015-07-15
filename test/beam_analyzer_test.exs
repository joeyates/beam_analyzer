defmodule BeamAnalyzerTest do
  use ExUnit.Case
  alias BeamAnalyzer

  setup do
    [{_, binary}] = Code.load_file("test/fixtures/foo.ex")
    {:ok, [binary: binary]}
  end

  test ".attributes lists attributes", context do
    {:ok, attributes} = BeamAnalyzer.attributes(context[:binary])
    assert Enum.sort(Dict.keys(attributes)) == [:compile, :export, :file, :module, :spec]
  end

  test ".exports lists exports", context do
    {:ok, exports} = BeamAnalyzer.exports(context[:binary])
    assert exports == [:__info__, :amethod]
  end
end
