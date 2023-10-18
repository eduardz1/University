package ex4.structures;

/**
 * Creates an Edge with the given source, target and weight.
 *
 * @param source the source of the Edge
 * @param weight the weight of the Edge
 * @param target the target of the Edge
 */
public record Edge<V, E>(V source, E weight, V target) {

  public Edge<V, E> getReverse() {
    return new Edge<>(this.target, this.weight, this.source);
  }
}