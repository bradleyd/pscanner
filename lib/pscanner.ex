defmodule Pscanner do
  use Application

  def main(args) do
    options = parse_args(args)
    coord = Task.async(Pscanner.Coordinator, :start, [options[:s], options[:e]])
    task = Task.async(Pscanner.Scan, :start, [])
    do_work(options[:a], options[:s], options[:e])
    Task.await(task, :infinity)
    Task.await(coord, :infinity)
    collect_results
  end

  defp collect_results do
    {:ok, results} = Pscanner.Scan.results
    IO.puts """
    #{IO.ANSI.yellow}Port Scanner Results#{IO.ANSI.reset}
    ====================

    Open  : #{IO.ANSI.green}#{inspect(results.open)}#{IO.ANSI.reset}
    Closed: #{IO.ANSI.red}#{results.closed}#{IO.ANSI.reset}
    """
  end

  defp parse_args(args) do
    { options, _, _} = OptionParser.parse(args, switches: [a: :string, s: :integer, e: :integer])
    case options do
      [a: address, s: s, e: e] when e > s -> [a: address, s: s, e: e]
      [a: address, s: s] -> [a: address, s: s, e: s]
      [a: address, s: s, e: e] when s > e -> help
      _ -> help
    end
  end

  defp do_work(host, s, e) do
    Enum.each(s..e, fn i -> 
      spawn(Pscanner.Scan, :scan, [host, i]) 
    end)
  end

  defp help do
    IO.puts """
    Usage:
    pscanner [--a=address] [--s=start port] [--e=end port]

    Options:
    --h, [--help]        # Show this help message and quit.
    --a, [--a=127.0.0.1] # Address to check.
    --s, [--s=1]         # First port in range to check.
    --e, [--e=32678]     # Last port in range to check.

    Description:
    Pscanner can scan a port range or a single port.
    * end port must be greater than start port.
    """
    System.halt(0)
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Pscanner.Worker, [arg1, arg2, arg3])
    ]

    opts = [strategy: :one_for_one, name: Pscanner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
