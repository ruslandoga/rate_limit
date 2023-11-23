defmodule RateLimit.MixProject do
  use Mix.Project

  def project do
    [
      app: :rate_limit,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.2", only: :bench},
      {:ex_rated, "~> 2.1", only: :bench},
      {:plug_attack, "~> 0.4.3", only: :bench},
      {:hammer, "~> 6.1", only: :bench}
    ]
  end
end
