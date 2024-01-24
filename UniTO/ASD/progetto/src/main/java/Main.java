import ex4.exceptions.ElementNotFoundException;
import ex4.exceptions.GraphException;
import ex4.helpers.GraphBuilder;
import ex4.helpers.GraphHelper;
import ex4.structures.Graph;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Scanner;

public class Main {
  public static void main(String[] args) throws Exception {

    String[] inputs = new String[3];
    Scanner input = new Scanner(System.in);

    System.out.println("Please enter the path of the dataset");
    inputs[0] = input.nextLine();

    Graph<String, Float> graph;
    try {
      graph = graphFromCsv(inputs);
    } catch (FileNotFoundException e) {
      System.out.println("File not found");
      e.printStackTrace();
      input.close();
      return;
    }

    System.out.println("Please enter the source city");
    inputs[1] = input.nextLine().toLowerCase();
    System.out.println("Please enter the destination city");
    inputs[2] = input.nextLine().toLowerCase();
    input.close();

    long start = System.currentTimeMillis();
    GraphHelper.Pair<ArrayList<String>, Float> res = GraphHelper.findShortestPath(graph,
        Comparator.comparing((Float x) -> x),
        Float.MAX_VALUE,
        inputs[1],
        inputs[2]);
    long end = System.currentTimeMillis();

    System.out.println("\n\033[1mTIME:\033[0m " + (end - start) + " ms\n");
    res.first().forEach(System.out::println);
    System.out.println("\n\033[1mDISTANCE:\033[0m " + res.second() + " m\n");
  }

  private static Graph<String, Float> graphFromCsv(String[] inputs) // si potrebbe mettere in GraphBuilder maybe
      throws FileNotFoundException, GraphException, ElementNotFoundException {
    File file = new File(inputs[0]);

    Graph<String, Float> graph;
    GraphBuilder<String, Float> builder = new GraphBuilder<>();

    Scanner scanner = new Scanner(file);
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine();
      String[] tokens = line.split(",");

      builder.addEdge(tokens[0], tokens[1], Float.parseFloat(tokens[2]));
    }
    scanner.close();
    graph = builder.build();
    return graph;
  }
}