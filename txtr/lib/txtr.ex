defmodule Txtr do
  @moduledoc """
  This app is a simple proof-of-concept for how asynchronous events might
  influence players in a multi-player game. Specifically, the functions here
  allow messages to be sent to a player to chat with them. See the README.
  """

  def start(player_name) do
    {:ok, pid} = Txtr.Player.start_link(%{name: player_name})

    # This helps to cleanly return the user to iex after
    # the player has exited their game.
    ref = Process.monitor(pid)

    receive do
      {:DOWN, ^ref, _, _, _} -> :ok
    end
  end
end
