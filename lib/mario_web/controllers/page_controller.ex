defmodule MarioWeb.PageController do
  use MarioWeb, :controller

  def index(conn, _params) do
    live_render(conn, MarioWeb.Live.BoardLive, session: %{})
  end
end
