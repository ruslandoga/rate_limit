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
Estimated total run time: 35 s

Benchmarking atomics3 ...
Benchmarking ex_rated ...
Benchmarking hammer ...
Benchmarking plug_attack ...
Benchmarking rate_limiter ...

Name                   ips        average  deviation         median         99th %
plug_attack         4.41 M      226.77 ns ±12315.52%         167 ns         291 ns
rate_limiter        2.83 M      352.86 ns  ±6562.01%         292 ns         417 ns
atomics3            2.30 M      434.34 ns  ±8506.76%         292 ns         459 ns
ex_rated            1.51 M      660.85 ns  ±2133.58%         625 ns         792 ns
hammer              0.38 M     2662.89 ns   ±437.93%        2583 ns        3042 ns

Comparison: 
plug_attack         4.41 M
rate_limiter        2.83 M - 1.56x slower +126.09 ns
atomics3            2.30 M - 1.92x slower +207.57 ns
ex_rated            1.51 M - 2.91x slower +434.08 ns
hammer              0.38 M - 11.74x slower +2436.12 ns
```