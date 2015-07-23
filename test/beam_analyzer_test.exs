defmodule BeamAnalyzerTest do
  use ExUnit.Case
  alias BeamAnalyzer

  setup do
    source_fixture_path = "test/fixtures/foo.ex"
    [{module, binary}] = :elixir_compiler.file_to_path(source_fixture_path, ".")

    on_exit fn ->
      File.rm("Elixir.Foo.beam")
      # Remove module to avoid "redefining module Foo" warning
      :code.purge(Foo)
      :code.delete(Foo)
      Code.unload_files([source_fixture_path])
    end

    {:ok, [module: module, binary: binary]}
  end

  test ".exports lists exports", context do
    exports = BeamAnalyzer.exports(context[:module])
    assert exports == [__info__: 1, a_method: 0, module_info: 0, module_info: 1]
  end

  test ".functions lists all functions", context do
    function_names = BeamAnalyzer.functions(context[:module])
    assert Enum.sort(function_names) == [
      __info__: 1, a_method: 0, a_private_method: 0, module_info: 0, module_info: 1
    ]
  end

  test ".private_functions lists private functions", context do
    private_function_names = BeamAnalyzer.private_functions(context[:module])
    assert private_function_names == [a_private_method: 0]
  end

  test ".function returns the clauses of a function", context do
    {:ok, clauses} = BeamAnalyzer.function(context[:module], :a_private_method)
    assert length(clauses) == 1
    {:ok, clause} = Enum.fetch(clauses, 0)
    {type, _, params, guards, _forms} = clause
    assert type == :clause
    assert params == []
    assert guards == []
  end
end
