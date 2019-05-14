defmodule Mario.Grid do
  alias Mario.Grid.Node

  defstruct [
    width:        0,
    height:       0,
    nodes:        [],
  ]

  @type t :: %__MODULE__{
    width:        integer(),
    height:       integer(),
    nodes:        list()
  }

  def init(w, h) do
    generate(w, h)
  end

  def generate(width, height) do
    nodes
      = 1..(width * height)
    |> Enum.to_list
    |> Enum.reduce(%{x: 0, y: 0, nodes: []}, fn _a, acc ->
      if acc.y < width do
        node = Node.init(acc.x, acc.y)
        acc
        |> Map.update!(:nodes, &(List.insert_at(&1, 0, node)))
        |> Map.update!(:y, &(&1 + 1))
      else
        node = Node.init(acc.x, acc.y)
        acc
        |> Map.update!(:nodes, &(List.insert_at(&1, 0, node)))
        |> Map.update!(:x, &(&1 + 1))
        |> Map.update!(:y, fn _x -> 0 end)
      end
    end)
    |> Map.get(:nodes)

    %__MODULE__{
      width: width,
      height: height,
      nodes: nodes
    }
  end
end
