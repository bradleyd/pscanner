defmodule Pscanner do
  use Application
  require Logger

  def main(args) do
    options = parse_args(args) 
    do_work(options[:a], options[:s], options[:e])
  end

  defp parse_args(args) do
    { options, _, _} = OptionParser.parse(args, switches: [a: :string, s: :integer, e: :integer])
    options
  end

  defp do_work(host, s, e) do
      Enum.each(s..e, fn i -> 
        Logger.info "#{host}:#{i} " <> inspect(scan(host, i))
      end)
  end

  defp scan(address, port) do
    case :gen_tcp.connect(String.to_char_list(address), port, []) do
      {:error, _} -> 
        "Closed"
      {:ok, connection} ->
        :gen_tcp.close(connection)
        "Open"
    end
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
