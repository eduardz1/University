#![allow(dead_code, unused_imports)]

use std::sync::{Arc, Condvar, Mutex};
use std::thread;
use std::time::Duration;

enum ChannelState {
    Open,
    Closed,
}

struct MpMCChannelBuffer<E: Send> {
    state: ChannelState,
    data: Vec<E>,
}
struct MpMcChannel<E: Send> {
    buffer: Mutex<MpMCChannelBuffer<E>>,
    buf_size: usize,
    cv: Condvar,
}

impl<E: Send> MpMcChannel<E> {
    pub fn new(n: usize) -> Self {
        MpMcChannel {
            buffer: Mutex::new(MpMCChannelBuffer {
                state: ChannelState::Open,
                data: Vec::new(),
            }),
            buf_size: n,
            cv: Condvar::new(),
        }
    }

    pub fn send(&self, e: E) -> Option<()> {
        let mut buf = match self.buffer.lock() {
            Ok(guard) => guard,
            Err(_) => return None,
        };

        while buf.data.len() >= self.buf_size && matches!(buf.state, ChannelState::Open) {
            buf = match self.cv.wait(buf) {
                Ok(guard) => guard,
                Err(_) => return None,
            };
        }

        match buf.state {
            ChannelState::Open => {
                buf.data.push(e);
                self.cv.notify_one();
                Some(())
            }
            ChannelState::Closed => None,
        }
    }

    pub fn recv(&self) -> Option<E> {
        let mut buf = match self.buffer.lock() {
            Ok(guard) => guard,
            Err(_) => return None,
        };

        while buf.data.is_empty() && matches!(buf.state, ChannelState::Open) {
            buf = match self.cv.wait(buf) {
                Ok(guard) => guard,
                Err(_) => return None,
            };
        }

        if !buf.data.is_empty() {
            let e = buf.data.remove(0);
            self.cv.notify_one();
            Some(e)
        } else {
            None
        }
    }

    pub fn shutdown(&self) -> Option<()> {
        let mut buf = match self.buffer.lock() {
            Ok(guard) => guard,
            Err(_) => return None,
        };

        buf.state = ChannelState::Closed;
        self.cv.notify_all();
        Some(())
    }
}

fn main() {
    println!("MP-MC Channel implementation");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_producer_consumer() {
        let channel = Arc::new(MpMcChannel::new(3));
        let num_producers = 5;
        let num_consumers = 3;
        let items_per_producer = 10;

        let mut handles = vec![];

        // Spawn producers
        for prod_id in 0..num_producers {
            let chan = Arc::clone(&channel);
            handles.push(thread::spawn(move || {
                for i in 0..items_per_producer {
                    let value = prod_id * 100 + i;
                    chan.send(value).expect("Failed to send");
                    println!("Producer {} sent: {}", prod_id, value);
                    thread::sleep(Duration::from_millis(10));
                }
                println!("Producer {} finished", prod_id);
            }));
        }

        // Spawn consumers
        for cons_id in 0..num_consumers {
            let chan = Arc::clone(&channel);
            handles.push(thread::spawn(move || {
                let mut count = 0;
                loop {
                    match chan.recv() {
                        Some(value) => {
                            println!("Consumer {} received: {}", cons_id, value);
                            count += 1;
                            thread::sleep(Duration::from_millis(15));
                        }
                        None => {
                            println!("Consumer {} stopping (received {} items)", cons_id, count);
                            break;
                        }
                    }
                }
            }));
        }

        // Wait for producers to finish
        for handle in handles.drain(0..num_producers) {
            handle.join().unwrap();
        }

        // Shutdown channel
        thread::sleep(Duration::from_millis(100));
        channel.shutdown().expect("Failed to shutdown");
        println!("Channel shutdown");

        // Wait for consumers to finish
        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_bounded_buffer() {
        let channel = Arc::new(MpMcChannel::new(2));

        // Fill the buffer
        channel.send(1).unwrap();
        channel.send(2).unwrap();

        // This should block until space is available
        let chan = Arc::clone(&channel);
        let sender = thread::spawn(move || {
            println!("Attempting to send 3 (should block)...");
            chan.send(3).unwrap();
            println!("Successfully sent 3");
        });

        thread::sleep(Duration::from_millis(100));

        // Free up space
        let value = channel.recv().unwrap();
        println!("Received: {}", value);

        sender.join().unwrap();
    }

    #[test]
    fn test_shutdown_blocks_send() {
        let channel = Arc::new(MpMcChannel::new(3));

        channel.send(1).unwrap();
        channel.shutdown().unwrap();

        // Send after shutdown should return None
        assert!(channel.send(2).is_none());
    }

    #[test]
    fn test_shutdown_blocks_recv() {
        let channel = Arc::new(MpMcChannel::new(3));

        channel.send(1).unwrap();
        channel.shutdown().unwrap();

        // Should still return the value that was sent before shutdown
        assert_eq!(channel.recv(), Some(1));
        // Now buffer is empty, so should return None
        assert!(channel.recv().is_none());
    }

    #[test]
    fn test_shutdown_wakes_waiting_producers() {
        let channel = Arc::new(MpMcChannel::new(1));

        channel.send(1).unwrap();

        let chan = Arc::clone(&channel);
        let sender = thread::spawn(move || {
            // This will block since buffer is full
            chan.send(2)
        });

        thread::sleep(Duration::from_millis(50));
        channel.shutdown().unwrap();

        // Sender should wake up and return None
        assert!(sender.join().unwrap().is_none());
    }

    #[test]
    fn test_shutdown_wakes_waiting_consumers() {
        let channel: Arc<MpMcChannel<i32>> = Arc::new(MpMcChannel::new(3));

        let chan = Arc::clone(&channel);
        let receiver = thread::spawn(move || {
            // This will block since buffer is empty
            chan.recv()
        });

        thread::sleep(Duration::from_millis(50));
        channel.shutdown().unwrap();

        // Receiver should wake up and return None
        assert!(receiver.join().unwrap().is_none());
    }

    #[test]
    fn test_single_producer_single_consumer() {
        let channel = Arc::new(MpMcChannel::new(5));
        let chan_recv = Arc::clone(&channel);

        let producer = thread::spawn(move || {
            for i in 0..10 {
                channel.send(i).unwrap();
            }
        });

        let consumer = thread::spawn(move || {
            let mut received = vec![];
            for _ in 0..10 {
                if let Some(val) = chan_recv.recv() {
                    received.push(val);
                }
            }
            received
        });

        producer.join().unwrap();
        let received = consumer.join().unwrap();

        assert_eq!(received.len(), 10);
    }

    #[test]
    fn test_empty_channel_shutdown() {
        let channel: Arc<MpMcChannel<i32>> = Arc::new(MpMcChannel::new(3));

        // Shutdown empty channel should work
        assert!(channel.shutdown().is_some());
        assert!(channel.recv().is_none());
    }

    #[test]
    fn test_multiple_shutdown_calls() {
        let channel: Arc<MpMcChannel<i32>> = Arc::new(MpMcChannel::new(3));

        assert!(channel.shutdown().is_some());
        assert!(channel.shutdown().is_some());
    }
}
