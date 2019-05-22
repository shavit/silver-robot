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

    alias Mario.Grid.Position

    test "link/3 create a bi-directional link between nodes" do
      assert grid_ = %Grid{} = Grid.generate(12, 11)
      n1 = Map.get(grid_.nodes, {9,10})
      assert not is_nil n1
      n2 = Map.get(grid_.nodes, {7,4})
      assert not is_nil n2

      node_count = Enum.count(grid_.nodes)

      grid = Grid.link grid_, n1, n2
      assert Enum.count(grid.nodes) == node_count

      node_position_1 = Map.get(grid.nodes, Position.key(n1))
      |> Map.get(:neighbours)
      |> List.first
      assert n2.position.x == node_position_1.x
      assert n2.position.y == node_position_1.y

      node_position_2 = Map.get(grid.nodes, Position.key(n2))
      |> Map.get(:neighbours)
      |> List.first
      assert n1.position.x == node_position_2.x
      assert n1.position.y == node_position_2.y
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

      assert 0 == Map.get(grid.nodes, Position.key(n1))
      |> Map.get(:neighbours)
      |> Enum.count
      assert 0 == Map.get(grid.nodes, Position.key(n2))
      |> Map.get(:neighbours)
      |> Enum.count
    end

    test "create_links/1 creates 4 or less links" do
      w = 7
      h = 11
      grid_ = grid_fixture(w, h)
      assert grid_.width == w
      assert grid_.height == h
      Enum.each(grid_.nodes, fn {_k, node} ->
        p = node.position
        cond do
          is_nil node.north -> assert p.x == 0
          is_nil node.east -> assert p.y == w-1
          is_nil node.south -> assert p.x == h-1
          is_nil node.west -> assert p.y == 0
          true -> true
        end
      end)
    end
  end
end
