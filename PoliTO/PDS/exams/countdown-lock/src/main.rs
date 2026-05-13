use std::{
    sync::{Arc, Condvar, Mutex, WaitTimeoutResult},
    time::Duration,
};

/// Si implementi la struct CountDownLock che permette a uno o più thread di
/// attendere che un gruppo di operazioni eeguite da altri thread siano
/// eseguite.
///
/// Essa incapsula un contatore.
struct CountDownLock {
    counter: Mutex<usize>,
    cv: Condvar, // Perché dice "senza consumare cicli di CPU"
}

impl CountDownLock {
    /// Inizializza la struttura, impostando ad n il contatore
    fn new(n: usize) -> Self {
        CountDownLock {
            counter: Mutex::new(n),
            cv: Condvar::new(),
        }
    }

    /// Decrementa il contatore, se maggiore di zero.
    fn count_down(&self) {
        let mut count = self.counter.lock().unwrap();
        if *count <= 0 {
            return;
        }
        *count -= 1;
        if *count == 0 {
            self.cv.notify_all();
        }
    }

    /// Blocca l'esecuzione del chiamante senza consumare cicli di CPU, finché
    /// il contatore non diventa zero.
    fn wait(&self) {
        let mut count = self.counter.lock().unwrap();
        // It's better to use wait_while to avoid spurious wakeups
        count = self.cv.wait_while(count, |c| *c > 0).unwrap();
        match *count {
            0 => (),
            _ => unreachable!(),
        }
    }

    /// Blocca l'esecuzione del chiamante senza consumare cicli di CPU, in
    /// attesa che il contatore raggiunga 0 per una durata massima pari a d,
    /// restituendo il risultato dell'attesa.
    fn wait_timeout(&self, d: Duration) -> WaitTimeoutResult {
        let count = self.counter.lock().unwrap();
        self.cv.wait_timeout_while(count, d, |c| *c > 0).unwrap().1
    }
}

fn main() {
    let cdl1 = Arc::new(CountDownLock::new(3));

    let handles: Vec<_> = (0..3)
        .map(|i| {
            let lock_clone = Arc::clone(&cdl1);
            std::thread::spawn(move || {
                println!("Thread {} esegue operazione...", i);
                // Simula un'operazione
                std::thread::sleep(Duration::from_millis(100 * (i + 1) as u64));
                println!("Thread {} ha completato l'operazione.", i);
                lock_clone.count_down();
            })
        })
        .collect();

    println!("Main thread in attesa che tutte le operazioni siano completate...");
    cdl1.wait();
    println!("Tutte le operazioni sono state completate.");

    for handle in handles {
        handle.join().unwrap();
    }

    let cdl2 = Arc::new(CountDownLock::new(2));

    let handles = (0..2)
        .map(|i| {
            let lock_clone = Arc::clone(&cdl2);
            std::thread::spawn(move || {
                println!("Thread {} esegue operazione...", i);
                // Simula un'operazione
                std::thread::sleep(Duration::from_millis(200 * (i + 1) as u64));
                println!("Thread {} ha completato l'operazione.", i);
                lock_clone.count_down();
            })
        })
        .collect::<Vec<_>>();

    if cdl2.wait_timeout(Duration::from_millis(250)).timed_out() {
        println!("Timeout raggiunto prima che tutte le operazioni fossero completate.");
    } else {
        println!("Tutte le operazioni sono state completate entro il timeout.");
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
