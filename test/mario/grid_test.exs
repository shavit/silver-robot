defmodule Mario.GridTest do
  use Mario.DataCase

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
  end
end
