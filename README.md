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

## v2... coming soon...
