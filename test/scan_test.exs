defmodule PscannerScanTest do
  use ExUnit.Case, async: true

  setup do
    coord = Task.async(Pscanner.Coordinator, :start, [1, 1])
    {:ok, scan} = Pscanner.Scan.start
    {:ok, scan: scan, coord: coord}
  end

  test "scan has no results", %{scan: _, coord: _}  do
    assert {:ok, %{closed: 0, open: []}} == Pscanner.Scan.results
  end

  test "scan host", %{scan: _, coord: coord} do
   Pscanner.Scan.scan("127.0.0.1", 6379)
   Task.await(coord, :infinity)
   refute {:ok, %{closed: 0, open: []}} == Pscanner.Scan.results
  end
end
