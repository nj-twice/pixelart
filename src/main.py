import argparse
from PIL import Image
import os
import re

# Debug print
def dprint(msg):
    print(msg)
    # pass

PATTERN = re.compile(r"^[0-9]+_[0-9]+.png$")
MARGIN: int = 2

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
    check_dimensions(paths)

    # Actually build the sprite sheet

    columns = len( [ i for i in paths if i.startswith("1_") ] )
    total_files = len(paths)
    rows = total_files // columns

    dprint(f"{columns=}, {rows=}, {total_files=}")

    # Add padding to avoid texture bleeding
    # Double to account for centering
    first_img = Image.open(paths[0])
    padded_img_size: tuple[int, int] = tuple(
        map(lambda x, y: x + y,
            first_img.size, (MARGIN*2, MARGIN*2)
        )
    )
    dprint(f"{padded_img_size=}")

    canvas_img_size = (padded_img_size[0] * columns, padded_img_size[1] * rows)
    dprint(f"{canvas_img_size=}")
    final_image = Image.new(
        "RGBA",
        canvas_img_size
    )

    # We don't need to sort the path list.
    # We can determine the insert point coordinates based on
    # frame numbers.
    # row 1, col 1 => x = 0, y = 0
    # row 1, col 2 => x = frame width, y = 0
    # row 2, col 1 => x = 0, y = frame height
    # row 2, col 2 => x = frame width, y = frame height
    # row 3, col 1 => x = 0, y = frame height * 2
    # ...

    for img_path in paths:
        row = int(img_path.split("_")[0])
        col = int(img_path.split("_")[1].split(".")[0])

        dprint(f"{img_path=} : {row=}, {col=}")

        insert_point: tuple[int, int] = (
            (col - 1) * padded_img_size[0] + MARGIN,
            (row - 1) * padded_img_size[1] + MARGIN
        )

        dprint(f"{insert_point=}")

        final_image.paste(
            Image.open(img_path),
            insert_point
        )

    final_image.save("python_sprite_sheet.png")


def check_dimensions(img_paths: list[str]):
    # We assume path check was run and paths are correct.
    img_paths.sort()
    imgs: list[Image.Image] = [
        Image.open(img_path) for img_path in img_paths
    ]
    for img in imgs:
        if img.size != imgs[0].size: # Again, first image is our ref
            raise RuntimeError(
               f"Dimension of \"{img}\" ({img.size[0]}×{img.size[1]}) don't match those of first frame."
           )

def check_paths(img_paths: list[str]):
    row_number = 1

    # Only for declaration. A proper value will be put later.
    max_columns = 0

    while True:
        dprint(f"Checking paths for row {row_number}")
        # Check that the row exists
        col_count = 0
        for path in img_paths:
            if path.startswith(f"{row_number}_"):
                col_count += 1
        if col_count == 0:
            # This happens both if a row was skipped or if it was the last one

            dprint(f"No columns for row {row_number}")

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

        # If all's good, check next row
        row_number += 1

def get_image_paths() -> list[str]:
    paths: list[str] = []
    for filename in os.listdir("."):
        if os.path.isfile(filename) and PATTERN.match(filename):
            paths.append(filename)
    return paths

def play():
    make()
    print("Playing the animation!")

if __name__ == "__main__":
    main()
