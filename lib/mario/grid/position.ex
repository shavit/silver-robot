defmodule Mario.Grid.Position do
  alias Mario.Grid.Node

  defstruct [
    x: nil,
    y: nil,
  ]
  @type t :: %__MODULE__{
    x:              integer() | nil,
    y:              integer() | nil,
  }

  @doc """
  Check if the positions on the left and right are equal
  """
  def eq(left, right), do: left.x == right.x && left.y == right.y

  @doc """
  Helper to return a unique position key
  """
  def key(%__MODULE__{} = position), do: {position.x, position.y}

  def key(%Node{} = n), do: {n.position.x, n.position.y}

end
