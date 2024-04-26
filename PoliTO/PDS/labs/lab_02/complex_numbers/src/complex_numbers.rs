use std::{
    hash::{Hash, Hasher},
    ops::{Add, AddAssign},
};

#[derive(Default, PartialEq, PartialOrd, Debug, Clone, Copy)]
pub struct ComplexNumber {
    real: f64,
    imag: f64,
}

impl ComplexNumber {
    pub fn new(real: f64, imag: f64) -> Self {
        Self { real, imag }
    }

    pub fn from_real(real: f64) -> Self {
        Self { real, imag: 0.0 }
    }

    pub fn to_tuple(&self) -> (f64, f64) {
        (self.real, self.imag)
    }

    pub fn real(&self) -> f64 {
        self.real
    }

    pub fn imag(&self) -> f64 {
        self.imag
    }

    pub fn norm(&self) -> f64 {
        (self.real * self.real + self.imag * self.imag).sqrt()
    }
}

impl Add for ComplexNumber {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        Self {
            real: self.real + rhs.real(),
            imag: self.imag + rhs.imag(),
        }
    }
}

impl Into<ComplexNumber> for f64 {
    fn into(self) -> ComplexNumber {
        ComplexNumber::from_real(self)
    }
}

impl Into<f64> for ComplexNumber {
    fn into(self) -> f64 {
        if self.imag == 0.0 {
            self.real
        } else {
            panic!("Cannot convert complex number with non-zero imaginary part to f64")
        }
    }
}

// impl TryInto<f64> for ComplexNumber {
//     type Error = &'static str;

//     fn try_into(self) -> Result<f64, Self::Error> {
//         if self.imag == 0.0 {
//             Ok(self.real)
//         } else {
//             Err("Cannot convert complex number with non-zero imaginary part to f64")
//         }
//     }
// }

impl<'a> Add<&'a ComplexNumber> for ComplexNumber {
    type Output = Self;

    fn add(self, rhs: &'a ComplexNumber) -> Self::Output {
        Self {
            real: self.real + rhs.real(),
            imag: self.imag + rhs.imag(),
        }
    }
}

impl Add<&ComplexNumber> for &ComplexNumber {
    type Output = ComplexNumber;

    fn add(self, rhs: &ComplexNumber) -> Self::Output {
        ComplexNumber {
            real: self.real + rhs.real(),
            imag: self.imag + rhs.imag(),
        }
    }
}

impl AddAssign for ComplexNumber {
    fn add_assign(&mut self, rhs: Self) {
        self.real += rhs.real();
        self.imag += rhs.imag();
    }
}

impl Add<f64> for ComplexNumber {
    type Output = Self;

    fn add(self, rhs: f64) -> Self::Output {
        Self {
            real: self.real + rhs,
            imag: self.imag,
        }
    }
}

impl Eq for ComplexNumber {}

impl Ord for ComplexNumber {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.norm().total_cmp(&other.norm())
    }
}

impl AsRef<f64> for ComplexNumber {
    fn as_ref(&self) -> &f64 {
        &self.real
    }
}

impl AsMut<f64> for ComplexNumber {
    fn as_mut(&mut self) -> &mut f64 {
        &mut self.real
    }
}

impl Hash for ComplexNumber {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.real.to_bits().hash(state);
        self.imag.to_bits().hash(state);
    }
}
