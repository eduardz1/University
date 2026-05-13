// Un CancelableEvent è un meccanismo di sincronizzazione che permette ad un thread di attendere il completamento
// di un insieme di operazioni eseguite da altri thread, con la possibilità di cancellazione anticipata.

// Alla creazione, viene specificato il numero di operazioni da attendere. La struttura offre:

// signal(): segnala il completamento di un'operazione
// cancel(): annulla l'attesa (tutti i thread in attesa vengono svegliati immediatamente)
// wait(): attende il completamento di tutte le operazioni o una cancellazione
// wait_timeout(d: Duration): attende con un timeout massimo

use std::{
    sync::{Arc, Condvar, Mutex},
    thread::{self, sleep},
    time::Duration,
};

#[derive(PartialEq, Eq, Debug, Clone, Copy)]
pub enum WaitResult {
    Completed,
    Timeout,
    Canceled,
}

pub struct CancelableEventStruct {
    count: usize,
    cv: Condvar,
    waiting: Mutex<usize>,
    res: Mutex<(WaitResult, usize)>,
}

pub trait CancelableEvent {
    fn new(count: usize) -> Self;

    fn signal(&self);

    fn cancel(&self);

    fn wait(&self) -> WaitResult;

    fn wait_timeout(&self, d: Duration) -> WaitResult;
}

impl CancelableEvent for CancelableEventStruct {
    fn new(count: usize) -> Self {
        Self {
            count,
            cv: Condvar::new(),
            waiting: Mutex::new(0),
            res: Mutex::new((WaitResult::Completed, 0)),
        }
    }

    fn signal(&self) {
        let mut guard = self.res.lock().unwrap();
        guard.1 += 1;
        self.cv.notify_all();
    }

    fn cancel(&self) {
        let mut guard = self.res.lock().unwrap();
        guard.0 = WaitResult::Canceled;
        self.cv.notify_all();
    }

    fn wait(&self) -> WaitResult {
        let mut guard = self.res.lock().unwrap();
        let mut waiting = self.waiting.lock().unwrap();
        *waiting += 1;
        drop(waiting);

        guard = self
            .cv
            .wait_while(guard, |res| {
                res.0 != WaitResult::Canceled && res.1 < self.count
            })
            .unwrap();

        let mut waiting = self.waiting.lock().unwrap();
        *waiting -= 1;

        if *waiting == 0 {
            guard.1 = 0;
        }

        guard.0
    }

    fn wait_timeout(&self, d: Duration) -> WaitResult {
        let mut guard = self.res.lock().unwrap();
        let mut waiting = self.waiting.lock().unwrap();
        *waiting += 1;
        drop(waiting);

        let res = self
            .cv
            .wait_timeout_while(guard, d, |res| {
                res.0 != WaitResult::Canceled && res.1 < self.count
            })
            .unwrap();

        guard = res.0;

        let mut waiting = self.waiting.lock().unwrap();
        *waiting -= 1;

        if *waiting == 0 {
            guard.1 = 0;
        }

        if res.1.timed_out() {
            return WaitResult::Timeout;
        }

        guard.0
    }
}

fn main() {
    let mut handles = vec![];
    let ce = Arc::new(CancelableEventStruct::new(3));

    for i in 0..4 {
        let ce_th = ce.clone();
        handles.push(thread::spawn(move || {
            println!("Thread {i} is sleeping...");
            ce_th.wait();
            println!("Thread {i} has awaken!");
        }));
    }

    for i in 4..7 {
        let ce_th = ce.clone();
        handles.push(thread::spawn(move || {
            sleep(Duration::from_secs(1));
            println!("Thread {i} is signalling!");
            ce_th.signal();
        }));
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
