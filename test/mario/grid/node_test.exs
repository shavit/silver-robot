defmodule Mario.Grid.NodeTest do
  use Mario.DataCase

  describe "grid" do
    alias Mario.Grid.Node

    test "init/2 creates a node with a position" do
      assert %Node{} = node = Node.init 4, 7
      assert node.position.x == 4
      assert node.position.y == 7
    end

    test "link/2 creates a directional link between 2 nodes" do
      node_ = Node.init(1, 2)
      node_2 = Node.init(2, 3)

      assert node = %Node{} = Node.link node_, node_2
      assert node = %Node{} = Node.link node, node_2
      assert node = %Node{} = Node.link node, node_2

      assert 0 == Enum.count Map.get(node_, :neighbours, [])
      assert 0 == Enum.count Map.get(node_2, :neighbours, [])
      assert 1 == Enum.count Map.get(node, :neighbours, [])

      assert position = Map.get(node, :neighbours, []) |> List.first
      assert node_2.position.x == position.x
      assert node_2.position.y == position.y

      assert 4 == node
      |> Node.link(Node.init(2, 4))
      |> Node.link(Node.init(3, 3))
      |> Node.link(Node.init(4, 5))
      |> Node.link(Node.init(4, 5))
      |> Node.link(Node.init(4, 5))
      |> Map.get(:neighbours)
      |> Enum.count
    end

    test "unlink/2 remove a directional link from a node" do
      node_ = Node.init(1, 2)
      node_2 = Node.init(3, 4)
      assert node = %Node{} = Node.link node_, node_2
      assert 1 == Enum.count Map.get(node, :neighbours, [])

      assert node = %Node{} = Node.unlink node, node_
      assert 1 == Enum.count Map.get(node, :neighbours, [])
      assert node = %Node{} = Node.unlink node, node_2
      assert 0 == Enum.count Map.get(node, :neighbours, [])
    end

    test "any?/2 find a neighbour in a node" do
      node_ = Node.init(1, 2)
      |> Node.link(Node.init(2, 4))
      |> Node.link(Node.init(3, 3))
      |> Node.link(Node.init(4, 5))
      |> Node.link(Node.init(4, 7))
      |> Node.link(Node.init(1, 7))

      assert 5 == Enum.count Map.get(node_, :neighbours, [])
      assert true == Node.any? node_, Node.init(4, 5)
    end
  end
end
