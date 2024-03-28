use battleship::board::{self, Board};

#[test]
fn new_board() {
    let mut vector = Vec::new();

    for i in (0..board::BOAT_TYPES).rev() {
        vector.push(i as u8);
    }

    Board::new(vector.as_slice());
}

#[should_panic]
#[test]
fn new_board_too_many_boats() {
    let mut vector = Vec::new();

    for i in (0..board::BOAT_TYPES + 1).rev() {
        vector.push(i as u8);
    }

    Board::new(vector.as_slice());
}

#[should_panic]
#[test]
fn new_board_too_few_boats() {
    let mut vector = Vec::new();

    for i in (0..board::BOAT_TYPES - 1).rev() {
        vector.push(i as u8);
    }

    Board::new(vector.as_slice());
}

#[test]
fn create_board_from_string() {
    let s = "4 3 1 1\nB                   \nB                   \nB                   \n                    \n                    \n                    \n                    \n                    \n                    \n         BBB        \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    ";

    assert_eq!(Board::from(s.to_string()).to_string(), s);
}

#[test]
fn add_boat() {
    let s = "4 3 1 1\nB                   \nB                   \nB                   \n                    \n                    \n                    \n                    \n                    \n                    \n         BBB        \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    ";
    let sp = "4 2 1 1\nBB                  \nBB                  \nB                   \n                    \n                    \n                    \n                    \n                    \n                    \n         BBB        \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    \n                    ";

    let board = Board::from(s.to_string());
    let modified_board = board.add_boat(board::Boat::Vertical(2), (1, 2));

    assert_eq!(modified_board.unwrap().to_string(), sp);
}
