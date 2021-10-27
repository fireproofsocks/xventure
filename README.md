# Xventure

This repo contains several versions of a text-adventure game written in Elixir, used as a educational aid.

It was inspired by interactive text adventure games like [Zork](https://en.wikipedia.org/wiki/Zork) and [Adventure](http://rickadams.org/adventure/).

To load up any of the versions, `cd` into the directory and follow the instructions there.

```
▐▄• ▄  ▌ ▐·▄▄▄ . ▐ ▄ ▄▄▄▄▄▄• ▄▌▄▄▄  ▄▄▄ .▄▄
 █▌█▌▪▪█·█▌▀▄.▀·•█▌▐█•██  █▪██▌▀▄ █·▀▄.▀·██▌
 ·██· ▐█▐█•▐▀▀▪▄▐█▐▐▌ ▐█.▪█▌▐█▌▐▀▀▄ ▐▀▀▪▄▐█·
▪▐█·█▌ ███ ▐█▄▄▌██▐█▌ ▐█▌·▐█▄█▌▐█•█▌▐█▄▄▌.▀
•▀▀ ▀▀. ▀   ▀▀▀ ▀▀ █▪ ▀▀▀  ▀▀▀ .▀  ▀ ▀▀▀  ▀
```

## [v1](v1/README.md)

The basic proof of concept. This is a single-player version of the game. It uses no GenServer's: it just passes its state as an argument throughout its game loop, something like passing an accumulator through a reduce function.

## [v2](v2/README.md)

This version introduces functionality to support multiple players. See the docs for ways to attach multiple terminal windows to the same running game instance.

## [Texting Proof of Concept](txtr/README.md)

This is a proof of concept for a raw-input-mode interface where you can "say" messages to players and have their screen update immediately. This shows how we can improve the limited interface from v2 and support real-time updates and chatting in our game.
