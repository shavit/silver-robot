defmodule Mario.Grid.Node do
  alias Mario.Grid.Position

  defstruct [
    position: nil,
    north: nil,
    east: nil,
    south: nil,
    west: nil,
    neighbours: [],
  ]

  @type t :: %__MODULE__{
    position:       Position.t | nil,
    north:          Position.t | nil,
    east:           Position.t | nil,
    south:          Position.t | nil,
    west:           Position.t | nil,
    neighbours:     list()
  }

  def init(x, y), do: %__MODULE__{position: %Position{x: x, y: y}}

  def link(left, right) when not is_nil(right) do
    Map.update!(left, :neighbours, fn x ->
      x
      |> List.insert_at(-1, right.position)
      |> Enum.uniq
    end)
  end

  def unlink(left, right) do
    Map.update!(left, :neighbours, fn x ->
      x
      |> Enum.filter(&(&1 != right.position))
      |> Enum.uniq
    end)
  end

  @doc """
  Check if the node on the left has a link to the node on the left
  """
  def any?(left, right) when not is_nil(right) do
    Enum.any?(left.neighbours, fn x ->
      Position.eq(x, right.position)
    end)
  end
  def any?(_left, nil), do: false

end
