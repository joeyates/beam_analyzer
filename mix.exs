defmodule BeamAnalyzer.Mixfile do
  use Mix.Project

  @version "0.0.3"

  def project do
    [
      app: :beam_analyzer,
      name: "BeamAnalyzer",
      version: @version,
      description: "Get information about Erlang/Elixir modules and BEAM files",
      elixir: "~> 1.0",
      package: package,
      deps: deps,
      contributors: ["Joe Yates"]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joeyates/beam_analyzer"},
    }
  end

  defp deps do
    []
  end
end
