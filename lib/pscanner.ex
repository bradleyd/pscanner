defmodule Pscanner do
  use Application

  def main(args) do
    options = parse_args(args)
    coord = Task.async(Pscanner.Coordinator, :start, [options[:s], options[:e]])
    task = Task.async(Pscanner.Scan, :start, [0])
    do_work(options[:a], options[:s], options[:e])
    Task.await(task, :infinity)
    Task.await(coord, :infinity)
    collect_results
  end

  defp collect_results do
    {:ok, results} = Pscanner.Scan.results
    IO.puts """
    Port Scanner Results
    ====================

    Open: #{results.open}
    Closed: #{results.closed}
    """

  end

  defp parse_args(args) do
    { options, _, _} = OptionParser.parse(args, switches: [a: :string, s: :integer, e: :integer])
    case options do
      [a: address, s: s, e: e] -> [a: address, s: s, e: e]
      [a: address, s: s] -> [a: address, s: s, e: s]
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
    -h, [--help]      # Show this help message and quit.

    Description:
    """
    System.halt(0)
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Pscanner.Worker, [arg1, arg2, arg3])
    ]

  # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
  # for other strategies and supported options
  opts = [strategy: :one_for_one, name: Pscanner.Supervisor]
  Supervisor.start_link(children, opts)
  end
end
