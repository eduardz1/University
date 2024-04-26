use clap::Parser;
use slugify::slug::slugify;
use slugify::slug::Slug;

#[derive(Parser, Debug)]
struct Args {
    /// The sentence to slugify
    #[arg(num_args = 1..)]
    slug_in: Vec<String>,

    /// Sets the number of times the sentence is repeated
    #[arg(short, long)]
    repeat: Option<u32>,

    /// Enables or disables verbose mode
    #[arg(short, long)]
    verbose: Option<bool>,

    /// Check if the sentence is a slug
    #[arg(short, long)]
    check: Option<bool>,
}

fn main() {
    let args = Args::parse();
    let n = args.repeat.unwrap_or(1);
    let verbose = args.verbose.unwrap_or(false);
    let check = args.check.unwrap_or(false);

    if check {
        for sentence in &args.slug_in {
            if verbose {
                println!("Original: {}", sentence);
            }
            println!("{}", sentence.is_slug());
        }
        return;
    }

    for _ in 0..n {
        for sentence in &args.slug_in {
            if verbose {
                println!("Original: {}", sentence);
            }
            println!("{}", slugify(&sentence));
        }
    }
}
