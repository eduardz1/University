package ex3.structures;

import ex3.exceptions.ArgumentException;
import ex3.exceptions.ElementNotFoundException;
import ex3.exceptions.MinHeapException;

import java.util.*;

/**
 * Class that implements a Minimum Heap data structure.
 * 
 * @param <T> type of the element in the Heap
 */
public class MinHeap<T> implements PriorityQueue<T> {

  private final List<T> heap;
  private final Map<T, Integer> lookup;
  private final Comparator<? super T> comparator;

  /**
   * Creates an empty MinHeap
   * Accepts a comparator as input implementing
   * a previous relation between T elements
   * 
   * @param comparator: comparator implementing previous relation between T elements
   * @throws MinHeapException throws an Exception when comparator is null
   */
  public MinHeap(Comparator<? super T> comparator) throws ArgumentException {
    if (comparator == null)
      throw new ArgumentException("MinHeap:" + " parameter comparator cannot be null");
    this.heap = new ArrayList<>();
    this.comparator = comparator;
    this.lookup = new HashMap<>();
  }

  @Override
  public boolean isEmpty() {
    return this.heap.isEmpty();
  }

  @Override
  public int size() {
    return this.heap.size();
  }

  @Override
  public void insert(T elem) throws ArgumentException, MinHeapException {
    if (elem == null)
      throw new ArgumentException("insert:" + " elem cannot be null"); 
    if (this.lookup.containsKey(elem))
      throw new MinHeapException("insert:" + " elem already present");

    this.heap.add(elem);
    this.lookup.put(elem, this.heap.size() - 1);

    int i = this.heap.size() - 1;
    botHeapify(i);
  }

  /**
   * @param i index
   * @return index of the parent of the element at i position
   */
  private int parent(int i) {
    if (i == 0) return i;
    return (i - 1) / 2;
  }
  
  /**
   * @param elem
   * @return parent of {@code}elem{@code} in O(1) time
   * @throws ElementNotFoundException when {@code}elem{@code} is not present in the Heap
   */
  public T parent (T elem) throws ElementNotFoundException {
    if (!this.lookup.containsKey(elem))
      throw new ElementNotFoundException("parent:" + " Heap does not contain " + elem);
    int i = this.lookup.get(elem);
    if (i == 0) return null;
    return this.heap.get((i - 1) / 2);
  }

  /**
   * @param i
   * @return index of the left element of the parent at position i
   */
  private int left(int i) {
    int res = 2 * i + 1;
    if (res >= this.heap.size()) return i;
    return res;
  }

  /**
   * @param elem
   * @return left child of {@code}elem{@code} in O(1) time
   * @throws ElementNotFoundException when {@code}elem{@code} is not present in the Heap
   */
  public T left(T elem) throws ElementNotFoundException {
    if (!this.lookup.containsKey(elem))
      throw new ElementNotFoundException("left:" + " Heap does not contain " + elem);
    int i = this.lookup.get(elem);
    int res = 2 * i + 1;
    if (res >= this.heap.size()) return null;
    return this.heap.get(res);
  }

  /**
   * @param i
   * @return index of the right element of the parent at position i
   */
  private int right(int i){
    int res = 2 * i + 2;
    if (res >= this.heap.size()) return i;
    return res;
  }

  /**
   * @param elem
   * @return right child of {@code}elem{@code} in O(1) time
   * @throws ElementNotFoundException when {@code}elem{@code} is not present in the Heap
   */
  public T right(T elem) throws ElementNotFoundException{
    if (!this.lookup.containsKey(elem))
      throw new ElementNotFoundException("right:" + " Heap does not contain " + elem);
    int i = this.lookup.get(elem);
    int res = 2 * i + 2;
    if (res >= this.heap.size()) return null;
    return this.heap.get(res);
  }

  @Override
  public T remove() throws MinHeapException {
    if(this.heap.isEmpty())
      throw new MinHeapException("remove:" + " heap is empty");

    T res = this.heap.get(0);
    T newRoot = this.heap.remove(this.heap.size() - 1);

    this.lookup.remove(res);

    // Last element was deleted
    if (this.heap.isEmpty()) 
      return res;

    this.heap.set(0, newRoot);
    this.lookup.put(newRoot, 0);
    topHeapify(0);
    return res;
  }

  @Override
  public T peek() throws MinHeapException {
    if (this.heap.isEmpty())
      throw new MinHeapException("peek:" + " heap is empty");
    return this.heap.get(0);
  }

  /**
   * Preserves the min-heap property from top to bottom
   * 
   * @param i current node index
   */
  private void topHeapify(int i) {
    int smallest;
    int left  = this.left(i);
    int right = this.right(i);

    boolean cond = this.comparator.compare(this.heap.get(left), this.heap.get(i)) < 0;
    smallest = (cond) ? left : i;
    
    cond = this.comparator.compare(this.heap.get(right), this.heap.get(smallest)) < 0;
    if(right != i && cond) smallest = right;

    if(smallest != i) {
      this.lookup.put(this.heap.get(i), smallest);
      this.lookup.put(this.heap.get(smallest), i);
      Collections.swap(this.heap, i, smallest);
      topHeapify(smallest);
    }
  }

  /**
   * Decreases {@code}key{@code} to the new value {@code}newKey{@code},
   * increasing its priority in the queue
   * 
   * @param key key to be decreased
   * @param newKey new value to be set
   * @throws ElementNotFoundException when {@code}key{@code} is not present in the Heap
   * @throws MinHeapException when {@code}newKey{@code} is not smaller than {@code}key{@code}
   */
  @Override
  public void increaseKeyPriority(T key, T newKey) throws MinHeapException, ElementNotFoundException {
    if (!this.lookup.containsKey(key))
      throw new ElementNotFoundException("increaseKeyPriority:" + key + " key not found in the heap");

    int i = this.lookup.get(key);
    if(this.comparator.compare(newKey, this.heap.get(i)) > 0)
      throw new MinHeapException(String.format("increaseKeyPriority:" + " new key {%s} is not smaller than current key {%s}", newKey, key));
    
    this.heap.set(i, newKey);
    this.lookup.remove(key);
    this.lookup.put(newKey, i);
    botHeapify(i);
  }

  @Override
  public boolean contains(T element) {
    return this.lookup.containsKey(element);
  }

  /**
   * Preserves min-heap property from the bottom to the top
   * 
   * @param i current node index
   */
  private void botHeapify(int i) {
    while(i > 0 && this.comparator.compare(this.heap.get(parent(i)), this.heap.get(i)) > 0) {
      int parent = this.parent(i);
      this.lookup.put(this.heap.get(parent), i);
      this.lookup.put(this.heap.get(i), parent);
      Collections.swap(this.heap, i, parent(i));
      i = parent(i);
    }
  }

  /**
   * Checks if min-heap property is preserved from top to bottom
   * 
   * @return if heap is a min-heap
   * @throws ElementNotFoundException
   */
  public boolean isHeapified() throws ElementNotFoundException {
    if(this.heap.isEmpty())
      return true;

    // Start from root
    return isHeapified(this.heap.get(0));
    
  }

  /**
   * Checks if min-heap property is preserved from top to bottom
   * 
   * @param node node to be checked
   * @return if node and his children have min property 
   * @throws ElementNotFoundException
   */
  private boolean isHeapified(T node) throws ElementNotFoundException {
      
    T left = left(node);
    T right = right(node);  

    if (left == null && right == null)
      return true;

    /*
     * First @return can be simplified by the following code, as we
     * assume that there are no empty positions in a heap, so if 
     * right is null, left is the last element of the array 
     *  
     * @code
     * return this.comparator.compare(node, left) > 0;
    */
    if (right == null) 
      return this.comparator.compare(node, left) < 0 && isHeapified(left);
    else
      return 
        this.comparator.compare(node, left) < 0 &&
        this.comparator.compare(node, right) < 0 &&
        isHeapified(left) &&
        isHeapified(right);
  }

  @Override
  public void insertAll(Collection<T> elements) throws ArgumentException, MinHeapException {
    if(elements == null)
      throw new MinHeapException("insertAll:" + " elements cannot be null");
    
    for(T elem : elements)
      this.insert(elem);
  }
  
}