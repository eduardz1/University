pub struct CircularBuffer<T> {
    buffer: Vec<T>,
    head: usize,
    tail: usize,
    size: usize,
}

impl<T> CircularBuffer<T> {
    pub fn head(&self) -> usize {
        self.head
    }

    pub fn tail(&self) -> usize {
        self.tail
    }

    pub fn size(&self) -> usize {
        self.size
    }

    pub fn new(capacity: usize) -> Self {
        Self {
            buffer: Vec::<T>::with_capacity(capacity),
            head: 0,
            tail: 0,
            size: 0,
        }
    }

    pub fn write(&mut self, item: T) -> Result<(), &'static str> {
        if self.size >= self.buffer.capacity() {
            return Err("Buffer full");
        }

        self.buffer.push(item);
        self.tail += 1;
        self.size += 1;
        Ok(())
    }

    pub fn read(&mut self) -> Option<&T> {
        let new_head = (self.head + 1) % self.buffer.capacity();
        let res = self.buffer.get(self.head);
        self.head = new_head;
        self.size -= 1;
        res
    }

    pub fn clear(&mut self) {
        self.buffer.clear();
        self.head = 0;
        self.tail = 0;
        self.size = 0;
    }

    pub fn overwrite(&mut self, item: T) {
        if self.size >= self.buffer.capacity() {
            self.buffer.pop();
        }

        let _ = self.write(item);
    }

    pub fn make_contiguous(&mut self) {
        if self.head > self.tail {
            self.buffer.shrink_to_fit();
            self.head = 0;
            self.tail = self.size;
        }
    }
}
