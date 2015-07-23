defmodule BeamAnalyzer do
  @moduledoc """
  The BEAM analyzer.

  Get a parsed tree of information about a BEAM file.
  """

  defp code(module) do
    {:ok,
      {_,
        [abstract_code:
          {:raw_abstract_v1, code}]}} = :beam_lib.chunks(module, [:abstract_code])
    code
  end

  """
  http://www.erlang.org/doc/apps/erts/absform.html
  function := {:function, line, name, arity, metadata}
  metadata := [clause_1, clause_2, ...]
  clause   := {:clause, line, params, guards, expressions}
  """
  defp do_function(module, name) do
    abs = code(module)
    Enum.find(
      abs,
      fn
        {:function, _, n, _, metadata} ->
          name == n
        _ ->
          false
      end
    )
  end

  def function(module, name) do
    result = do_function(module, name)
    case result do
      {:function, _, name, _, metadata} ->
        {:ok, metadata}
      _ ->
        {:error, :not_found}
    end
  end

  def functions(module) do
    :erlang.get_module_info(module, :functions)
  end

  def exports(module) do
    :erlang.get_module_info(module, :exports)
  end

  def private_functions(module) do
    functions(module) -- exports(module)
  end
end
