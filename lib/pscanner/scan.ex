defmodule Pscanner.Scan do
 
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, %{open: [], closed: 0}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state } 
  end

  def results do
    GenServer.call(__MODULE__, :get)
  end

  def scan(address, port) do
    case :gen_tcp.connect(String.to_char_list(address), port, []) do
      {:error, _} -> 
        closed(1)
      {:ok, connection} ->
        :gen_tcp.close(connection)
        open(port)
    end

  end

  defp closed(item) do
    send(Pscanner.Coordinator, {:finished, 1})
    GenServer.cast(__MODULE__, {:closed, item})
  end

  defp open(item) do
    send(Pscanner.Coordinator, {:finished, 1})
    GenServer.cast(__MODULE__, {:open, item})
  end

  def handle_cast({:open, item}, state)  do
    {:noreply, %{state | open: [item|state.open]}}
  end

  def handle_cast({:closed, item}, state)  do
    {:noreply, %{open: state.open, closed: state.closed + 1 }}
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok,state}, 0}
  end
end
