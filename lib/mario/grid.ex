defmodule Mario.Grid do
  alias Mario.Grid.Node
  alias Mario.Grid.Edges
  alias Mario.Grid.Position

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
    |> Edges.create
  end

  @doc """
  Generates width * height grid filled with nodes
  """
  def generate(width, height) do
    nodes
      = 1..(width * height)
    |> Enum.to_list
    |> Enum.reduce(%{x: 0, y: 0, nodes: %{}}, fn _a, acc ->
      node = Node.init(acc.x, acc.y)
      # Work as 2 dimension array
      # Go to x+1 every y-1 steps
      if acc.y < width-1 do
        acc
        |> Map.update!(:nodes, &(Map.put(&1, Position.key(node), node)))
        |> Map.update!(:y, &(&1 + 1))
      else
        acc
        |> Map.update!(:nodes, &(Map.put(&1, Position.key(node), node)))
        |> Map.update!(:x, &(&1 + 1))
        |> Map.update!(:y, fn _x -> 0 end)
      end

    end)
    |> Map.get(:nodes)
    |> create_links

    %__MODULE__{
      width: width,
      height: height,
      nodes: nodes
    }
  end

  def size(grid), do: grid.x * grid.y

  def random_node(grid), do: grid |> Map.get(:nodes) |> Enum.random

  @doc """
  Creates a bi-directional link between two nodes
  """
  def link(grid, %Node{} = left, %Node{} = right) do
    grid
    |> Map.update!(:nodes, fn x ->
      x
      |> Map.update!(Position.key(left), &(Node.link(&1, right)))
      |> Map.update!(Position.key(right), &(Node.link(&1, left)))
    end)
  end

  @doc """
  Removes a bi-directional link between two nodes
  """
  def unlink(grid, %Node{} = left, %Node{} = right) do
    grid
    |> Map.update!(:nodes, fn x ->
      x
      |> Map.update!(Position.key(left), &(Node.unlink(&1, right)))
      |> Map.update!(Position.key(right), &(Node.unlink(&1, left)))
    end)
  end

  @doc """
  Create directional links between nodes
  """
  def create_links(nodes) when is_map(nodes) do
    Enum.reduce(nodes, %{}, fn {{x,y}, a}, acc ->
      node = a
      |> Map.put(:north, Map.get(nodes, {x-1, y}))
      |> Map.put(:east, Map.get(nodes, {x, y+1}))
      |> Map.put(:south, Map.get(nodes, {x+1, y}))
      |> Map.put(:west, Map.get(nodes, {x, y-1}))

      Map.put(acc, {x, y}, node)
    end)
  end

end
