# Txtr

This is a proof-of-concept application meant to show how a multi-player text game
can support asynchronous events, e.g. chats between players.

In one terminal window, connect:

```sh
iex --sname world1@localhost -S mix
```

Then initialize a new player:

```iex
iex> Txtr.start(:bob)
```

In another window, connect to the previous `iex` session:

```sh
iex --sname player2 --remsh world1@localhost
```

Now you can send a message to the player started in the first terminal:

```iex
iex> Txtr.Player.say(:bob, "Hi there!")
```

Back in terminal one, you should see the message you sent.

To exit the "game", type `exit` and press enter.
