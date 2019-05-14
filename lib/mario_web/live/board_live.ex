defmodule MarioWeb.Live.BoardLive do
  use Phoenix.LiveView
  require Logger

  @tick 800

  def render(%{socket: _socket} = assigns) do
    fnc = [
      &board_1/1,
      &board_1/1,
    ] |> Enum.random
    fnc.(assigns)
  end

  def mount(_session, socket) do
    schedule_tick()
    socket = assign(socket, %{score: @score})
    {:ok, socket}
  end

  #
  #   Helpers
  #

  defp schedule_tick do
    Process.send_after(self(), :tick, @tick)
  end

  defp board_1(%{socket: _socket} = assigns) do
    ~L"""
    <svg id="board" style="background: #efefef;">
      <defs>
        <pattern id="dGridCube" width="16" height="16" patternUnits="userSpaceOnUse">
          <path d="M 16 0 L 0 0 0 16" fill="none" stroke="#cccccc" stroke-width="0.6"/>
        </pattern>
        <pattern id="dGridPlanes" width="64" height="64" patternUnits="userSpaceOnUse">
          <rect width="64" height="64" fill="url(#dGridCube)"></rect>
          <path d="M 64 0 L 0 0 0 64" fill="none" stroke="#9e9e9e" stroke-width="1.44"/>
        </pattern>
      </defs>
      <rect width="100%" height="100%" fill="url(#dGridPlanes)"></rect>
    </svg>
    """
  end

  #
  #   Callbacks
  #

  def handle_info(:tick, socket) do
    # Logger.debug "Tick"
    schedule_tick()
    {:noreply, socket}
  end

end
