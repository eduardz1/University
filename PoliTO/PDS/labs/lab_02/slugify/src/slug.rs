use lazy_static::lazy_static;
use regex::Regex;
use std::collections::HashMap;

lazy_static! {
    static ref RE: Regex = Regex::new(r"--+").unwrap();
}

pub trait Slug<T> {
    fn is_slug(&self) -> bool;
    fn to_slug(&self) -> String;
}

impl<T> Slug<T> for T
where
    T: AsRef<str>,
{
    fn is_slug(&self) -> bool {
        self.as_ref() == self.to_slug()
    }

    fn to_slug(&self) -> String {
        slugify(self.as_ref())
    }
}

pub fn slugify(s: &str) -> String {
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
