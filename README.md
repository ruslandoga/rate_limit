```console
$ MIX_ENV=bench mix run bench/basic.exs
Operating System: macOS
CPU Information: Apple M1
Number of Available Cores: 8
Available memory: 8 GB
Elixir 1.15.7
Erlang 26.1.2

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 42 s

Benchmarking atomics3 ...
Benchmarking counters ...
Benchmarking ex_rated ...
Benchmarking hammer ...
Benchmarking plug_attack ...
Benchmarking rate_limiter ...

Name                   ips        average  deviation         median         99th %
counters            5.43 M      184.07 ns ±12317.35%         166 ns         209 ns
plug_attack         4.38 M      228.13 ns ±12900.64%         167 ns         291 ns
rate_limiter        2.82 M      354.51 ns  ±7214.97%         292 ns         417 ns
atomics3            2.30 M      435.55 ns  ±8930.00%         292 ns         458 ns
ex_rated            1.46 M      686.39 ns  ±2935.71%         666 ns         792 ns
hammer              0.38 M     2623.56 ns   ±408.33%        2542 ns        3000 ns

Comparison: 
counters            5.43 M
plug_attack         4.38 M - 1.24x slower +44.06 ns
rate_limiter        2.82 M - 1.93x slower +170.43 ns
atomics3            2.30 M - 2.37x slower +251.47 ns
ex_rated            1.46 M - 3.73x slower +502.32 ns
hammer              0.38 M - 14.25x slower +2439.49 ns
```

```console
$ MIX_ENV=bench PARALLEL=500 mix run bench/basic.exs
Operating System: macOS
CPU Information: Apple M1
Number of Available Cores: 8
Available memory: 8 GB
Elixir 1.15.7
Erlang 26.1.2

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
reduction time: 0 ns
parallel: 500
inputs: none specified
Estimated total run time: 42 s

Benchmarking atomics3 ...
Benchmarking counters ...
Benchmarking ex_rated ...
Benchmarking hammer ...
Benchmarking plug_attack ...
Benchmarking rate_limiter ...

Name                   ips        average  deviation         median         99th %
counters           34.80 K       28.74 μs  ±1239.47%        0.25 μs      511.66 μs
atomics3           18.43 K       54.26 μs  ±1046.75%        0.42 μs     2719.45 μs
rate_limiter       17.71 K       56.45 μs  ±1193.55%        0.83 μs       19.96 μs
plug_attack        16.10 K       62.11 μs  ±1028.56%        0.25 μs      773.49 μs
ex_rated           12.30 K       81.30 μs   ±980.93%        0.88 μs     4228.96 μs
hammer              0.72 K     1395.05 μs    ±28.54%     1295.08 μs     2074.96 μs

Comparison: 
counters           34.80 K
atomics3           18.43 K - 1.89x slower +25.52 μs
rate_limiter       17.71 K - 1.96x slower +27.71 μs
plug_attack        16.10 K - 2.16x slower +33.37 μs
ex_rated           12.30 K - 2.83x slower +52.56 μs
hammer              0.72 K - 48.55x slower +1366.32 μs
```