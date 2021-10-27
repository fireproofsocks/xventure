defmodule Txtr.Player do
  @moduledoc """
  A representation of a player.
  A player here is a process because we need a mailbox to receive msgs.
  """

  use GenServer

  import ExTermbox.Constants, only: [key: 1]

  alias ExTermbox.Bindings, as: Termbox
  alias ExTermbox.{Cell, EventManager, Event, Position}

  require Logger

  @spacebar key(:space)
  @enter key(:enter)

  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]

  @initial_state %{response: "", line_buffer: ""}

  def start_link(%{name: name} = state) do
    init_state = Map.merge(@initial_state, state)
    GenServer.start_link(__MODULE__, init_state, name: name)
  end

  @doc """
  Say something to a player.  The player referenced by the `to` argument must
  be an active running player process.

  ## Examples

      iex> Txtr.Player.say(:bob, "Hi there!")
  """
  def say(to, msg) do
    GenServer.call(to, {:rcv, msg})
  end

  @impl true
  def init(%{name: name} = state) do
    # Beware! Things get weird for the CLI as soon as we do this:
    :ok = Termbox.init()
    # Because each player will have their own view, they each need their
    # own event manager, so we give it a unique name.
    {:ok, em_pid} = EventManager.start_link(name: :"#{name}_event_mgr")
    # We MUST use EventManager.subscribe/2 to fully qualify which event manager
    # instance is subscribing to the _player_ (i.e. to the player's named process)
    :ok = EventManager.subscribe(em_pid, name)

    {:ok, state, {:continue, :draw_screen}}
  end

  @impl true
  def handle_call({:rcv, msg}, _from, state) do
    {:reply, :ok, %{state | response: msg}, {:continue, :draw_screen}}
  end

  @impl true
  def handle_continue(:draw_screen, state) do
    draw_screen(state)
    {:noreply, state}
  end

  @impl true
  def handle_info({:event, %Event{key: key}}, %{line_buffer: line_buffer} = state)
      when key in @delete_keys do
    {:noreply, %{state | line_buffer: String.slice(line_buffer, 0..-2)},
     {:continue, :draw_screen}}
  end

  def handle_info({:event, %Event{key: @enter}}, %{line_buffer: "exit"} = state) do
    {:stop, :normal, state}
  end

  def handle_info({:event, %Event{key: @enter}}, %{line_buffer: line_buffer} = state) do
    # TODO: Process commands here!
    # For now, we just reset the line-buffer and simulate a response with filler
    {:noreply, %{state | response: "Received: " <> line_buffer, line_buffer: ""},
     {:continue, :draw_screen}}
  end

  def handle_info({:event, %Event{key: @spacebar}}, %{line_buffer: line_buffer} = state) do
    {:noreply, %{state | line_buffer: line_buffer <> " "}, {:continue, :draw_screen}}
  end

  def handle_info({:event, %Event{ch: ch}}, %{line_buffer: line_buffer} = state) when ch > 0 do
    {:noreply, %{state | line_buffer: line_buffer <> <<ch::utf8>>}, {:continue, :draw_screen}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(_, %{name: name}) do
    :ok = EventManager.stop(:"#{name}_event_mgr")
    :ok = Termbox.shutdown()
    :ok
  end

  defp draw_screen(%{response: response, line_buffer: line_buffer}) do
    Termbox.clear()

    response
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.each(fn {ch, x} ->
      :ok = Termbox.put_cell(%Cell{position: %Position{x: x, y: 0}, ch: ch})
    end)

    "<type a command or type 'exit' to quit>"
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.each(fn {ch, x} ->
      :ok = Termbox.put_cell(%Cell{position: %Position{x: x, y: 2}, ch: ch})
    end)

    ("❯ " <> line_buffer <> "█")
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.each(fn {ch, x} ->
      :ok = Termbox.put_cell(%Cell{position: %Position{x: x, y: 3}, ch: ch})
    end)

    Termbox.present()
  end
end
