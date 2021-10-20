defmodule Xventure do
  @moduledoc """
  `Xventure` is a simple proof-of-concept text adventure game.
  This version of the game is single-player. It uses the simplest
  possible way to maintain state: an argument is passed along
  through its game loop.
  """

  alias Xventure.Location, as: Loc
  alias Xventure.World

  require Logger

  @directions [
    "north",
    "east",
    "south",
    "west",
    "n",
    "e",
    "s",
    "w",
    "u",
    "d",
    "up",
    "down",
    "in",
    "out",
    "inside",
    "outside"
  ]

  @translations %{
    "u" => "up",
    "d" => "down",
    "n" => "north",
    "e" => "east",
    "s" => "south",
    "w" => "west",
    "inside" => "in",
    "outside" => "out"
  }

  @doc """
  Start a new game as the indicated player.

  ## Examples

      iex> Xventure.new(:bob)

  """
  def new(player) do
    with :ok <- Xventure.World.join(player) do
      game_loop("look", player)
    end
  end

  defp game_loop(cmd, player) when cmd in @directions,
    do: game_loop("go #{Map.get(@translations, cmd, cmd)}", player)

  defp game_loop("go " <> dest, player) do
    with loc <- World.whereami(player),
         %{"exits" => %{^dest => new_loc}} <- loc_data(loc),
         :ok <- World.move(player, new_loc |> String.to_atom()) do
      game_loop("look", player)
    else
      _ ->
        Cowrie.error("You can't go #{dest} from here.")
        game_loop("look", player)
    end
  end

  defp game_loop("look", player) do
    loc = World.whereami(player)

    data = loc_data(loc)

    whoishere_besides_me =
      loc
      |> World.whoishere()
      |> MapSet.delete(player)

    Cowrie.info(data["content"])
    Cowrie.info("Other people at this location: #{whoishere_besides_me |> Enum.join(", ")}")
    Cowrie.info("Exits: #{data["exits"] |> Map.keys() |> Enum.join(", ")}")
    command_prompt() |> game_loop(player)
  end

  defp game_loop("exit", player) do
    case World.leave(player) do
      :ok -> Cowrie.info("Exiting Xventure. Goodbye!")
      {:error, error} -> Cowrie.error(error)
    end
  end

  defp game_loop(unknown_command, player) do
    Cowrie.error("I don't know the command: #{inspect(unknown_command)}")
    command_prompt() |> game_loop(player)
  end

  defp command_prompt do
    Cowrie.prompt(">")
    |> String.trim()
    |> String.downcase()
  end

  defp loc_data(location_id), do: Loc.load!(location_id)
end
