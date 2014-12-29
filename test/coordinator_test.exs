defmodule PscannerCoordinatorTest do
  use ExUnit.Case

  test "coordinator stops" do
    coord = Task.async(Pscanner.Coordinator, :start, [1, 2])
    :timer.sleep 100 #needed
    send(Pscanner.Coordinator, {:finished, 1})
    send(Pscanner.Coordinator, {:finished, 1})
    send(Pscanner.Coordinator, {:finished, 1})
    results = Task.await(coord, :infinity)
    assert {:ok, "finished"} == results
  end
end
 
