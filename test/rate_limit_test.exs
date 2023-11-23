defmodule RateLimitTest do
  use ExUnit.Case
  doctest RateLimit

  test "greets the world" do
    assert RateLimit.hello() == :world
  end
end
