package ex4.structures;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * An abstract class representing a Graph with generic Vertexes and Edges.
 * Needs to be extended to either be a directed or undirected graph.
 * 
 * @param <V> type of the elements in the Graph
 * @param <E> type of the edges in the Graph
 */
public class DirectedGraph<V, E> {

  /**
   * can be viewed as an adjacency list but functions more akin to a matrix
   */
  protected final Map<V, Map<V, E>> adjacencyMap;

  /**
   * Creates an empty Graph.
   */
  protected DirectedGraph() {
    this.adjacencyMap = new HashMap<>();
  }

  /**
   * @see Graph#addVertex(V)
   */
  public void addVertex(V vertex) {
    this.adjacencyMap.put(vertex, new HashMap<>());
  }

  /**
   * @see Graph#addEdge(V, V, E)
   */
  public void addEdge(V from, V to, E weight) {
    adjacencyMap.get(from).put(to, weight);
  }

  /**
   * @see Graph#containsVertex(V)
   */
  public boolean containsVertex(V vertex) {
    return this.adjacencyMap.containsKey(vertex);
  }

  /**
   * @see Graph#containsEdge(V, V)
   */
  public boolean containsEdge(V from, V to) {
    return this.adjacencyMap.get(from).containsKey(to);
  }

  /**
   * @see Graph#removeVertex(V)
   */
  public void removeVertex(V vertex) {
    this.adjacencyMap.values().forEach(map -> map.remove(vertex));
    this.adjacencyMap.remove(vertex);
  }

  /**
   * @see Graph#removeEdge(V, V)
   */
  public void removeEdge(V from, V to) {
    this.adjacencyMap.get(from).remove(to);
  }

  /**
   * @see Graph#getVertexCount()
   */
  public int getVertexCount() {
    return this.adjacencyMap.size();
  }

  /**
   * @see Graph#getEdgeCount()
   */
  public int getEdgeCount() {
    return adjacencyMap
        .values()
        .stream()
        .reduce(0, (acc, curr) -> acc + curr.size(), Integer::sum);
  }

  /**
   * @see Graph#getVertices()
   */
  public ArrayList<V> getVertices() {
    return new ArrayList<>(this.adjacencyMap.keySet());
  }

  /**
   * @see Graph#getNeighbors(V)
   */
  public ArrayList<V> getNeighbors(V vertex) {
    return new ArrayList<>(this.adjacencyMap.get(vertex).keySet());
  }

  /**
   * @see Graph#getEdge(V, V)
   */
  public E getEdge(V from, V to) {
    return adjacencyMap.get(from).get(to);
  }

  /**
   * @see Graph#getEdges()
   */
  public ArrayList<Edge<V, E>> getEdges() {
    ArrayList<Edge<V, E>> edges = new ArrayList<>();

    adjacencyMap
        .forEach((from, toMap) -> toMap.forEach((to, weight) -> edges.add(new Edge<>(from, weight, to))));
    return edges;
  }

  /**
   * prints a Graph formatted
   */
  public void print() {
    for (V vertex : this.adjacencyMap.keySet()) {
      System.out.print(vertex + ": ");
      for (V neighbor : this.adjacencyMap.get(vertex).keySet()) {
        System.out.print(neighbor + " ");
      }
      System.out.println();
    }
  }

}