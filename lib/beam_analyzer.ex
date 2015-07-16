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
  {:attribute, ??, type, metadata}
  """
  defp attributes([item | rest], map) do
    case item do
      {:attribute, _, type, metadata} ->
         attributes(rest, Dict.put(map, type, metadata))
      _ ->
        attributes(rest, map)
    end
  end

  defp attributes([], map) do
    map
  end

  """
  {:function, ??, name, ??, metadata}
  """
  defp functions([item | rest]) do
    case item do
      {:function, _, name, _, _} ->
        [name | functions(rest)]
      _ ->
        functions(rest)
    end
  end

  defp functions([]) do
    []
  end

  def attributes(module) do
    {:ok, attributes(code(module), %{})}
  end

  def exports(module) do
    {:ok, attribs} = attributes(module)
    {:ok, Dict.keys(attribs.export)}
  end

  def function_names(module) do
    {:ok, functions(code(module))}
  end

  def private_function_names(module) do
    {:ok, exports} = exports(module)
    {:ok, function_names} = function_names(module)
    {:ok, function_names -- exports}
  end
end
