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

  def attributes([item | rest], map) do
    case item do
      {:attribute, p1, type, metadata} ->
         attributes(rest, Dict.put(map, type, metadata))
      _ ->
        attributes(rest, map)
    end
  end

  def attributes([], map) do
    map
  end

  def attributes(module) do
    {:ok, attributes(code(module), %{})}
  end

  def exports(module) do
    {:ok, attribs} = attributes(module)
    {:ok, Dict.keys(attribs.export)}
  end
end
