import argparse
from PIL import Image as img
import os
import re

pattern = re.compile(r"^[0-9]+_[0-9]+.png$")

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
    paths: list[str] = get_image_paths()
    print(paths)
    check_paths(paths)

def check_paths(img_paths: list[str]):
    row_number = 1

    # Only for declaration. A value will be put later.
    max_columns = None

    while True:
        # Check that the row exists
        col_count = 0
        for path in img_paths:
            if path.startswith(f"{row_number}_"):
                col_count += 1
        if col_count == 0:
            # This happens both if a row was skipped or if it was the last one.

            err_msg = f"Row number {row_number} wasn't found!"

            if row_number == 1:
                # Unconditional error if we're dealing with the first row
                raise RuntimeError(err_msg)
            else:
                # If we're in a row >=2, then we got a max columns count value
                # we can check against to differentiate cases where row is skipped
                # and those where last row.

                remaining_paths = len(img_paths) - ((row_number - 1) * max_columns)
                # If some unchecked paths remain, it means we skipped a row
                if remaining_paths == 0:
                    print("No unchecked paths left. Continuing with build.")
                    break
                else:
                    raise RuntimeError(err_msg)


        # Check that row exists and no number skips happened:
        # For each row, parse frame numbers into a sorted list of integers.
        # Compare length and largest frame number.
        # If they differ, error.
        frames_in_row = [
            int(frame.split("_")[1].split(".")[0])
                for frame in img_paths if frame.startswith(f"{row_number}")
        ]
        frames_in_row.sort()
        frames_in_row.reverse()
        largest = frames_in_row[0]
        length = len(frames_in_row)
        if length != largest:
            print(f"At row no.{row_number}")
            print(f"Largest frame index: {largest} != Length: {length}")
            raise RuntimeError("Number skip happened!")

        # Only according to the first row, determine total number of columns
        if row_number == 1:
            max_columns = length
        else:
            if max_columns != length:
                raise RuntimeError(
                    f"Column count mismatch with 1st row for row number {row_number}"
                )

def get_image_paths() -> list[str]:
    paths: list[str] = []
    for filename in os.listdir("."):
        if os.path.isfile(filename) and pattern.match(filename):
            paths.append(filename)
    return paths

def play():
    make()
    print("Playing the animation!")

if __name__ == "__main__":
    main()
