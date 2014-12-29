PortScanner
===========

A simple port scanner in Elixir

## Usage 

```elixir
pscanner --a=127.0.0.1 --s=6379 --e=6380
```

```bash
Port Scanner Results
====================

Open  : [6379]
Closed: 1


real0m0.313s
user0m0.255s
sys0m0.103s     
```

```elixir
pscanner --a=127.0.0.1 --s=1025 --e=10000
```


```bash
Port Scanner Results
====================

Open  : [5432, 5939, 3306, 5038, 6379, 4369, 2000]
Closed: 8969


real0m2.845s
user0m3   .454s
sys0m0.579s 
```

