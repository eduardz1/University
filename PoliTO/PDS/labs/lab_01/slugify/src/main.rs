use clap::Parser;
use lazy_static::lazy_static;
use regex::Regex;
use std::collections::HashMap;

lazy_static! {
    static ref RE: Regex = Regex::new(r"--+").unwrap();
}

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
}

fn main() {
    let args = Args::parse();
    let n = args.repeat.unwrap_or(1);
    let verbose = args.verbose.unwrap_or(false);

    if verbose {
        println!("Converting the string!: \n")
    }

    for _ in 0..n {
        for sentence in &args.slug_in {
            println!("{}", slugify(&sentence));
        }
    }
}

fn slugify(s: &str) -> String {
    let cleaned_string = String::from(s.to_lowercase())
        .chars()
        .map(|x| match x {
            'a'..='z' | '0'..='9' | '-' => x,
            _ => conv(x),
        })
        .collect::<String>();

    // remove consecutive "-" and trim
    let cleaned = RE.replace_all(cleaned_string.as_str(), "-").to_string();
    match cleaned.len() {
        1 => cleaned,
        _ => cleaned.trim_end_matches("-").to_string(),
    }
}

/// Converts the accented letters in the corresponding unaccented letters if it
/// exists, otherwise it return the character "-"
fn conv(c: char) -> char {
    const SUBS_I: &str =
        "àáâäæãåāăąçćčđďèéêëēėęěğǵḧîïíīįìıİłḿñńǹňôöòóœøōõőṕŕřßśšşșťțûüùúūǘůűųẃẍÿýžźż";
    const SUBS_O: &str =
        "aaaaaaaaaacccddeeeeeeeegghiiiiiiiilmnnnnoooooooooprrsssssttuuuuuuuuuwxyyzzz";

    let map: HashMap<_, _> = SUBS_I.chars().zip(SUBS_O.chars()).collect();

    *map.get(&c).unwrap_or(&'-')
}

#[test]
fn accented_letter_conversion() {
    assert_eq!(slugify("à"), "a")
}

#[test]
fn non_accented_letter_conversion() {
    assert_eq!(slugify("c"), "c")
}

#[test]
fn non_recognized_symbol_conversion() {
    assert_eq!(slugify("{"), "-")
}

#[test]
fn non_recognized_accented_letter_conversion() {
    assert_eq!(slugify("ῶ"), "-")
}

#[test]
fn multiple_words_separated_with_spaces() {
    assert_eq!(slugify("perché è la stupidità!"), "perche-e-la-stupidita")
}

#[test]
fn word_with_accents() {
    assert_eq!(slugify("pèrché"), "perche")
}

#[test]
fn empty_string() {
    assert_eq!(slugify(""), "")
}

#[test]
fn multiple_consecutive_spaces() {
    assert_eq!(slugify("orange      kiwi"), "orange-kiwi")
}

#[test]
fn multiple_consecutive_non_valid_characters() {
    assert_eq!(slugify("orange}}[';?kiwi?"), "orange-kiwi")
}

#[test]
fn already_valid_string() {
    assert_eq!(slugify("orange-kiwi"), "orange-kiwi")
}

#[test]
fn ending_with_spaces() {
    assert_eq!(slugify("orange       "), "orange")
}

#[test]
fn ending_with_multiple_non_valid_characters() {
    assert_eq!(slugify("orange???[})*"), "orange")
}
