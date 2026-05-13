use std::{
    collections::HashMap,
    sync::{Arc, Condvar, Mutex},
    thread,
};

struct Joiner {
    capacity: usize, // Initialized once so no need for mutex
    state: Mutex<(HashMap<i32, f64>, usize)>,
    cv: Condvar,
}

impl Joiner {
    fn new(n: usize) -> Self {
        Self {
            capacity: n,
            state: Mutex::new((HashMap::with_capacity(n), 0)),
            cv: Condvar::new(),
        }
    }

    fn supply(&self, key: i32, value: f64) -> HashMap<i32, f64> {
        let mut guard = self.state.lock().unwrap();

        // Wait for cleanup to be completed
        guard = self
            .cv
            .wait_while(guard, |(_, counter)| *counter != 0)
            .unwrap();

        guard.0.insert(key, value);

        if guard.0.len() == self.capacity {
            self.cv.notify_all();
        }

        guard = self
            .cv
            .wait_while(guard, |(map, _)| map.len() < self.capacity)
            .unwrap();

        let result = guard.0.clone();
        guard.1 += 1;

        // Only last one clears the map
        if guard.1 == self.capacity {
            guard.0.clear();
            guard.1 = 0;
            self.cv.notify_all();
        }

        result
    }
}

fn main() {
    let joiner = Arc::new(Joiner::new(10));

    let mut handles = vec![];

    for i in 0..10 {
        let joiner = Arc::clone(&joiner);
        handles.push(thread::spawn(move || {
            let res = joiner.supply(i, 5.0);
            println!("Result is {res:#?}");
        }));
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
