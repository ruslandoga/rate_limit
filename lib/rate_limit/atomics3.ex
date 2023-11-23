defmodule RateLimit.Atomics3 do
  # TODO gc (generational vs timer)
  # TODO u64 overflow

  def new(name, partitions) do
    for i <- 0..(partitions - 1) do
      table = :"#{name}_#{i}"

      ^table =
        :ets.new(table, [
          :named_table,
          :set,
          :public,
          {:read_concurrency, true},
          {:write_concurrency, :auto}
        ])
    end

    :ok
  end

  def hit(name, key, partitions, scale, limit, now \\ System.os_time(:millisecond)) do
    partition = :erlang.phash2(key, partitions)
    table = :"#{name}_#{partition}"

    # TODO vs lookup_element
    case :ets.lookup(table, key) do
      [{_, atomic}] ->
        hits = :atomics.get(atomic, 1)
        last_hit_at = :atomics.exchange(atomic, 2, now)
        hits_last_bucket = :atomics.get(atomic, 3)
        last_hit_bucket = div(last_hit_at, scale)
        now_bucket = div(now, scale)

        if last_hit_bucket == now_bucket do
          left = limit - (hits - hits_last_bucket)

          if left > 0 do
            {:allow, max(limit - (:atomics.add_get(atomic, 1, 1) - hits_last_bucket), 0)}
          else
            {:block, _reset_in = now_bucket * scale + scale - now}
          end
        else
          # TODO compare exchange
          :atomics.exchange(atomic, 3, hits)
          {:allow, limit}
        end

      [] ->
        :ets.insert(table, {key, :atomics.new(3, signed: false)})
        hit(name, key, partitions, scale, limit)
    end
  end
end
