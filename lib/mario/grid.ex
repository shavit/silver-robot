defmodule Mario.Grid do
  alias Mario.Grid.Node

  defstruct [
    width:        0,
    height:       0,
    nodes:        %{},
  ]

  @type t :: %__MODULE__{
    width:        integer(),
    height:       integer(),
    nodes:        map()
  }

  def init(w, h) do
    generate(w, h)
  end

  @doc """
  Generates width * height grid filled with nodes
  """
  def generate(width, height) do
    nodes
      = 1..(width * height)
    |> Enum.to_list
    |> Enum.reduce(%{x: 0, y: 0, nodes: %{}}, fn _a, acc ->
      if acc.y < width do
        node = Node.init(acc.x, acc.y)
        acc
        |> Map.update!(:nodes, &(Map.put(&1, {node.x, node.y}, node)))
        |> Map.update!(:y, &(&1 + 1))
      else
        node = Node.init(acc.x, acc.y)
        acc
        |> Map.update!(:nodes, &(Map.put(&1, {node.x, node.y}, node)))
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

  @doc """
  Creates a bi-directional link between two nodes
  """
  def link(grid, n1, n2) do
    grid
    |> Map.update!(:nodes, fn x ->
      x
      |> Map.update!({n1.x, n1.y}, &(Node.link(&1, n2)))
      |> Map.update!({n2.x, n2.y}, &(Node.link(&1, n1)))
    end)
  end

  def unlink(grid, n1, n2) do
    grid
    |> Map.update!(:nodes, fn x ->
      x
      |> Map.update!({n1.x, n1.y}, &(Node.unlink(&1, n2)))
      |> Map.update!({n2.x, n2.y}, &(Node.unlink(&1, n1)))
    end)
  end
end
