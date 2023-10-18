package ex4.helpers;

import ex4.exceptions.ArgumentException;
import ex4.structures.Graph;
import org.junit.Test;

import java.util.*;

import static org.junit.Assert.*;

public class GraphHelperTests {

  @Test
  public void dijkstraOnDirectGraphHandleExpectedResult() throws Exception {

    GraphBuilder<String, Integer> builder = new GraphBuilder<>();

    // Vertex "a", "b", "c", "d", "e", "f", "z"
    Graph<String, Integer> graph = builder
        .addEdge("a", "b", 4)
        .addEdge("a", "c", 6)
        .addEdge("a", "f", 4)
        .addEdge("b", "e", 2)
        .addEdge("b", "d", 8)
        .addEdge("b", "c", 7)
        .addEdge("c", "d", 2)
        .addEdge("d", "e", 4)
        .addEdge("e", "z", 1)
        .addEdge("f", "b", 1)
        .addEdge("f", "z", 9)
        .build();

    GraphHelper.Pair<ArrayList<String>, Integer> path = GraphHelper.findShortestPath(graph,
        Comparator.comparingInt((Integer x) -> x),
        Integer.MAX_VALUE,
        "a",
        "z");
    assertArrayEquals(Arrays.asList("a", "b", "e", "z").toArray(), path.first().toArray());
    assertEquals(7, path.second().intValue());
  }

  @Test
  public void dijkstraOnIndirectGraphHandleExpectedResult() throws Exception {

    GraphBuilder<String, Integer> builder = new GraphBuilder<>();

    // "a", "b", "c", "d", "e"
    Graph<String, Integer> graph = builder
        .buildDiagraph(false)
        .addEdge("a", "b", 2)
        .addEdge("b", "c", 2)
        .addEdge("c", "d", 2)
        .addEdge("d", "e", 2)
        .addEdge("a", "e", 7)
        .build();

    GraphHelper.Pair<ArrayList<String>, Integer> path = GraphHelper.findShortestPath(graph,
        Comparator.comparingInt((Integer x) -> x),
        Integer.MAX_VALUE,
        "a",
        "e");
    assertArrayEquals(Arrays.asList("a", "e").toArray(), path.first().toArray());
    assertEquals(7, path.second().intValue());
  }

  @Test
  public void dijkstraOnGraphWithInternalLoopHandleExpectedResult() throws Exception {
    GraphBuilder<String, Integer> builder = new GraphBuilder<>();

    // "a", "b", "c", "d", "e"
    Graph<String, Integer> graph = builder
        .addEdge("a", "b", 1)
        .addEdge("b", "c", 1)
        .addEdge("c", "d", 1)
        .addEdge("d", "b", 1)
        .addEdge("c", "e", 10)
        .build();

    GraphHelper.Pair<ArrayList<String>, Integer> path = GraphHelper.findShortestPath(graph,
        Comparator.comparingInt((Integer x) -> x),
        Integer.MAX_VALUE,
        "a",
        "e");
    assertArrayEquals(Arrays.asList("a", "b", "c", "e").toArray(), path.first().toArray());
    assertEquals(12, path.second().intValue());
  }

  @Test
  public void dijkstraWithUnreachableDestinationReturnsEmptyArray() throws Exception {
    Graph<String, Integer> graph = new Graph<>(false);

    String[] vertexes = { "a", "b", "c", "d", "e" };

    for (String el : vertexes) {
      graph.addVertex(el);
    }

    graph.addEdge("a", "b", 1);
    graph.addEdge("b", "c", 1);
    graph.addEdge("c", "a", 1);
    graph.addEdge("d", "e", 1);

    GraphHelper.Pair<ArrayList<String>, Integer> empty = GraphHelper.findShortestPath(graph,
        Comparator.comparingInt((Integer x) -> x),
        Integer.MAX_VALUE,
        "a",
        "e");

    assertArrayEquals(new ArrayList<String>().toArray(), empty.first().toArray());
    assertEquals(0, empty.second().intValue());
  }

  public void dijkstraWithDestinationWithoutEdgesReturnsEmptyArray() throws Exception {
    Graph<String, Integer> graph = new Graph<>(false);

    String[] vertexes = { "a", "b", "c", "d", "e" };

    for (String el : vertexes) {
      graph.addVertex(el);
    }

    graph.addEdge("a", "b", 1);
    graph.addEdge("b", "c", 1);
    graph.addEdge("c", "d", 1);
    graph.addEdge("d", "b", 1);

     GraphHelper.Pair<ArrayList<String>, Integer> empty = GraphHelper.findShortestPath(graph,
        Comparator.comparingInt((Integer x) -> x),
        Integer.MAX_VALUE,
        "a",
        "e");

    assertArrayEquals(new ArrayList<String>().toArray(), empty.first().toArray());
    assertEquals(0, empty.second().intValue());
  }

  @Test
  public void dijkstraWithInvalidDestinationThrowsException() throws Exception {
    Graph<String, Integer> graph = new Graph<>(false);
    String[] vertexes = { "a", "b" };
    for (String el : vertexes) {
      graph.addVertex(el);
    }
    graph.addEdge("a", "b", 1);

    assertThrows(
        ArgumentException.class,
        () -> GraphHelper.findShortestPath(graph,
            Comparator.comparingInt((Integer x) -> x),
            Integer.MAX_VALUE,
            "a",
            null));

    assertThrows(
        ArgumentException.class,
        () -> GraphHelper.findShortestPath(graph,
            Comparator.comparingInt((Integer x) -> x),
            Integer.MAX_VALUE,
            "a",
            "z"));
  }

  @Test
  public void dijkstraWithInvalidSourceThrowsException() throws Exception {
    Graph<String, Integer> graph = new Graph<>(false);
    String[] vertexes = { "a", "b" };
    for (String el : vertexes) {
      graph.addVertex(el);
    }
    graph.addEdge("a", "b", 1);

    assertThrows(
        ArgumentException.class,
        () -> GraphHelper.findShortestPath(graph,
            Comparator.comparingInt((Integer x) -> x),
            Integer.MAX_VALUE,
            null,
            "e"));

    assertThrows(
        ArgumentException.class,
        () -> GraphHelper.findShortestPath(graph,
            Comparator.comparingInt((Integer x) -> x),
            Integer.MAX_VALUE,
            "z",
            "b"));
  }

  @Test(expected = NullPointerException.class)
  public void createNodeWithItemNullThrowsException() throws NullPointerException {
    new GraphHelper.Node<String, Integer>(null, 0);
  }

}