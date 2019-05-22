defmodule MarioWeb.PageView do
  use MarioWeb, :view

  @tile_size_sq 8
  @stroke_color "rgba(24,54,192,0.9)"

  def draw({:grid, grid}) do
    Enum.map(grid.nodes, &(line(&1)))
  end

  alias Mario.Grid.Node

  defp line(%Node{} = node) do
    l1 = if is_nil(node.north), do: node_coordinates_north(node)
    l2 = if is_nil(node.west), do: node_coordinates_west(node)
    l3 = if not Node.any?(node, node.east), do: node_coordinates_east(node)
    l4 = if not Node.any?(node, node.south), do: node_coordinates_south(node)

    [l1,l2,l3,l4]
    |> Enum.filter(&(not is_nil &1))
    |> Enum.map(&(line_element(&1)))
  end

  defp line({_k, %Node{} = node}), do: line(node)

  defp node_coordinates_north(%Node{position: p}) do
    {
      coordinates({:x, p.x}),
      coordinates({:y, p.y}),
      coordinates({:x, p.x}) + @tile_size_sq,
      coordinates({:y, p.y})
    }
  end

  defp node_coordinates_west(%Node{position: p}) do
    {
      coordinates({:x, p.x}),
      coordinates({:y, p.y}),
      coordinates({:x, p.x}),
      coordinates({:y, p.y}) + @tile_size_sq
    }
  end

  defp node_coordinates_east(%Node{position: p}) do
    {
      coordinates({:x, p.x}) + @tile_size_sq,
      coordinates({:y, p.y}),
      coordinates({:x, p.x}) + @tile_size_sq,
      coordinates({:y, p.y}) + @tile_size_sq
    }
  end

  defp node_coordinates_south(%Node{position: p}) do
    {
      coordinates({:x, p.x}),
      coordinates({:y, p.y}) + @tile_size_sq,
      coordinates({:x, p.x}) + @tile_size_sq,
      coordinates({:y, p.y}) + @tile_size_sq
    }
  end

  defp coordinates({:x, p}), do: (1 + p) * @tile_size_sq
  defp coordinates({:y, p}), do: (1 + p) * @tile_size_sq

  defp line_element(nil), do: ""
  defp line_element({x1, y1, x2, y2}) do
    """
    <line x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}" stroke="#{@stroke_color}" />
    """
  end
end
