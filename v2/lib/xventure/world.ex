defmodule Xventure.World do
  use GenServer

  @starting_location :clearing

  defmodule State do
    @moduledoc """
    The state of the world; double-entry book-keeping.

    The `:players` value tracks the location of each player, keyed
    off their player id.

    The `:locs` value tracks who is each location, keyed off of
    the location id.

    ```
    %State{
      players: %{
        p1: :barn,
        p2: :clearing
      },
      locs: %{
        "barn" => [:p1],
        "clearing" => [:p2]
      }
    }
    ```
    """
    defstruct players: %{}, locs: %{}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  @doc """
  Is the given player already playing the game?
  """
  @spec member?(player :: any()) :: boolean()
  def member?(player) do
    GenServer.call(__MODULE__, {:member?, player})
  end

  @doc """
  Move the given player to the given location
  """
  def move(player, loc) do
    GenServer.call(__MODULE__, {:move, player, loc})
  end

  @doc """
  A player joins the game.
  """
  @spec join(player :: any()) :: :ok | {:error, String.t()}
  def join(player) do
    case member?(player) do
      true -> {:error, "Player #{player} has already joined. Choose a different name."}
      false -> move(player, @starting_location)
    end
  end

  @doc """
  A player leaves the game: remove their references from the state
  """
  @spec leave(player :: any()) :: :ok | {:error, String.t()}
  def leave(player) do
    case member?(player) do
      false -> {:error, "Player #{player} is not an active player"}
      true -> GenServer.call(__MODULE__, {:leave, player})
    end
  end

  @doc """
  Returns the location of the given player.
  """
  def whereami(player) do
    GenServer.call(__MODULE__, {:whereami, player})
  end

  @doc """
  Returns a `MapSet` of all players at the current location
  """
  def whoishere(loc) do
    GenServer.call(__MODULE__, {:whoishere, loc})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:leave, player}, _from, %State{players: players, locs: locs} = state) do
    prev_loc = Map.get(players, player)

    everyone_at_loc = Map.get(locs, prev_loc, MapSet.new())

    {:reply, :ok,
     %State{
       state
       | players: Map.delete(players, player),
         locs: Map.put(locs, prev_loc, MapSet.delete(everyone_at_loc, player))
     }}
  end

  def handle_call({:member?, player}, _from, %State{players: players} = state) do
    {:reply, Map.has_key?(players, player), state}
  end

  def handle_call({:move, player, new_loc}, _from, %State{players: players, locs: locs} = state) do
    prev_loc = Map.get(players, player)

    {:reply, :ok,
     %State{
       state
       | players: Map.put(players, player, new_loc),
         locs: update_locs(locs, player, prev_loc, new_loc)
     }}
  end

  def handle_call({:whereami, player}, _from, %State{players: players} = state) do
    {:reply, Map.get(players, player), state}
  end

  def handle_call({:whoishere, loc}, _from, %State{locs: locs} = state) do
    {:reply, Map.get(locs, loc), state}
  end

  # add player to the new location
  defp update_locs(locs, player, nil, new_loc) do
    everybody_at_new_loc = Map.get(locs, new_loc, MapSet.new())
    Map.put(locs, new_loc, MapSet.put(everybody_at_new_loc, player))
  end

  # remove player from the previous location
  defp update_locs(locs, player, prev_loc, new_loc) do
    everybody_at_old_loc = Map.get(locs, prev_loc, MapSet.new())

    locs
    |> Map.put(prev_loc, MapSet.delete(everybody_at_old_loc, player))
    |> update_locs(player, nil, new_loc)
  end
end
