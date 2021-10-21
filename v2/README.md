# Xventure v2

This is a continuation of the work done in the `v1` folder. This version adds support for multiple players. See the accompanying blog post: <https://fireproofsocks.medium.com/writing-a-text-adventure-game-in-elixir-part-2-de1cf46b26fa>

To start this version of the game, you will want to connect 2 or more terminal windows to the same `iex` session.  Run the following commands from inside this directory (`v2/`):

```sh
mix deps.get
iex --sname world1@localhost -S mix
```

Once inside `iex`, you can join the game by supplying a character's name:

```elixir
iex> Xventure.new(:bill)
```

For other players to join the name, they will have to attach to the running `iex` session:

```sh
iex --sname player2 --remsh world1@localhost
```

Once they have connected to `iex`, they too can join the game:

```elixir
iex> Xventure.new(:ted)
```

When both players are in the same room, this should be reflected in the description, e.g.

```
Other people at this location: bill
```
