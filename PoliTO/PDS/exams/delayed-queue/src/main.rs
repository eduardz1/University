use std::sync::Arc;
use std::thread;

use std::{
    sync::{Condvar, Mutex},
    time::Instant,
};

/// DelayedQueue è un particolare tipo di coda non limitata che offre tre
/// metodi, oltre alla funzione costruttrice.
///
/// Si abbia cura di rendere il comportamento thread-safe.
struct DelayedQueue<T> {
    queue: Mutex<Vec<(T, Instant)>>,
    cv: Condvar,
}

impl<T> DelayedQueue<T> {
    fn new() -> DelayedQueue<T> {
        DelayedQueue {
            queue: Mutex::new(Vec::new()),
            cv: Condvar::new(),
        }
    }

    /// Inserisce l'elemento t che non potrà essere estratto prima dell'instante
    /// di scadenza i.
    fn offer(&self, t: T, i: Instant) {
        let mut queue = self.queue.lock().unwrap();
        queue.push((t, i));
        self.cv.notify_all();
    }

    /// Cerca l'elemento t con scadenza più ravvicinata:
    /// - se tale scadenza è già stata oltrepassata, restituisce Some(t)
    /// - se la scadenza non è ancora stata superata, attende senza consumare
    ///   cicli di CPU, che tale tempo trascorra, per poi verificare nuovamente
    ///   lo stato della coda.
    /// - se non è presente nessun elemento in coda, restituisce None.
    ///
    /// Se, durante l'attesa, avviene un cambiamento qualisasi al contenuto
    /// della coda, ripete il procedimento suddetto con il nuovo elemento a
    /// scadenza più ravvicinata (ammesso che ci sia).
    fn take(&self) -> Option<T> {
        let mut queue = self.queue.lock().unwrap();

        loop {
            if queue.is_empty() {
                return None;
            }

            let (index, &(_, deadline)) = queue
                .iter()
                .enumerate()
                .min_by_key(|&(_, &(_, d))| d)
                .unwrap();

            let now = Instant::now();

            if now >= deadline {
                let (t, _) = queue.remove(index);
                return Some(t);
            } else {
                let wait_duration = deadline - now;
                println!("Attesa fino a {:?}", wait_duration);
                let (new_queue, _) = self.cv.wait_timeout(queue, wait_duration).unwrap();
                queue = new_queue;
            }
        }
    }

    /// Restituisce il numero di elementi in coda, indipendentemente dal fatto
    /// che siano scaduti o meno.
    fn size(&self) -> usize {
        let queue = self.queue.lock().unwrap();
        queue.len()
    }
}

fn main() {
    let queue = Arc::new(DelayedQueue::new());

    // Producer threads
    let mut handles = vec![];

    for i in 0..3 {
        let q = Arc::clone(&queue);
        let handle = thread::spawn(move || {
            for j in 0..5 {
                let delay = std::time::Duration::from_secs((i * 2 + j) as u64);
                q.offer(format!("Task-{}-{}", i, j), Instant::now() + delay);
                println!("Producer {} added task {}", i, j);
                thread::sleep(std::time::Duration::from_millis(100));
            }
        });
        handles.push(handle);
    }

    // Consumer threads
    for i in 0..2 {
        let q = Arc::clone(&queue);
        let handle = thread::spawn(move || {
            loop {
                match q.take() {
                    Some(task) => {
                        println!("Consumer {} executed: {}", i, task);
                    }
                    None => {
                        println!("Consumer {} found empty queue, checking size...", i);
                        thread::sleep(std::time::Duration::from_millis(500));
                        if q.size() == 0 {
                            println!("Consumer {} exiting", i);
                            break;
                        }
                    }
                }
            }
        });
        handles.push(handle);
    }

    // Monitor thread
    let q = Arc::clone(&queue);
    let monitor = thread::spawn(move || {
        for _ in 0..15 {
            println!("Queue size: {}", q.size());
            thread::sleep(std::time::Duration::from_secs(1));
        }
    });
    handles.push(monitor);

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Final queue size: {}", queue.size());
}
