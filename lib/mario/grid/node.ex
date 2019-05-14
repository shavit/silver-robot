defmodule Mario.Grid.Node do

  defstruct [
    x: nil,
    y: nil,
    north: nil,
    east: nil,
    south: nil,
    west: nil,
    neighbours: [],
  ]

  @type t :: %__MODULE__{
    x:              integer() | nil,
    y:              integer() | nil,
    north:          t | nil,
    east:           t | nil,
    south:          t | nil,
    west:           t | nil,
    neighbours:     list()
  }

  def init(x, y), do: %__MODULE__{x: x, y: y}

  def link(from_node, to_node, bi = true) do
    Map.update!(from_node, :neighbours, fn x ->
      x
      |> List.insert_at(-1, to_node)
      |> Enum.uniq
    end)
  end

  def unlink(from_node, to_node, bi = true) do
    Map.update!(from_node, :neighbours, fn x ->
      x
      |> Enum.filter(&(&1 != to_node))
      |> Enum.uniq
    end)
  end

end
