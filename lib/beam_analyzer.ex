defmodule BeamAnalyzer do
  @moduledoc """
  The BEAM analyzer.

  Get a parsed tree of information about a BEAM file.
  """

  defp code(binary) when is_binary(binary) do
    {:ok,
      {_,
        [abstract_code:
          {:raw_abstract_v1, code}]}} = :beam_lib.chunks(binary, [:abstract_code])
    {:ok, code}
  end

  defp code(module) do
    case :code.get_object_code(module) do
      {_module, binary, _filename} ->
        code(binary)
      {:error, reason} ->
        {:error, reason}
    end
  end

  """
  http://www.erlang.org/doc/apps/erts/absform.html
  function := {:function, line, name, arity, metadata}
  metadata := [clause_1, clause_2, ...]
  clause   := {:clause, line, params, guards, expressions}
  """
  defp do_function(module, name, arity) do
    case code(module) do
      {:ok, code} ->
        function = Enum.find(
          code,
          fn
            {:function, _, n, a, _metadata} ->
              name == n and arity == a
            _ ->
              false
          end
        )
        case function do
          nil ->
            {:error, :not_found}
          _ ->
            {:ok, function}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def function(module, name, arity) do
    case do_function(module, name, arity) do
      {:ok, {:function, _, _name, _, metadata}} ->
        {:ok, metadata}
      {:error, reason} ->
        {:error, reason}
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
