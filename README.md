# Nim SDL2 Etudes

These codes all have accompanying posts in my globa:
[Link](https://chubakbidpaa.com)


## What is Nim?

Nim is a systems programming language that is statically typed and typesage. But it might as well be dynamically typed because it has compile-time inference and you rarely need to specify type for your variables. It looks, feels, and writes like Python but it's a compiled language, pretty fast, and most importantly it lacks libraries for every single mundane thing so you can actually enjoy implemening everything from scratch.

Nim compiles to C so you need GCC on Linux or Visual C++ or MinGW to run the code. It's compiled to Common C so embedded devices can run it too. Hell I bet you can develop games for the NES with Nim if someone binds `nes.h` to Nim! (if someone has not done it, please do!)

But, the most important thing is, it's got a surgaric syntax. The most sugaric syntaqx I've ever seen. Insomuch that they have a different std package called sugar to have EVEN MORE sugary stuff. This language can't be good for my diabetes!

It's got a garbage colloector is it's not exactly Rust. But then again it's a different beast than Rust is. I would not use Nim for memory-intensive jobs, but making a 2D game in SDL is not exactly memory-intensive is it?

## What are these Etudes for?

These etudes are for SDL2.0 bindings for Nim. I don't use the official bindings because they kinda suck. I use this:

```
https://github.com/Vladar4/sdl2_nim
```


## How to Run?

1. Install Nim and Nimble (Nibmle comes with Nim)
2. Follow the instructions in the repo above to install SDL2.0 on your OS. NOTE: I have noticed that on Ubuntu 20.04 you need to install sdl2.0-image separately.
3. `nim c -r [filename]` this will compile and run the file.


## Etudes so Far:

### `bouncingball.nim`

Accompanying Post: Coming Soon!

A bouncing ball, very simple, but it showcases the basics of SDL in Nim, especially Nim's meta-like functions (coincidentally, Nim has both meta-like symbolic functions AND macros! Metaprogramming with Nim is going to be fun yum!)

### `pong.nim`

Accompanying Post: Coming Soon

This is a very INTELLIGENT Pong game! It does not randomly go up and down. It uses conditional probability to go up and down and speed up and down.