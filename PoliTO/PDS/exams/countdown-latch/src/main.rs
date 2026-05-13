use std::sync::{Condvar, Mutex};

struct CountdownLatch {
    cv: Condvar,
    counter: Mutex<usize>,
}

impl CountdownLatch {
    fn new(counter: usize) -> Self {
        Self {
            cv: Condvar::new(),
            counter: Mutex::new(counter),
        }
    }

    fn countdown(&self) {
        let mut guard = self.counter.lock().unwrap();
        if *guard > 0 {
            *guard -= 1
        }

        self.cv.notify_all();
    }

    fn r#await(&self) {
        let mut guard = self.counter.lock().unwrap();

        while *guard > 0 {
            guard = self.cv.wait(guard).unwrap();
        }
    }
}

fn main() {
    println!("Hello, world!");
}
