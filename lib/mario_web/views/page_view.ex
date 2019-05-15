defmodule MarioWeb.PageView do
  use MarioWeb, :view

  @tile_size_sq 48

  def draw({:grid, grid}) do
    Enum.map(grid.nodes, &(line(&1)))
  end

  alias Mario.Grid.Node

  defp line(%Node{} = node) do
    # node
    # |> node_coordinates
    # |> line_element
    l1 = if is_nil(node.north), do: node_coordinates_north(node)
    l2 = if is_nil(node.west), do: node_coordinates_west(node)
    l3 = if not Node.any?(node, node.east), do: node_coordinates_east(node)
    l4 = if not Node.any?(node, node.south), do: node_coordinates_south(node)

    [l1,l2,l3,l4]
    |> Enum.filter(&(not is_nil &1))
    |> Enum.map(&(line_element(&1)))
  end

  defp line({_k, %Node{} = node}), do: line(node)

  # defp node_coordinates(%Node{} = node) do
  #   cond do
  #     is_nil(node.north) -> node_coordinates_north(node)
  #     is_nil(node.west) -> node_coordinates_west(node)
  #     not Node.any?(node, node.east) -> node_coordinates_east(node)
  #     not Node.any?(node, node.south) -> node_coordinates_south(node)
  #   end
  # end

  defp node_coordinates_north(%Node{x: x, y: y}) do
    {
      coordinates({x, :x}),
      coordinates({y, :y}),
      coordinates({x, :x}) + @tile_size_sq,
      coordinates({y, :y})
    }
  end

  defp node_coordinates_west(%Node{x: x, y: y}) do
    {
      coordinates({x, :x}),
      coordinates({y, :y}),
      coordinates({x, :x}),
      coordinates({y, :y}) + @tile_size_sq
    }
  end

  defp node_coordinates_east(%Node{x: x, y: y}) do
    {
      coordinates({x, :x}) + @tile_size_sq,
      coordinates({y, :y}),
      coordinates({x, :x}) + @tile_size_sq,
      coordinates({y, :y}) + @tile_size_sq
    }
  end

  defp node_coordinates_south(%Node{x: x, y: y}) do
    {
      coordinates({x, :x}),
      coordinates({y, :y}) + @tile_size_sq,
      coordinates({x, :x}) + @tile_size_sq,
      coordinates({y, :y}) + @tile_size_sq
    }
  end

  defp coordinates({p, :x}), do: (1 + p) * @tile_size_sq
  defp coordinates({p, :y}), do: (1 + p) * @tile_size_sq

  defp line_element(nil), do: ""
  defp line_element({x1, y1, x2, y2}) do
    """
    <line x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}" stroke="rgba(75,89,153,0.9)" />
    """
  end
end
