use std::{
    sync::mpsc::{Receiver, Sender},
    thread,
};

/// Si realizzi l'implementazione della strutura dati Exchnager<T: Send> (de dei
/// metodi e dele funzioni necessarie) utile per realizzare una comunicazione
/// bidirezionale.
///
/// Ciascun lato della comunicazione dispone di un'istanza della struttura
/// Exchange<T: Send>.
///
/// Si abbia cura che l'implementazione sia thread-safe.
struct Exchanger<T: Send> {
    s: Sender<T>,
    r: Receiver<T>,
}

impl<T: Send> Exchanger<T> {
    /// Una volta invocato, si blocca fino a quando non viene invocato il metodo
    /// corrispettivo sulla struttura corrispondente al lato opposto della
    /// comunicazione, dopodiché restituisce il valore che é stato passato come
    /// argomento al metodo corrsipondente al lato pposto (che farà
    /// altrettanto), sotto frma di Some(t). Lo scambio può essere ripetuto un
    /// numero arbitrarion di volte. Se un delle due strutture formanti la
    /// coppia viene distrutta, un'eventuale chiamata, bloccata sul metodo
    /// della struttura restante, terminerà restituendo il valore None.
    fn exchange(&self, t: T) -> Option<T> {
        let _ = self.s.send(t);
        self.r.recv().ok()
    }
}

fn make_exchangers<T: Send>() -> (Exchanger<T>, Exchanger<T>) {
    let (s1, r1) = std::sync::mpsc::channel();
    let (s2, r2) = std::sync::mpsc::channel();

    return (Exchanger { s: s1, r: r2 }, Exchanger { s: s2, r: r1 });
}

fn main() {
    let (x1, x2) = make_exchangers::<i32>();
    let mut handles = vec![];

    handles.push(thread::spawn(move || {
        for i in 0..10 {
            let ret = x1.exchange(i);
            match ret {
                Some(v) => println!("Thread 1 exchanged {} for {}", i, v),
                None => println!("Thread 1 failed to exchange {}", i),
            }
        }
    }));

    handles.push(thread::spawn(move || {
        for i in 100..110 {
            let ret = x2.exchange(i);
            match ret {
                Some(v) => println!("Thread 2 exchanged {} for {}", i, v),
                None => println!("Thread 2 failed to exchange {}", i),
            }
        }
    }));

    for handle in handles {
        let _ = handle.join();
    }
}
