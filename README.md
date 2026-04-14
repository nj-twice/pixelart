# Description

Set of tools to help you make pixel art animations when you don't want to use a dedicated program like [Aseprite](https://www.aseprite.org/).

# Usage

You can easily get the necessary tools by installing [Nix](https://nixos.org/) and running
```shell
nix develop
```
inside the repo.

## Viewer

Interactive viewer for pixel art animations.
Uses `love`.

## Builder

Compiles a set of properly named image files (see below) into a sprite sheet and adds some padding to prevent texture bleeding.

Pass `--help` to get more info.

### Naming rules

In order for the builder script to correctly compile your images, their file names must follow a simple naming convention.

File names must have the following format: `x_y.png`, where both `x` and `y` are non-zero natural numbers that follow a natural progression, without any leaps or omissions.
`x` and `y` are interpreted as indices respectively for the rows and columns of a rectangular grid.

For example:
 { `1_1.png`, `1_2.png`, `2_1.png`, `2_2.png` }
is a valid set of file names, whereas
{ `1_1.png`, `1_3.png`, `2_1.png`, `2_2.png` }
and
{ `1_1.png`, `1_2.png`, `3_1.png`, `3_2.png` }
are **not**.
