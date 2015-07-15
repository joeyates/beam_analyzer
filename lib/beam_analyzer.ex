defmodule BeamAnalyzer do
  @moduledoc """
  The BEAM analyzer.

  Get a parsed tree of information about a BEAM file.
  """

  def indent(level) do
    if level > 0 do
      IO.write "  "
      indent(level - 1)
    end
  end

  def inspect_indented(item, level) do
    #indent level
    item
    #IO.puts inspect(item)
  end

  def analyze_quoted(item, level) when is_atom(item) or is_integer(item) or is_binary(item) do
    inspect_indented item, level
  end

  def analyze_quoted({:attribute, p1, type, metadata}, level) do
    analyze_quoted :attribute, level
    inspect_indented p1, level + 1
    inspect_indented "type: #{type}", level + 1
    inspect_indented metadata, level + 1
  end

  def analyze_quoted({:atom, _, p2}, level) do
    analyze_quoted :atom, level
    #inspect_indented line, level + 1
    inspect_indented p2, level + 1
  end

  def analyze_quoted({:bin, p1, p2}, level) do
    analyze_quoted :bin, level
    analyze_quoted p1, level + 1
    analyze_quoted p2, level + 1
  end

  def analyze_quoted({:fun, p1, p2}, level) do
    analyze_quoted :fun, level
    inspect_indented p1, level + 1
    inspect_indented p2, level + 1
  end

  def analyze_quoted({:integer, p1, p2}, level) do
    analyze_quoted :integer, level
    inspect_indented p1, level + 1
    inspect_indented p2, level + 1
  end

  def analyze_quoted({:map, _, p2}, level) do
    analyze_quoted :map, level
    #analyze_quoted line, level + 1
    analyze_quoted p2, level + 1
  end

  def analyze_quoted({:string, p1, p2}, level) do
    analyze_quoted :string, level
    analyze_quoted p1, level + 1
    inspect_indented p2, level + 1
  end

  def analyze_quoted({:tuple, p1, p2}, level) do
    analyze_quoted :tuple, level
    analyze_quoted p1, level + 1
    analyze_quoted p2, level + 1
  end

  def analyze_quoted({:var, _, p2}, level) do
    analyze_quoted :var, level
    #analyze_quoted line, level + 1
    analyze_quoted p2, level + 1
  end

  def analyze_quoted({:call, _, p2, p3}, level) do
    analyze_quoted :call, level
    #analyze_quoted line, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
  end

  def analyze_quoted({:remote, _, p2, p3}, level) do
    analyze_quoted :remote, level
    #analyze_quoted line, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
  end

  def analyze_quoted({:case, p1, p2, p3}, level) do
    analyze_quoted :case, level
    inspect_indented p1, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
  end

  def analyze_quoted({:cons, p1, p2, p3}, level) do
    analyze_quoted :cons, level
    analyze_quoted p1, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
  end

  def analyze_quoted({nil, 0}, level) do
    analyze_quoted ":cons terminator", level
  end

  def analyze_quoted({:map_field_assoc, _, p2, p3}, level) do
    analyze_quoted :map_field_assoc, level
    #analyze_quoted line, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
  end

  def analyze_quoted({:map_field_exact, p1, p2, p3}, level) do
    analyze_quoted :map_field_exact, level
    analyze_quoted p1, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
  end

  def analyze_quoted({:match, p1, p2, p3}, level) do
    analyze_quoted :match, level
    analyze_quoted p1, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
  end

  def analyze_quoted({:bin_element, p1, p2, p3, p4}, level) do
    analyze_quoted :bin_element, level
    analyze_quoted p1, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
    analyze_quoted p4, level + 1
  end

  def analyze_quoted({:clause, p1, p2, p3, p4}, level) do
    analyze_quoted :clause, level
    inspect_indented p1, level + 1
    analyze_quoted p2, level + 1
    analyze_quoted p3, level + 1
    analyze_quoted p4, level + 1
  end

  def analyze_quoted({:function, _, name, _, metadata}, level) do
    analyze_quoted :function, level
    inspect_indented "name: #{name}", level + 1
    analyze_quoted(metadata, level + 1)
  end

  def analyze_quoted({head}, level) do
    inspect_indented "Unknown: :#{head} (no other items)", level
  end

  def analyze_quoted({head, _}, level) do
    inspect_indented "Unknown: :#{head} (1 other item)", level
  end

  def analyze_quoted({head, _, _}, level) do
    inspect_indented "Unknown: :#{head} (2 other items)", level
  end

  def analyze_quoted({head, _, _, _}, level) do
    inspect_indented "Unknown: :#{head} (3 other items)", level
  end

  def analyze_quoted({head, _, _, _, _}, level) do
    inspect_indented "Unknown: :#{head} (4 other items)", level
  end

  def analyze_quoted([item | rest], level) do
    [analyze_quoted(item, level) | analyze_quoted(rest, level)]
  end

  def analyze_quoted([], _) do
  end

  def code(module) do
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
