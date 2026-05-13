use std::sync::{Condvar, Mutex};

struct BarrierState {
    counter: usize,
    generation: usize,
}

struct RankingBarrier {
    rank: usize,
    state: Mutex<BarrierState>,
    condvar: Condvar,
}

impl RankingBarrier {
    pub fn new(rank: usize) -> Self {
        if rank < 2 {
            panic!("Rank must be at least 2");
        }
        RankingBarrier {
            rank,
            state: Mutex::new(BarrierState {
                counter: 0,
                generation: 0,
            }),
            condvar: Condvar::new(),
        }
    }

    pub fn wait(&self) -> usize {
        let mut state = self.state.lock().unwrap();

        state.counter += 1;
        let my_rank = state.counter;

        if state.counter == self.rank {
            state.counter = 0;
            state.generation += 1;
            self.condvar.notify_all();
            my_rank
        } else {
            let my_generation = state.generation;
            while state.generation == my_generation {
                state = self.condvar.wait(state).unwrap();
            }
            my_rank
        }
    }
}

fn main() {
    // Example usage of RankingBarrier
    let barrier = std::sync::Arc::new(RankingBarrier::new(3));
    let mut handles = vec![];

    for i in 0..3 {
        let cbarrier = barrier.clone();
        let handle = std::thread::spawn(move || {
            println!("Thread {} waiting at barrier", i);
            let rank = cbarrier.wait();
            println!("Thread {} passed barrier with rank {}", i, rank);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
