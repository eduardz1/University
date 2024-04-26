use std::collections::VecDeque;

use complex_numbers::complex_numbers::ComplexNumber;

// for this execise see https://doc.rust-lang.org/beta/std/primitive.f64.html
// you can find examples for all the traits that must be implemented

#[test]
pub fn test_create() {
    let a = ComplexNumber::new(1.0, 2.0);
    assert_eq!(a.real(), 1.0);
    assert_eq!(a.imag(), 2.0);
}

#[test]
pub fn test_create_from_real() {
    let a = ComplexNumber::from_real(10.0);
    assert_eq!(a.real(), 10.0);
    assert_eq!(a.imag(), 0.0);
}

#[test]
pub fn test_add() {
    // implement Add trait
    // rember to set: type Output = Self;
    // see: https://github.com/pretzelhammer/rust-blog/blob/master/posts/tour-of-rusts-standard-library-traits.md#add--addassign

    let a = ComplexNumber::new(1.0, 2.0);
    let b = ComplexNumber::new(1.0, 2.0);

    let c = a + b;

    assert_eq!(c.to_tuple(), (2.0, 4.0));
}

#[test]
pub fn test_add_with_real() {
    // set RHS (rihgt hand side) type for Add!!! It's default value is Self, but it can be changed to anything
    let a = ComplexNumber::new(1.0, 2.0);
    let b = a + 10.0;

    assert_eq!(b.to_tuple(), (11.0, 2.0))
}

#[test]
pub fn test_inc_add() {
    let mut a = ComplexNumber::new(1.0, 2.0);
    a += ComplexNumber::new(2.0, 4.0);

    assert_eq!(a.to_tuple(), (3.0, 6.0))
}

#[test]
pub fn test_add_with_reference() {
    // references for Rust are new types: you must define the trait for them as RHS
    let a = ComplexNumber::new(1.0, 2.0);
    let b = ComplexNumber::new(1.0, 2.0);

    let c = a + &b;

    assert_eq!(c.to_tuple(), (2.0, 4.0))
}

#[test]
pub fn test_add_reference_with_reference() {
    // references for Rust are new types: you must define the trait for them as RHS
    let a = ComplexNumber::new(1.0, 2.0);
    let b = ComplexNumber::new(1.0, 2.0);

    let c = &a + &b;

    assert_eq!(c.to_tuple(), (2.0, 4.0))
}

#[test]
pub fn test_enable_copy() {
    // why this code won't compile? Read carefully the error message
    // what do we nee to do to make it work?
    let a = ComplexNumber::new(1.0, 2.0);

    let b = a + a;

    assert_eq!(b.to_tuple(), (2.0, 4.0));
}

#[test]
pub fn test_default_values() {
    // If we want to create an array of complex numbers we need to initialize values with something
    // Arrays can't be not initialized in Rust
    let array: [ComplexNumber; 10] = Default::default();

    for el in array.as_slice() {
        assert_eq!(el.to_tuple(), (0.0, 0.0));
    }
}

#[test]
pub fn test_convert_into_real() {
    let a = ComplexNumber::from_real(1.0);
    let b: f64 = a.into();

    assert_eq!(b, 1.0);
}

#[test]
pub fn test_panic_when_impossible_to_convert_to_real() {
    // we can convert into a real only if imag is 0
    let a = ComplexNumber::new(1.0, 2.0);

    let result = std::panic::catch_unwind(|| {
        let _: f64 = a.into();
    });

    assert!(result.is_err());
}

#[test]
pub fn test_try_into_f64() {
    // FIXME: conflicts with into f64
    // let a = ComplexNumber::new(1.0, 2.0);
    // let b = ComplexNumber::new(1.0, 0.0);

    // let result: Result<f64, _> = a.try_into();
    // let result2: Result<f64, _> = b.try_into();

    // assert!(result.is_err());
    // assert_eq!(result2.unwrap(), 1.0);
}

#[test]
pub fn test_try_form_f64() {
    let a: ComplexNumber = 1.0.into();

    assert_eq!(a.to_tuple(), (1.0, 0.0));
}

#[test]
pub fn test_comparison() {
    let c = ComplexNumber::new(3.0, 6.0);
    let mut v = vec![
        ComplexNumber::new(1.0, 2.0),
        ComplexNumber::new(2.0, 4.0),
        c,
    ];

    v.retain(|el| *el == c);

    assert_eq!(v.len(), 1);
}

#[test]
pub fn test_sorting() {
    // for sorting we can use the modulus of a complex number
    // https://www.cuemath.com/algebra/modulus-of-complex-number/
    // if |a| > |b| than a > b

    // Be careful: f64 does not implement Ord since NaN != NaN and you can't
    // use cmp from f64 to implement Ord for ComplexNumber
    // However f64 has total_cmp which produces total ordering
    // https://doc.rust-lang.org/beta/std/primitive.f64.html#method.total_cmp

    let a = ComplexNumber::new(1.0, 2.0);
    let b = ComplexNumber::new(2.0, 4.0);
    let c = ComplexNumber::new(3.0, 6.0);
    let mut v = vec![c, b, a];

    v.sort();

    assert_eq!(v[0], a);
    assert_eq!(v[1], b);
    assert_eq!(v[2], c);
}

#[test]
pub fn test_as_ref() {
    // implement AsRef<f64> for ComplexNumber
    // allow a mutable ref to real part as &f64

    let a = ComplexNumber::new(1.0, 2.0);
    let r = a.as_ref();

    assert_eq!(*r, 1.0);
}

#[test]
pub fn test_as_mut() {
    // implement AsMut<f64> for ComplexNumber
    // allow a mutable ref to real part as &mut f64

    let mut a = ComplexNumber::new(1.0, 2.0);
    let r = a.as_mut();

    *r = 10.0;

    assert_eq!(a.real(), 10.0);
}

#[test]
pub fn test_hash_with_hash_map() {
    // in order to use comeplex numbers in a hash map we need to implement Hash
    // https://github.com/pretzelhammer/rust-blog/blob/master/posts/tour-of-rusts-standard-library-traits.md#hash
    // we can use the to_bits method from f64 to get a u64 representation of the float
    let a = ComplexNumber::new(1.0, 2.0);
    let b = ComplexNumber::new(2.0, 4.0);
    let c: ComplexNumber = 3.0.into();

    let mut map = std::collections::HashMap::new();

    // first insert must return None: not present
    match map.insert(a, b) {
        None => assert!(true),
        Some(_) => assert!(false),
    };

    // trty ro replace value with c
    match map.insert(a, c) {
        None => assert!(false),
        Some(x) => assert_eq!(x.to_tuple(), (2.0, 4.0)), // should return the old value, b
    };
}

#[test]
pub fn test_deque() {
    // implement VecDeque for ComplexNumber
    // 1. create a VecDeque with capacity 10
    // 2. push 10 values in the deque
    // 4. find the index of a value with binary_search: it works only if the deque is sorted!!!
    // 5. check the result: it should be meaningless
    // 3. sort the deque and check again the result of binary_search, now it should be meaningful

    let mut deque: VecDeque<ComplexNumber> = VecDeque::with_capacity(10);
    deque.push_back(ComplexNumber::new(8.0, 16.0));
    deque.push_back(ComplexNumber::new(2.0, 4.0));
    deque.push_back(ComplexNumber::new(4.0, 8.0));
    deque.push_back(ComplexNumber::new(5.0, 10.0));
    deque.push_back(ComplexNumber::new(3.0, 6.0));
    deque.push_back(ComplexNumber::new(6.0, 12.0));
    deque.push_back(ComplexNumber::new(7.0, 14.0));
    deque.push_back(ComplexNumber::new(9.0, 18.0));
    deque.push_back(ComplexNumber::new(10.0, 20.0));
    deque.push_back(ComplexNumber::new(1.0, 2.0));

    let index = deque.binary_search(&ComplexNumber::new(5.0, 10.0));
    assert_ne!(index, Ok(4));

    // sort the deque
    deque.make_contiguous().sort();
    let index = deque.binary_search(&ComplexNumber::new(5.0, 10.0));
    assert_eq!(index, Ok(4));
}
