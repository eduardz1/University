package ex4.structures;

import ex4.exceptions.ElementNotFoundException;
import ex4.exceptions.GraphException;

import java.util.ArrayList;
import java.util.Collection;

/**
 * A class representing a Graph with generic Vertexes and Edges.
 * 
 * @param <V> type of the elements in the Graph
 * @param <E> type of the edges in the Graph
 */
public class Graph<V, E> {

  private final DirectedGraph<V, E> internalGraph;

  /**
   * Creates an empty graph.
   */
  public Graph(boolean isDirected) {
    internalGraph = isDirected ? new DirectedGraph<>() : new UndirectedGraph<>();
  }

  /**
   * @return {@code}true{@code} if is directed or {@code}false{@code} otherwise
   */
  public boolean isDirected() {
    return !(this.internalGraph instanceof UndirectedGraph);
  }

  /**
   * Add a {@code}Collection{@code} of vertex to the Graph.
   *
   * @param vertices is the collection of the vertices to be added.
   * @throws GraphException when vertices are null
   */
  public void addAllVertices(Collection<V> vertices) throws GraphException {
    if (vertices == null)
      throw new GraphException("addAllVertexes:" + " vertexes cannot be null");

    for (V vertex : vertices)
      this.addVertex(vertex);
  }

  /**
   * Add vertex to the Graph.
   *
   * @param vertex is the vertex to be added.
   * @throws GraphException when vertex is null.
   */
  public void addVertex(V vertex) throws GraphException {
    if (vertex == null)
      throw new GraphException("addVertex:" + " vertex cannot be null");

    this.internalGraph.addVertex(vertex);
  }

  /**
   * Checks whether the graph contains an edge between two vertexes.
   *
   * @param from   element associated to the source of the edge.
   * @param to     element associated to the destination of the edge.
   * @return {@code}true{@code} if contains edge or {@code}false{@code} otherwise
   */
  public boolean containsEdge(V from, V to) {
    return this.internalGraph.containsEdge(from, to);
  }

  /**
   * @param vertex element to find
   * @return {@code}true{@code} if contains vertex or
   *         {@code}false{@code} otherwise
   */
  public boolean containsVertex(V vertex) {
    return this.internalGraph.containsVertex(vertex);
  }

  /**
   * Returns value of the specified edge.
   * 
   * @param from is the source vertex of the edge
   * @param to   is the destination vertex of the edge
   * @return edge value
   * @throws GraphException           when {@code}from{@code} or
   *                                  {@code}to{@code} are null
   * @throws ElementNotFoundException when {@code}from{@code} or
   *                                  {@code}to{@code} are not found
   */
  public E getEdge(V from, V to) throws GraphException, ElementNotFoundException {

    if (from == null || to == null)
      throw new GraphException("getEdge:" + " from and to cannot be null");

    if (!internalGraph.containsVertex(from))
      throw new ElementNotFoundException("getEdge:" + " from does not exist");

    if (!internalGraph.containsEdge(from, to))
      throw new ElementNotFoundException("getEdge:" + " to does not exist");

    return this.internalGraph.getEdge(from, to);
  }

  /**
   * @return number of edges in the Graph
   */
  public int getEdgeCount() {
    return this.internalGraph.getEdgeCount();
  }

  /**
   * @return list of {@link Edge Edges} in the Graph.
   */
  public ArrayList<Edge<V, E>> getEdges() {
    return this.internalGraph.getEdges();
  }

  /**
   * Returns an ArrayList of the adjacent vertices of the specified vertex.
   * 
   * @param vertex element of which the neighbors are to be found
   * @return list of neighbors
   * @throws GraphException           when vertex is null
   * @throws ElementNotFoundException when vertex is not found
   */
  public ArrayList<V> getNeighbors(V vertex) throws GraphException, ElementNotFoundException {
    if (vertex == null)
      throw new GraphException("getNeighbors:" + " vertex cannot be null");

    if (!this.internalGraph.containsVertex(vertex))
      throw new ElementNotFoundException("getNeighbors:" + " vertex does not exist");

    return this.internalGraph.getNeighbors(vertex);
  }

  /**
   * @return number of the vertices in the Graph
   */
  public int getVertexCount() {
    return this.internalGraph.getVertexCount();
  }

  /**
   * @return list of vertices in the Graph.
   */
  public ArrayList<V> getVertices() {
    return this.internalGraph.getVertices();
  }

  /**
   * Add an edge to the graph.
   *
   * @param from   is the source vertex
   * @param to     is the destination vertex
   * @param weight is the weight of the edge
   * @throws GraphException           when {@code}to{@code} or
   *                                  {@code}from{@code} are null
   * @throws ElementNotFoundException when either {@code}to{@code} or
   *                                  {@code}from{@code} are not found
   */
  public void addEdge(V from, V to, E weight) throws GraphException, ElementNotFoundException {
    if (to == null || from == null)
      throw new GraphException("makeEdge:" + " to and from cannot be null");

    if (!internalGraph.containsVertex(to))
      throw new ElementNotFoundException("addEdge:" + " to does not exist");
    if (!internalGraph.containsVertex(from))
      throw new ElementNotFoundException("addEdge:" + " from does not exist");

    this.internalGraph.addEdge(from, to, weight);
  }

  /**
   * Removes the specified edge from the Graph.
   *
   * @param from is the source vertex of the edge to be removed
   * @param to   is the destination vertex of the edge to be removed
   * @throws GraphException           when {@code}from{@code} or
   *                                  {@code}to{@code} are null
   * @throws ElementNotFoundException when {@code}from{@code} or
   *                                  {@code}to{@code} are not found
   */
  public void removeEdge(V from, V to) throws GraphException, ElementNotFoundException {
    if (to == null || from == null)
      throw new GraphException("makeEdge:" + " to and from cannot be null");

    if (!internalGraph.containsVertex(to))
      throw new ElementNotFoundException("addEdge:" + " to does not exist");
    if (!internalGraph.adjacencyMap.get(from).containsKey(to))
      throw new ElementNotFoundException("addEdge:" + " edge to \"to\" does not exist");

    this.internalGraph.removeEdge(from, to);
  }

  /**
   * Removes the specified vertex from the Graph.
   * 
   * @param vertex element ot be removed
   * @throws GraphException           when input vertex is null
   * @throws ElementNotFoundException when input vertex is not found
   */
  public void removeVertex(V vertex) throws GraphException, ElementNotFoundException {
    if (vertex == null)
      throw new GraphException("removeVertex:" + " vertex cannot be null");
    if (!internalGraph.containsVertex(vertex))
      throw new ElementNotFoundException("removeVertex:" + " vertex does not exist");

    this.internalGraph.removeVertex(vertex);
  }

  /**
   * prints a Graph formatted
   */
  public void print() {
    this.internalGraph.print();
  }

}
