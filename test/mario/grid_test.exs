defmodule Mario.GridTest do
  use Mario.DataCase
  import Mario.Fixture

  describe "grid" do
    alias Mario.Grid

    test "generate/2 creates a grid with w * h nodes" do
      w = 123
      h = 45
      assert grid_ = %Grid{} = Grid.generate(w, h)
      assert grid_.width == w
      assert grid_.height == h
      assert (w * h) == Enum.count(grid_.nodes)
    end

    test "link/3 create a bi-directional link between nodes" do
      assert grid_ = %Grid{} = Grid.generate(12, 11)
      n1 = Map.get(grid_.nodes, {9,10})
      assert not is_nil n1
      n2 = Map.get(grid_.nodes, {7,4})
      assert not is_nil n2

      node_count = Enum.count(grid_.nodes)

      grid = Grid.link grid_, n1, n2
      assert Enum.count(grid.nodes) == node_count

      node2 = Map.get(grid.nodes, {n1.x, n1.y})
      |> Map.get(:neighbours)
      |> List.first
      assert n2.x == node2.x
      assert n2.y == node2.y

      node1 = Map.get(grid.nodes, {n2.x, n2.y})
      |> Map.get(:neighbours)
      |> List.first
      assert n1.x == node1.x
      assert n1.y == node1.y
    end

    test "unlink/3" do
      assert grid_ = %Grid{} = Grid.generate(41, 44)
      n1 = Map.get(grid_.nodes, {2, 10})
      assert not is_nil n1
      n2 = Map.get(grid_.nodes, {4,12})
      assert not is_nil n2

      node_count = Enum.count(grid_.nodes)
      grid = grid_
      |> Grid.link(n1, n2)
      |> Grid.link(n1, n2)
      |> Grid.unlink(n1, n2)
      assert Enum.count(grid.nodes) == node_count

      assert 0 == Map.get(grid.nodes, {n1.x, n1.y})
      |> Map.get(:neighbours)
      |> Enum.count
      assert 0 == Map.get(grid.nodes, {n2.x, n2.y})
      |> Map.get(:neighbours)
      |> Enum.count
    end

    test "create_links/1 creates 4 or less links" do
      w = 7
      h = 11
      grid_ = grid_fixture(w, h)
      assert grid_.width == w
      assert grid_.height == h
      Enum.each(grid_.nodes, fn {_k, x} ->
        cond do
          is_nil x.north -> assert x.x == 0
          is_nil x.east -> assert x.y == w-1
          is_nil x.south -> assert x.x == h-1
          is_nil x.west -> assert x.y == 0
          true -> true
        end
      end)
    end
  end
end
