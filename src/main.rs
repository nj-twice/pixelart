use regex::Regex;
use std::env;
use std::fs;
use image::{ImageReader, RgbaImage, imageops::overlay};

const FIRST_FRAME: &str = "1_1.png";
const MARGIN: u32 = 2;

fn main() {
}

struct Point {
    x: i64,
    y: i64
}

fn make_spritesheet() {
    check_image_dimensions(&paths);

    // Actually build the spritesheet

    let (mut width, mut height) = ImageReader::open(FIRST_FRAME)
        .unwrap().into_dimensions().unwrap();

    let columns: u32 = paths.iter()
        .filter(|x| x.starts_with("1_"))
        .count()
        .try_into().unwrap();
    let total_files: u32 = paths.iter().count().try_into().unwrap();
    let rows: u32 = total_files / columns;

    // Add a margin to avoid flickering borders in animation
    // Double to account for centering.
    width += MARGIN * 2;
    height += MARGIN * 2;

    let mut insert_point = Point {x: 0 as i64, y: 0 as i64};
    let mut final_image = RgbaImage::new(width * columns, height * rows);

    for frame in paths {

        // We don't need to sort the path list.
        // We can determine the insert point coordinates based on
        // frame numbers.
        // row 1, col 1 => x = 0, y = 0
        // row 1, col 2 => x = frame width, y = 0
        // row 2, col 1 => x = 0, y = frame height
        // row 2, col 2 => x = frame width, y = frame height
        // row 3, col 1 => x = 0, y = frame height * 2
        // ...

        let row = frame.as_str().split_once('_')
                .unwrap().0.parse::<i64>().unwrap();
        let col = frame.as_str().split_once('_')
                .unwrap().1
                .split_once('.').unwrap().0.parse::<i64>().unwrap();

        insert_point.x = (col - 1) * (width as i64) + (MARGIN as i64);
        insert_point.y = (row - 1) * (height as i64) + (MARGIN as i64);

        let overlay_image = ImageReader::open(frame).unwrap().decode().unwrap();
        overlay(&mut final_image, &overlay_image, insert_point.x, insert_point.y);
    }

    final_image.save("spritesheet.png");

    println!("Frame dimensions: {width} × {height}")
}

fn check_image_dimensions(paths: &Vec<String>) {
    let init_dimensions = ImageReader::open(FIRST_FRAME)
        .unwrap().into_dimensions();

    match init_dimensions {
        Err(_) => {
             println!("Error: probably not an image");
             panic!("Image error!");
             }
        Ok(_) => ()
    }

    let init_dimensions = init_dimensions.unwrap();

    #[cfg(debug_assertions)]
    {
        println!("Printing found dimensions");
        dbg!(init_dimensions);
    }

    for file in paths {
        let dimensions = ImageReader::open(file).unwrap().into_dimensions();

        match dimensions {
            Err(_) => {
             println!("Error: {file} is probably not an image");
             panic!("Image error!");
            }
            Ok(_) => ()
        }

        let dimensions = dimensions.unwrap();

        if dimensions != init_dimensions {
            let x = dimensions.0;
            let y = dimensions.1;
            panic!("Dimensions of {file} ({x}×{y}) don't match those of first frame.")
        }
    }
}


// TODO: use macroquad to play animation
//       - interactively changeg FPS
//       - select which row (animation)
//       - select columns range (frames)
//       - display some info from a generated info file?
// TODO: detect existence of an already generated sprite sheet
fn visualize_animation() {}
