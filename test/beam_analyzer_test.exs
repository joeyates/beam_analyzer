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
    assert exports == [:__info__, :a_method]
  end

  test ".function_names", context do
    {:ok, function_names} = BeamAnalyzer.function_names(context[:binary])
    assert Enum.sort(function_names) == [:__info__, :a_method, :a_private_method]
  end

  test ".private_function_names", context do
    {:ok, private_function_names} = BeamAnalyzer.private_function_names(context[:binary])
    assert private_function_names == [:a_private_method]
  end
end
