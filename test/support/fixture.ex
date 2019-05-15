defmodule Mario.Fixture do
  alias Mario.Grid

  def grid_fixture(w \\ 12, h \\ 14) do
    Grid.generate w, h
  end
end
