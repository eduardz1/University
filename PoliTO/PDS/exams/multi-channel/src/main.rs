use std::{
    sync::{
        Mutex,
        mpsc::{Receiver, SendError, Sender, channel},
    },
    thread,
};

struct MultiChannel {
    channels: Mutex<Vec<Sender<u8>>>,
}

impl MultiChannel {
    /// Crea un nuovo canale sneza alcun ricevitore collegato.
    fn new() -> Self {
        MultiChannel {
            channels: Mutex::new(Vec::new()),
        }
    }

    /// Collega un nuovo ricevitore al canale: da quando questo metodo viene
    /// invocato, gli eventuali byte inviati al canale saranno recapitati al
    /// ricevitore. Se il ricevitore viene eliminitato, il canale continuera a
    /// funzionare inviando i propri dati ai ricevitori restanti (se presenti),
    ///  altrimenti ritornera un errore
    fn subscribe(&self) -> Receiver<u8> {
        let (tx, rx) = channel();
        self.channels.lock().unwrap().push(tx);
        rx
    }

    /// Invia a tutti i sottoscrittori un byte. Se non c'e alcun sottoscrittore,
    /// notifica l' errore indicando il byte che non e stato trasmesso.
    fn send(&self, data: u8) -> Result<(), SendError<u8>> {
        let channels = self.channels.lock().unwrap();
        if channels.is_empty() {
            return Err(SendError(data));
        }
        for channel in channels.iter() {
            let _ = channel.send(data);
        }
        Ok(())
    }
}

fn main() {
    let mut handles = vec![];

    {
        let multi_channel = MultiChannel::new();

        let rx1 = multi_channel.subscribe();
        handles.push(thread::spawn(move || {
            while let Ok(data) = rx1.recv() {
                println!("Subscriber 1 received: {}", data)
            }
        }));

        let rx2 = multi_channel.subscribe();
        handles.push(thread::spawn(move || {
            while let Ok(data) = rx2.recv() {
                println!("Subscriber 2 received: {}", data)
            }
        }));

        multi_channel.send(10).unwrap();
        multi_channel.send(20).unwrap();
        multi_channel.send(30).unwrap();
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
