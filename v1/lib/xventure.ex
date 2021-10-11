defmodule Xventure do
  @moduledoc """
  `Xventure` is a simple proof-of-concept text adventure game.
  This version of the game is single-player. It uses the simplest
  possible way to maintain state: an argument is passed along
  through its game loop.
  """

  alias Xventure.Location, as: Loc

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

  defmodule State do
    defstruct loc: nil, started_at: nil
  end

  def new do
    Figlet.text("Xventure!", font: "figlet.js/Elite.flf")
    game_loop("look", %State{loc: "clearing", started_at: DateTime.utc_now()})
  end

  defp game_loop(cmd, state) when cmd in @directions,
    do: game_loop("go #{Map.get(@translations, cmd, cmd)}", state)

  defp game_loop("go " <> dest, %State{loc: loc} = state) do
    case loc_data(loc) do
      %{"exits" => %{^dest => new_loc}} ->
        game_loop("look", Map.put(state, :loc, new_loc))

      _ ->
        Cowrie.error("You can't go #{dest} from here.")
        game_loop("look", state)
    end
  end

  defp game_loop("look", %State{loc: loc} = state) do
    data = loc_data(loc)
    Cowrie.info(data["content"])
    Cowrie.info("Exits: #{data["exits"] |> Map.keys() |> Enum.join(", ")}")
    command_prompt() |> game_loop(state)
  end

  defp game_loop("exit", _) do
    Cowrie.info("Exiting Xventure. Goodbye!")
  end

  defp game_loop(nil, state) do
    command_prompt() |> game_loop(state)
  end

  defp game_loop(unknown_command, state) do
    Cowrie.error("I don't know the command: #{inspect(unknown_command)}")
    command_prompt() |> game_loop(state)
  end

  defp command_prompt do
    Cowrie.prompt(">")
    |> String.trim()
    |> String.downcase()
  end

  defp loc_data(location_id), do: Loc.load!(location_id)
end
