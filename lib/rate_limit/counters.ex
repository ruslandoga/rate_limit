defmodule RateLimit.Counters do
  def new(name, partitions) do
    for i <- 0..(partitions - 1) do
      table = :"#{name}_#{i}"

      ^table =
        :ets.new(table, [
          :named_table,
          :set,
          :public,
          {:read_concurrency, true},
          {:write_concurrency, true},
          {:decentralized_counters, true}
        ])
    end

    :ok
  end

  def new(name) do
    ^name =
      :ets.new(name, [
        :named_table,
        :set,
        :public,
        {:read_concurrency, true},
        {:write_concurrency, :auto}
      ])
  end

  # TODO vs System.os_time(:millisecond)
  def hit(table, key, _partitions, scale, limit, now \\ System.system_time(:millisecond)) do
    # partition = :erlang.phash2(key, partitions)
    # table = :"#{name}_#{partition}"
    now_bucket = div(now, scale)
    expires_at = (now_bucket + 1) * scale
    full_key = {key, now_bucket}
    count = :ets.update_counter(table, full_key, 1, {full_key, 0, expires_at})
    left = limit - count

    if left >= 0 do
      {:allow, left}
    else
      {:block, 0}
    end
  end
end
