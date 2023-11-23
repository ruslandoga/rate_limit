import Config

config :hammer,
  backend:
    {Hammer.Backend.ETS, expiry_ms: :timer.seconds(60), cleanup_interval_ms: :timer.minutes(10)}
