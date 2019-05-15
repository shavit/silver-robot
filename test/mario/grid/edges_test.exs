defmodule Mario.Grid.EdgesTest do
  use Mario.DataCase
  import Mario.Fixture

  describe "edges" do
    alias Mario.Grid
    alias Mario.Grid.Edges

    test "create/1 creates random edges between nodes" do
      grid_ = grid_fixture()
      assert grid = %Grid{} = Edges.create grid_

      nodes = grid.nodes |> Enum.sort
      Enum.each nodes, fn {_k, %{neighbours: neighbours}} ->
        assert 2 > Enum.count neighbours
      end
    end
  end
end
