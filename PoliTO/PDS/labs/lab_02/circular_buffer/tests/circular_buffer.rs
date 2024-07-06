use circular_buffer::circular_buffer::CircularBuffer;

#[test]
fn test_insert_and_check_size() {
    let mut buffer = CircularBuffer::new(5);
    let _ = buffer.write("Test");
    assert_eq!(buffer.size(), 1);
}

#[test]
fn test_insert_read_check_same() {
    let mut buffer = CircularBuffer::new(5);
    let _ = buffer.write("Test");
    assert_eq!(buffer.read(), Some(&"Test"));
}

#[test]
fn test_insert_n_read() {
    let mut buffer = CircularBuffer::new(5);
    for i in 0..5 {
        let _ = buffer.write(i);
    }
    for i in 0..5 {
        assert_eq!(buffer.read(), Some(&i));
    }
}

#[test]
fn test_head_tail_zero() {
    let mut buffer = CircularBuffer::new(5);
    for _ in 0..5 {
        let _ = buffer.write("Test");
    }
    for _ in 0..5 {
        buffer.read();
    }
    assert_eq!(buffer.head(), 0);
    assert_eq!(buffer.tail(), 0);
}

#[test]
fn test_read_empty() {
    let mut buffer = CircularBuffer::<i32>::new(5);
    assert_eq!(buffer.read(), None);
}

#[test]
fn test_write_full() {
    let mut buffer = CircularBuffer::new(5);
    for _ in 0..5 {
        let _ = buffer.write("Test");
    }
    assert_eq!(buffer.write(&"Test"), Err("Buffer full"));
}

#[test]
fn test_overwrite_full() {
    let mut buffer = CircularBuffer::new(5);
    for i in 0..5 {
        let _ = buffer.write(i);
    }
    buffer.overwrite(5);
    assert_eq!(buffer.read(), Some(&1));
}

#[test]
fn test_make_contiguous() {
    let mut buffer = CircularBuffer::new(5);
    for i in 0..5 {
        let _ = buffer.write(i);
    }
    buffer.read();
    let _ = buffer.write(5);
    buffer.make_contiguous();
    assert_eq!(buffer.head(), 0);
    assert_eq!(buffer.tail(), buffer.size());
}
