defmodule Mario.Grid.Edges do
  alias Mario.Grid
  alias Mario.Grid.Node

  def create(%Grid{} = grid) do
    grid
    |> Map.update!(:nodes, fn nodes ->
      nodes
      |> Enum.sort
      |> Enum.reduce(%{nodes: %{}, walk: []}, fn {{_x,_y}, node}, acc ->
        if should_close(node) do
          closed_node
            = acc.walk ++ [node]
          |> Enum.random
          |> close_node

          %{nodes: put_node(acc.nodes, closed_node), walk: []}
        else
          %{nodes: put_node(acc.nodes, node),
            walk: List.insert_at(acc.walk, -1, node)}
        end
      end)
      |> Map.get(:nodes)
    end)
  end

  defp should_close(node) do
    (!is_nil(node.south) && roll_dice()) || is_nil(node.east)
  end

  defp roll_dice, do: :random.uniform(2) == 1

  defp close_node(%Node{south: south} = node) when not is_nil(south) do
    Node.link(node, south)
  end

  defp close_node(%Node{east: east} = node) do
    Node.link(node, east)
  end

  defp put_node(nodes, %Node{x: x, y: y} = node), do: Map.put(nodes, {x, y}, node)
end
