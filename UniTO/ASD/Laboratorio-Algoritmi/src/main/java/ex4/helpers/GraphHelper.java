package ex4.helpers;

import ex3.structures.MinHeap;
import ex3.structures.PriorityQueue;
import ex4.exceptions.ArgumentException;
import ex4.exceptions.GraphHelperException;
import ex4.structures.Graph;

import java.util.*;


/**
 * Class that contains some useful methods for the Graph class. 
 */
public class GraphHelper {

  /**
   * Dijkstra's algorithm.
   * 
   * @param <V>    Type of the element in the graph
   * @param <E>    Type of the edges in the graph (aka type of the weight),
   *               must extend {@code}Number{@code}
   * @param graph  {@link Graph Graph} of generic type, can be either
   *               directed or undirected
   * @param comp   {@code}Comparator{@code} for the type E
   * @param max    {@code}MAX VALUE{@code} of the specified number type
   * @param source source node for the path search
   * @return {@link GraphHelper.Pair Pair} a {@code}Map{@code} of the shortest
   *         path from {@code}source{@code} to each vertex and a
   *         {@code}Map{@code} of the distances from each vertex
   * @throws Exception when it encounters an edge with negative weight
   */
  private static <V, E extends Number> Pair<Map<V, V>, Map<V, E>> dijkstra(
      Graph<V, E> graph,
      Comparator<? super E> comp,
      E max,
      V source) throws Exception {

    PriorityQueue<Node<V, E>> queue = new MinHeap<>((n1, n2) -> comp.compare(n1.key, n2.key));
    Map<V, E> distances = new HashMap<>(); // used to track distances from source to each node
    Map<V, V> prevs = new HashMap<>(); // uses null to mark undefined

    for (V v : graph.getVertices()) {
      distances.put(v, max);
      prevs.put(v, null);
    }
    queue.insert(new Node<>(source, (getZero(max))));
    distances.put(source, getZero(max));

    while (!queue.isEmpty()) {
      Node<V, E> u = queue.remove();
      if(comp.compare(distances.get(u.item), u.key) < 0) continue; // ignores stale nodes when we already found a shorter path

      for (V neigh : graph.getNeighbors(u.item)) { // no need to check for visited given that the algorithm is greedy
        E edgeWeight = graph.getEdge(u.item, neigh);
        if(comp.compare(edgeWeight, getZero(max)) < 0) throw new GraphHelperException("Encountered an edge with a negative weight");
        E newDist = addNumbers(distances.get(u.item), edgeWeight);

        if (comp.compare(newDist, distances.get(neigh)) < 0) { // new shortest path found, relax the edge and update the queue
          Node<V, E> newNode = new Node<>(neigh, newDist);
          if (!queue.contains(newNode)) {
            queue.insert(newNode);
          } else {
            queue.increaseKeyPriority(new Node<>(neigh, distances.get(neigh)), newNode);
          }
          distances.put(neigh, newDist);
          prevs.put(neigh, u.item);
        }
      }
    }
    return new Pair<>(prevs, distances);
  }

  /**
   * Finds the shortest path in a graph starting from the shortest path tree return by {@code}dijkstra{@code}'s algorithm.
   * 
   * @param <V>         Type of the elements in the graph
   * @param <E>         Type of the edges in the graph (aka type of the weight),
   *                    must extend {@code}Number{@code}
   * @param graph       {@link Graph Graph} of generic type, can be either
   *                    directed or undirected
   * @param comp        {@code}Comparator{@code} for the type E
   * @param max         {@code}MAX VALUE{@code} of the specified number type
   * @param source      source node for the path search
   * @param destination destination of the path search
   * @return returns a new {@link Pair Pair} where the first element
   *         is a {@code}List{@code} of the calculated path and the second element
   *         is the path length, if there is no path between the two nodes then the
   *         first element is an empty array and the first element is zero
   * @throws ArgumentException when either graph is null, source and destination are the same or one of the former is not in the graph
   * @throws GraphHelperException when the graph contains an edge with negative weight
   */
  public static <V, E extends Number> Pair<ArrayList<V>, E> findShortestPath(
      Graph<V, E> graph,
      Comparator<? super E> comp,
      E max,
      V source,
      V destination) throws Exception {

    if (graph == null)
      throw new ArgumentException("Graph is null");
    if (!graph.containsVertex(source) || !graph.containsVertex(destination))
      throw new ArgumentException("Source or destination are not in the graph");
    if (source.equals(destination))
      throw new ArgumentException("Source and destination are the same");

    Pair<Map<V, V>, Map<V, E>> res = dijkstra(graph, comp, max, source);
    Map<V, V> prevs = res.first;
    Map<V, E> distances = res.second;

    ArrayList<V> path = new ArrayList<>();
    if(prevs.get(destination) == null) return new Pair<>(path, getZero(max));
    path.add(destination);

    for(V currentV = prevs.get(destination); currentV != null; currentV = prevs.get(currentV)) {
      path.add(currentV);
    }
    Collections.reverse(path);

    return new Pair<>(path, distances.get(destination));
  }

  /**
   * add two generic {@code}Number{@code} objects
   * 
   * @param <E> Type of the element, must extend {@code}Number{@code}
   * @param a   first element
   * @param b   second element
   * @return sum of the two elements
   */
  @SuppressWarnings("unchecked")
  private static <E extends Number> E addNumbers(E a, E b) {
    if (a instanceof Double || b instanceof Double) {
      return (E) (Double) (a.doubleValue() + b.doubleValue());
    } else if (a instanceof Float || b instanceof Float) {
      return (E) (Float) (a.floatValue() + b.floatValue());
    } else if (a instanceof Long || b instanceof Long) {
      return (E) (Long) (a.longValue() + b.longValue());
    } else { // don't check for shorts because the addition of two shorts produces an int
      return (E) (Integer) (a.intValue() + b.intValue());
    }
  }

  /**
   * @return zero as generic
   */
  @SuppressWarnings("unchecked")
  private static <E extends Number> E getZero(E clazz) {
    if (clazz instanceof Double) {
      return (E) (Double) 0d;
    } else if (clazz instanceof Float) {
      return (E) (Float) 0f;
    } else if (clazz instanceof Long) {
      return (E) (Long) 0L;
    } else if (clazz instanceof Short) {
      return (E) (Short) (short) 0;
    } else {
      return (E) (Integer) 0;
    }
  }

  /**
   * Pair of two generic objects
   *
   * @param <V> Type of the first object
   * @param <E> Type of the second object
   */
  public record Pair<V, E> (V first, E second) {
  }

  /**
   * Node for a {@link PriorityQueue PriorityQueue} composed by
   * an item with associated priority
   *
   * @param <V> Type of the item
   * @param <E> Type of the key, must extend {@code}Number{@code}
   */
  public record Node<V, E extends Number> (V item, E key) {
    public Node {
      Objects.requireNonNull(item);
    }
  }
}