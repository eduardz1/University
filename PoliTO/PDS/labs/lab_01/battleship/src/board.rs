pub const BOARD_SIZE: usize = 20;
pub const BOAT_TYPES: usize = 4;

pub struct Board {
    boats: [u8; BOAT_TYPES],
    data: [[u8; BOARD_SIZE]; BOARD_SIZE],
}

#[derive(Debug)]
pub enum Error {
    Overlap,
    OutOfBounds,
    BoatCount,
}

pub enum Boat {
    Vertical(usize),
    Horizontal(usize),
}

impl Board {
    /** crea una board vuota con una disponibilità di navi */
    pub fn new(boats: &[u8]) -> Board {
        Board {
            boats: boats.try_into().unwrap(),
            data: [[0; BOARD_SIZE]; BOARD_SIZE],
        }
    }

    /* crea una board a partire da una stringa che rappresenta tutto
    il contenuto del file board.txt */
    pub fn from(s: String) -> Board {
        let lines = s.split("\n");
        let mut boats = [0u8; BOAT_TYPES];
        let mut data = [[0u8; BOARD_SIZE]; BOARD_SIZE];

        for (i, line) in lines.enumerate() {
            // first line defines number of boats
            if i == 0 {
                for (i, value) in line.split(" ").enumerate() {
                    boats[i] = value.parse().unwrap();
                }
            } else {
                for (j, c) in line.char_indices() {
                    data[i - 1][j] = if c == ' ' { 0 } else { 1 };
                }
            }
        }

        Board { boats, data }
    }

    /* aggiunge la nave alla board, restituendo la nuova board se
    possibile */
    /* bonus: provare a *non copiare* data quando si crea e restituisce
    una nuova board con la barca, come si può fare? */
    pub fn add_boat(self, boat: Boat, pos: (usize, usize)) -> Result<Board, Error> {
        let mut res = self;

        match boat {
            Boat::Vertical(n) => {
                let end = pos.0 + n;

                if end > BOARD_SIZE || res.boats[n - 1] == 0 {
                    return Err(Error::OutOfBounds);
                }

                for i in pos.0..end {
                    if res.data[i - 1][pos.1 - 1] != 0 {
                        return Err(Error::Overlap);
                    }

                    res.data[i - 1][pos.1 - 1] = 1;
                }

                res.boats[n - 1] -= 1;
            }

            Boat::Horizontal(n) => {
                let end = pos.1 + n;

                if end > BOARD_SIZE || res.boats[n - 1] == 0 {
                    return Err(Error::OutOfBounds);
                }

                for i in pos.1..end {
                    if res.data[pos.0 - 1][i - 1] != 0 {
                        return Err(Error::Overlap);
                    }

                    res.data[pos.0 - 1][i - 1] = 1;
                }

                res.boats[n - 1] -= 1;
            }
        }

        Ok(res)
    }

    /* converte la board in una stringa salvabile su file */
    pub fn to_string(&self) -> String {
        let header = self
            .boats
            .iter()
            .map(ToString::to_string)
            .collect::<Vec<_>>()
            .join(" ");

        let data = self
            .data
            .iter()
            .map(|line| {
                line.iter()
                    .map(|x| if *x == 0 { " " } else { "B" })
                    .collect::<Vec<_>>()
                    .concat()
            })
            .collect::<Vec<_>>()
            .join("\n");

        [header, data].join("\n")
    }
}
