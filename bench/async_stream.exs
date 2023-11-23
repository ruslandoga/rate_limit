partitions = System.schedulers()
scale = :timer.seconds(60)
limit = 1_000_000

RateLimit.Atomics3.new(:sites, partitions)
PlugAttack.Storage.Ets.start_link(:plug_attack_sites, clean_period: :timer.minutes(10))

defmodule Bench do
  def sampled(i, every, f) do
    if rem(i, every) == 0 do
      {t, r} = :timer.tc(f)
      IO.inspect(t, label: i)
      r
    else
      f.()
    end
  end

  def atomics3 do
    RateLimit.Atomics3.hit(
      :sites,
      _key = :rand.uniform(1000),
      unquote(partitions),
      unquote(scale),
      unquote(limit)
    )
  end

  def plug_attack do
    PlugAttack.Rule.throttle(_key = :rand.uniform(1000),
      storage: {PlugAttack.Storage.Ets, :plug_attack_sites},
      limit: unquote(limit),
      period: unquote(scale)
    )
  end

  def hammer do
    Hammer.check_rate("sites:#{:rand.uniform(1000)}", unquote(scale), unquote(limit))
  end

  def ex_rated do
    ExRated.check_rate("sites:#{:rand.uniform(1000)}", unquote(scale), unquote(limit))
  end

  def rate_limiter do
    key = "sites:#{:rand.uniform(1000)}"
    rate_limiter = RateLimiter.get(key) || RateLimiter.new(key, unquote(scale), unquote(limit))
    RateLimiter.hit(rate_limiter)
  end

  def gc do
    IO.puts("gc")
    Enum.each(Process.list(), &:erlang.garbage_collect/1)
  end

  def mem do
    IO.inspect(:erlang.memory(:total) / 1_000_000, label: "memory")
  end
end

Bench.mem()
Bench.gc()
Bench.mem()

f =
  case System.fetch_env!("WHICH") do
    "atomics3" -> &Bench.atomics3/0
    "plug_attack" -> &Bench.plug_attack/0
    "hammer" -> &Bench.hammer/0
    "ex_rated" -> &Bench.ex_rated/0
    "rate_limiter" -> &Bench.rate_limiter/0
  end

{t, _} =
  :timer.tc(fn ->
    1..1_000_000
    |> Task.async_stream(
      fn i -> Bench.sampled(i, 50000, f) end,
      max_concurrency: 1000,
      ordered: false
    )
    |> Stream.run()
  end)

IO.inspect(t, label: "tc")

Bench.mem()
Bench.gc()
Bench.mem()
