package teoria.e20210719;

public class Point3D extends Point {

  private int z;

  public Point3D(int x, int y, int z) {
    super(x, y);
    this.z = z;
  }

  public int getZ() {
    return this.z;
  }

  @Override
  public boolean equals(Object obj) {
    if (obj == this) return true;
    if (obj == null) return false;
    if (getClass() != obj.getClass()) return false;

    var other = (Point3D) obj;
    return super.equals(obj) && this.z == other.getZ();
  }
}
