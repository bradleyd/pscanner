defmodule Pscanner.Coordinator do
  def start(s, e) do
    Process.register(self, Pscanner.Coordinator)
    count = Enum.count(s..e)
    coordinate(%{finished: 0, num_requests: count}) 
  end

  defp coordinate(%{finished: n, num_requests: n}) do
    {:ok, "finished"} 
  end

  defp coordinate(status = %{finished: f, num_requests: n}) do
    receive do
      {:finished, _i} ->
        coordinate(%{status | finished: f + 1})
    end
  end
end
