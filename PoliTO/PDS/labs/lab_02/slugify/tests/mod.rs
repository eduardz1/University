use slugify::slug::slugify;

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
