defmodule IBU.MixProject do
  use Mix.Project

  def project() do
    [
      app: :ibu,
      version: String.trim(File.read!("./VERSION")),
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  def description() do
    "A small wrapper around the IBU API"
  end

  defp deps() do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:hackney, "~> 1.23"},
      {:jason, ">= 1.0.0"},
      {:tesla, "~> 1.3"}
    ]
  end

  def package() do
    [
      name: "IBU",
      files: ~w(lib .formatter.exs mix.exs LICENSE README*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/ericgoodwin/ibu"}
    ]
  end
end
