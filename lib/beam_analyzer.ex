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
  def attributes([item | rest]) do
    case item do
      {:attribute, _, type, metadata} ->
        Dict.put(attributes(rest), type, metadata)
      _ ->
        attributes(rest)
    end
  end

  def attributes([]) do
    %{}
  end

  def attributes(module) when is_binary(module) do
    {:ok, attributes(code(module))}
  end

  """
  {:function, ??, name, ??, metadata}
  """
  def functions([item | rest]) do
    case item do
      {:function, _, name, _, metadata} ->
        Dict.put(functions(rest), name, metadata)
      _ ->
        functions(rest)
    end
  end

  def functions([]) do
    %{}
  end

  def functions(module) when is_binary(module) do
    {:ok, functions(code(module))}
  end

  def exports(module) when is_binary(module) do
    {:ok, attribs} = attributes(module)
    {:ok, Dict.keys(attribs.export)}
  end

  def function_names(module) when is_binary(module) do
    {:ok, Dict.keys(functions(code(module)))}
  end

  def private_function_names(module) when is_binary(module) do
    {:ok, exports} = exports(module)
    {:ok, function_names} = function_names(module)
    {:ok, function_names -- exports}
  end
end
