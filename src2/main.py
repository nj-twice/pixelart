import argparse
from PIL import Image as img

def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(title="actions")
    parser_make = subparsers.add_parser("make", help = "Build the sprite sheet from the image files in the current directory")
    parser_play = subparsers.add_parser("play", help = "Build the sprite sheet and start playing the resulting animation in a new window")
    parser_make.set_defaults(func=make)
    parser_play.set_defaults(func=play)
    args = parser.parse_args()
    args.func()

def make():
    print("Making the sprite sheet!")

def play():
    make()
    print("Playing the animation!")

if __name__ == "__main__":
    main()
