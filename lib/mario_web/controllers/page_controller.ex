defmodule MarioWeb.PageController do
  use MarioWeb, :controller

  def index(conn, _params) do
    # live_render(conn, MarioWeb.Live.BoardLive, session: %{})
    conn
    |> assign(:grid, Mario.Grid.generate(12, 12))
    |> render("index.html")
  end
end
