profile? = !!System.get_env("PROFILE")
parallel = String.to_integer(System.get_env("PARALLEL", "1"))
limit = String.to_integer(System.get_env("LIMIT", "1000000"))
scale = String.to_integer(System.get_env("SCALE", "60000"))

partitions = System.schedulers()
RateLimit.Atomics3.new(:sites, partitions)
RateLimit.Counters.new(:sites_c)

PlugAttack.Storage.Ets.start_link(:plug_attack_sites, clean_period: :timer.minutes(10))

Benchee.run(
  %{
    # "control" => fn -> :rand.uniform(1000) end,
    "plug_attack" => fn ->
      PlugAttack.Rule.throttle(_key = :rand.uniform(1000),
        storage: {PlugAttack.Storage.Ets, :plug_attack_sites},
        limit: limit,
        period: scale
      )
    end,
    "atomics3" => fn ->
      RateLimit.Atomics3.hit(:sites, _key = :rand.uniform(1000), partitions, scale, limit)
    end,
    "hammer" => fn ->
      Hammer.check_rate("sites:#{:rand.uniform(1000)}", scale, limit)
    end,
    "counters" => fn ->
      RateLimit.Counters.hit(:sites_c, _key = :rand.uniform(1000), partitions, scale, limit)
    end,
    "ex_rated" => fn ->
      ExRated.check_rate("sites:#{:rand.uniform(1000)}", scale, limit)
    end,
    "rate_limiter" => fn ->
      key = "sites:#{:rand.uniform(1000)}"
      rate_limiter = RateLimiter.get(key) || RateLimiter.new(key, scale, limit)
      RateLimiter.hit(rate_limiter)
    end
  },
  profile_after: profile?,
  parallel: parallel,
  print: [fast_warning: false]
)
