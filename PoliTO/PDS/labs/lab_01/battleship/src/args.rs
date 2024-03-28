use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(version, about, long_about = None)]
pub struct Args {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Creates a new board
    New {
        /// name of the file containing the board
        #[arg(short, long)]
        file: String,

        /// list of starter boats (comma separated)
        #[arg(short, long)]
        boats: String,
    },

    /// Add a new boat to the board, if possible
    Add {
        /// name of the file containing the board
        #[arg(short, long)]
        file: String,

        /// starting coordinates (comma separated)
        #[arg(short, long)]
        start: String,

        /// boat to move in the format [N{V/H}] where N is the boat size and
        /// {V/H} is the orientation (respectively Vertical or Horizontal)
        /// for example to move a boat of size 3 vertically the input would be 3V
        #[arg(short, long)]
        boat: String,
    },
}
