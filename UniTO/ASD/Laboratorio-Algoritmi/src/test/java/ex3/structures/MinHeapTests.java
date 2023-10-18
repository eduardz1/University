package ex3.structures;

import ex3.exceptions.ArgumentException;
import ex3.exceptions.ElementNotFoundException;
import ex3.exceptions.MinHeapException;
import org.junit.Test;

import java.util.*;

import static org.junit.Assert.*;

public class MinHeapTests {

  /**
   * Class used for testing purpose inside MinHeap
   */
  public class TestObject<A, B> {
    public A field1;
    public B field2;
    
    TestObject(A a, B b) {
      this.field1 = a;
      this.field2 = b;
    }
  }

  public class TestObjectComparator<A, B> implements Comparator<TestObject<A,B>> {

    public Comparator<? super B> comparator;
    
    public TestObjectComparator(Comparator<? super B> comp) {
      this.comparator = comp;
    }
  
    @Override
    public int compare(TestObject<A,B> arg0, TestObject<A,B> arg1) {
      return this.comparator.compare(arg0.field2, arg1.field2);
    }
  }
  
  @Test(expected = ArgumentException.class)
  public void createHeapWithComparatorNullThrowsException() throws ArgumentException {
    new MinHeap<String>(null);
  }

  @Test(expected = ArgumentException.class)
  public void insertNullElementThrowsException() throws ArgumentException, MinHeapException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);
    heap.insert(null);
  }

  @Test()
  public void getParentOrChildrenOnInvalidKeyThrowsException() throws ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);
    
    assertThrows(ElementNotFoundException.class, () -> heap.parent(null));
    assertThrows(ElementNotFoundException.class, () -> heap.parent(""));
    assertThrows(ElementNotFoundException.class, () -> heap.parent("abc"));
    assertThrows(ElementNotFoundException.class, () -> heap.left(null));
    assertThrows(ElementNotFoundException.class, () -> heap.left(""));
    assertThrows(ElementNotFoundException.class, () -> heap.left("abc"));
    assertThrows(ElementNotFoundException.class, () -> heap.right(null));
    assertThrows(ElementNotFoundException.class, () -> heap.right(""));
    assertThrows(ElementNotFoundException.class, () -> heap.right("abc"));
  } 

  @Test
  public void isEmptyAfterCreate() throws ArgumentException, MinHeapException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);
    assertEquals(0, heap.size());
    assertTrue(heap.isEmpty());
  }

  @Test
  public void getParentReturnsExpectedValue() throws ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    heap.insert("a");
    heap.insert("b");
    heap.insert("c");
    heap.insert("d");
    
    assertNull(heap.parent("a"));
    assertEquals("a", heap.parent("b"));
    assertEquals("a", heap.parent("c"));
    assertEquals("b", heap.parent("d"));
  }

  @Test
  public void getLeftReturnsExpectedValue() throws ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    heap.insert("a");
    heap.insert("b");
    heap.insert("c");
    heap.insert("d");
    heap.insert("e");
    
    assertEquals("b", heap.left("a"));
    assertEquals("d", heap.left("b")); 
    assertNull(heap.left("c"));
    assertNull(heap.left("d"));
    assertNull(heap.left("e"));
  }

  @Test
  public void getRightReturnsExpectedValue() throws  ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    heap.insert("a");
    heap.insert("b");
    heap.insert("c");
    heap.insert("d");
    heap.insert("e");
    
    assertEquals("c", heap.right("a"));
    assertEquals("e", heap.right("b")); 
    assertNull(heap.right("c"));
    assertNull(heap.right("d"));
    assertNull(heap.right("e"));
  }

  @Test
  public void peekReturnsExpectedValue() throws ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    assertThrows(MinHeapException.class, heap::peek);
    
    heap.insert("d");
    assertEquals("d", heap.peek());

    heap.insert("c");
    heap.insert("b");
    heap.insert("e");
    assertEquals("b", heap.peek());

    heap.increaseKeyPriority("b", "a");
    assertEquals("a", heap.peek());
    
    heap.remove();
    assertEquals("c", heap.peek());
  }

  @Test
  public void isMinHeapifiedAfterInsertSortedArray() throws ArgumentException, MinHeapException, ElementNotFoundException {

    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    assertTrue(heap.isHeapified());
    String[] els = "abcdefghijklmnopqrstuvz".split("");
    for (String el : els) {
      heap.insert(el);
      assertTrue(heap.isHeapified());
    }
  }

  @Test
  public void isMinHeapifiedAfterInsertUnsortedArray() throws ArgumentException, MinHeapException, ElementNotFoundException {

    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    List<String> els = Arrays.asList("abcdefghijklmnopqrstuvz".split(""));
    Collections.shuffle(els);

    assertTrue(heap.isHeapified());
    for (String el : els) {
      heap.insert(el);
      assertTrue(heap.isHeapified());
    }
  }

  @Test
  public void isMinHeapifiedAfterRemove() throws ArgumentException, MinHeapException, ElementNotFoundException {

    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    List<String> els = Arrays.asList("abcdefghijklmnopqrstuvz".split(""));
    Collections.shuffle(els);

    for (String el : els) {
      heap.insert(el);
    }

    assertTrue(heap.isHeapified());
    for (int i = heap.size(); i > 0; i--) {
      heap.remove();
      assertTrue(heap.isHeapified());
    }
  }

  @Test
  public void isMinHeapfiedAfterincreaseKey() throws ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);

    String[] els = {"aa", "bb", "cc", "dd", "ee"};

    for (String el : els) {
      heap.insert(el);
    }

    assertTrue(heap.isHeapified());
    for (String el : els) {
      heap.increaseKeyPriority(el, el.substring(1));
      assertTrue(heap.isHeapified());
    }

  }

  @Test 
  public void increaseKeyDecrementKeyValue() throws ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);
    
    heap.insert("d");	
    
    heap.increaseKeyPriority("d", "c");
    assertEquals(0, comp.compare("c", heap.peek()));

    heap.increaseKeyPriority("c", "b");
    assertEquals(0, comp.compare("b", heap.peek()));

    heap.increaseKeyPriority("b", "a");
    assertEquals(0, comp.compare("a", heap.peek()));
  }

  @Test
  public void isEmptyAfterRemoveLastElement() throws ArgumentException, MinHeapException {
    Comparator<String> comp = Comparator.comparing((String x) -> x);
    MinHeap<String> heap = new MinHeap<>(comp);
    heap.insert("a");
    heap.remove();
    assertEquals(0, heap.size());
    assertTrue(heap.isEmpty());
  }

  @Test
  public void isMinHeapifiedAfterInsertObject() throws ArgumentException, MinHeapException, ElementNotFoundException {
    Comparator<Integer> comp = Comparator.comparingInt((Integer x) -> x);
    TestObjectComparator<String, Integer> comparator = new TestObjectComparator<>(comp);
    MinHeap<TestObject<String, Integer>> queue = new MinHeap<>(comparator);

    List<String> els = Arrays.asList("abcdefg".split(""));
    List<TestObject<String, Integer>> objs = new ArrayList<>();
    for (int i = 0; i < els.size(); i++) {
      TestObject<String, Integer> obj = new TestObject<>(els.get(i), i);
      objs.add(obj);
    }
    Collections.shuffle(objs);

    assertTrue(queue.isHeapified());
    int inserted = 0;
    for (TestObject<String, Integer> el : objs) {
      queue.insert(el);
      inserted++;
      assertTrue(queue.isHeapified());
      assertEquals(inserted, queue.size());
    }
  }

  @Test
  public void increaseKeyOfObjectHandleExpectedResult() throws ArgumentException, MinHeapException, ElementNotFoundException {

    Comparator<Integer> comp = Comparator.comparingInt((Integer x) -> x);
    TestObjectComparator<String, Integer> comparator = new TestObjectComparator<>(comp);
    MinHeap<TestObject<String, Integer>> queue = new MinHeap<>(comparator);

    var prev = new TestObject<>("d", 4);
    queue.insert(prev);	

    var newT = new TestObject<>("c", 3);
    queue.increaseKeyPriority(prev, newT);
    assertEquals(0, comparator.compare(newT, queue.peek()));
    assertEquals("c", queue.peek().field1);
    assertEquals(3, (int) queue.peek().field2);
    prev = newT;

    newT = new TestObject<>("b", 2);
    queue.increaseKeyPriority(prev, newT);
    assertEquals(0, comparator.compare(newT, queue.peek()));
    assertEquals("b", queue.peek().field1);
    assertEquals(2, (int) queue.peek().field2);
    prev = newT;

    newT = new TestObject<>("a", 1);
    queue.increaseKeyPriority(prev, newT);
    assertEquals(0, comparator.compare(newT, queue.peek()));
    assertEquals("a", queue.peek().field1);
    assertEquals(1, (int) queue.peek().field2);

  }
}