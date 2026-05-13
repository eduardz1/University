use std::{
    sync::mpsc::{Sender, channel},
    thread::JoinHandle,
};

struct Looper<Message: Send> {
    sender: Option<Sender<Message>>,
    thread_hanlde: Option<JoinHandle<()>>,
}

impl<Message: Send + 'static> Looper<Message> {
    pub fn new<F, G>(process: F, cleanup: G) -> Self
    where
        F: Fn(Message) -> () + 'static + Send,
        G: Fn() -> () + 'static + Send,
    {
        let (sender, receiver) = channel::<Message>();
        Looper {
            sender: Some(sender),
            thread_hanlde: Some(std::thread::spawn(move || {
                while let Ok(message) = receiver.recv() {
                    process(message)
                }
                cleanup()
            })),
        }
    }

    pub fn send(&self, msg: Message) {
        self.sender.as_ref().unwrap().send(msg).unwrap();
    }
}

impl<Message: Send> Drop for Looper<Message> {
    fn drop(&mut self) {
        self.sender.take().unwrap();
        self.thread_hanlde.take().unwrap().join().unwrap();
    }
}

fn main() {
    let process = |number: usize| {
        println!("Thread {number} sent to the looper");
    };

    let cleanup = || println!("Cleaning up");
    let looper = Looper::new(process, cleanup);

    for i in 0..5 {
        looper.send(i);
    }

    // Looper will be dropped here, triggering cleanup
}
