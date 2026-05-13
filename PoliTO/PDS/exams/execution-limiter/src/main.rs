use std::{
    panic::{UnwindSafe, catch_unwind},
    sync::{Arc, Condvar, Mutex},
    thread::{self, sleep},
    time::Duration,
};

struct ExecutionLimiter {
    limit: usize,
    curr_executions: Mutex<usize>,
    cv: Condvar,
}

impl ExecutionLimiter {
    fn new(limit: usize) -> Self {
        if limit < 1 {
            panic!("Limit must be at least 1");
        }

        Self {
            limit,
            curr_executions: Mutex::new(0),
            cv: Condvar::new(),
        }
    }

    fn execute<R, F>(&self, func: F) -> Result<R, String>
    where
        F: Fn() -> R + UnwindSafe,
    {
        let mut guard = self.curr_executions.lock().unwrap();

        guard = self
            .cv
            .wait_while(guard, |count| *count == self.limit)
            .unwrap();

        *guard += 1;
        drop(guard);

        let res = catch_unwind(func);

        let mut guard = self.curr_executions.lock().unwrap();
        *guard -= 1;

        self.cv.notify_one();

        match res {
            Ok(val) => Ok(val),
            Err(_) => Err(String::from("Function panicked")),
        }
    }
}

fn main() {
    let limiter = Arc::new(ExecutionLimiter::new(3));
    let mut handles = vec![];

    for i in 0..12 {
        let l = Arc::clone(&limiter);
        handles.push(thread::spawn(move || {
            let res = l
                .execute(|| {
                    sleep(Duration::from_secs(2));
                    i
                })
                .ok()
                .unwrap();

            println!("Thread {i} returned {res}")
        }))
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
