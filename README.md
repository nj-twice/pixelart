# Description

Simple program that compiles individual image files into a sprite sheet and adds some padding around sprites to prevent texture bleeding.

# Usage

Inside a directory of properly named image files (see below), run the `main.py` file with your Python interpreter.

You can easily get the necessary tools by installing [Nix](https://nixos.org/) and running
```shell
nix develop
```
inside the repo.

Pass `--help` to get more info.

# Naming rules

In order for the program to correctly compile your images, their file names must follow a simple naming convention.

File names must have the following format: `x_y.png`, where both `x` and `y` are non-zero natural numbers that follow a natural progression, without any leaps or omissions.

For example:
 { `1_1.png`, `1_2.png`, `2_1.png`, `2_2.png` }
is a valid set of file names, whereas
{ `1_1.png`, `1_3.png`, `2_1.png`, `2_2.png` }
and
{ `1_1.png`, `1_2.png`, `3_1.png`, `3_2.png` }
are **not**.

`x` represents the row in the final sprite sheet, that is, an animation and `y` represents the column, that is, an individual frame of an animation.

# Alternatives

- [Aseprite](https://www.aseprite.org/):
  Dedicated program for drawing pixel art with lots of features
