use std::{
    fs,
    io::{Error, ErrorKind},
};

use args::{Args, Commands};
use board::{Board, Boat};
use clap::Parser;

pub mod args;
pub mod board;

fn main() -> std::io::Result<()> {
    let args = Args::parse();

    match &args.command {
        Commands::New { file, boats } => {
            let board = Board::new(
                boats
                    .split(",")
                    .map(|s| s.parse::<u8>().unwrap())
                    .collect::<Vec<_>>()
                    .as_slice(),
            );

            fs::write(file, board.to_string())?;
        }
        Commands::Add { file, start, boat } => {
            let board = Board::from(fs::read_to_string(file)?);

            // Does not work on boat sizes in the double digits
            let (size, direction) = boat.split_at(1);
            let boat = match direction.to_lowercase().as_str() {
                "v" => Boat::Vertical(size.parse().unwrap()),
                "h" => Boat::Horizontal(size.parse().unwrap()),
                _ => {
                    return Err(Error::new(
                        ErrorKind::InvalidInput,
                        "Pass 'v' for vertical or 'h' for horizontal",
                    ))
                }
            };

            let coordinates = start
                .split(",")
                .map(|c| c.parse::<u8>().unwrap())
                .collect::<Vec<_>>();

            let x = coordinates[0] as usize;
            let y = coordinates[1] as usize;

            match board.add_boat(boat, (x, y)) {
                Err(e) => return Err(Error::new(ErrorKind::Other, format!("{:?}", e))),
                Ok(res) => {
                    fs::write(file, res.to_string())?;
                }
            }
        }
    }

    Ok(())
}
