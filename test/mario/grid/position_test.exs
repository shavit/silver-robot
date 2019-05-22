defmodule Mario.Grid.PositionTest do
  use Mario.DataCase

  describe "position" do
    alias Mario.Grid.Position

    test "eq/2 compares 2 positions" do
      position_ = %Position{x: 11, y: 42}

      assert !Position.eq position_, %Position{x: 11, y: 21}
      assert !Position.eq position_, %Position{x: 21, y: 11}
      assert !Position.eq position_, %Position{x: 1, y: 42}
      assert !Position.eq position_, %Position{x: -1, y: 42}
      assert Position.eq position_, %Position{x: 11, y: 42}
    end

    test "key/1 returns a tuple with the x and y points" do
      position_ = %Position{x: 3, y: 17}

      assert {3, 17} == Position.key position_
      assert {nil, nil} == Position.key %Position{}
    end

    alias Mario.Grid.Node

    test "key/1 returns a tuple for a given node" do
      assert %Node{} = node_ = Node.init 3, 17
      assert {3, 17} == Position.key node_
    end
  end
end
