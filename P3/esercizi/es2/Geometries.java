package P3.esercizi.es2;

import java.util.HashSet;
import java.util.Set;

public class Geometries {
    private final Set<Polygon> polygons;

    public Geometries() {
        this.polygons = new HashSet<>();
    }

    public Geometries(Polygon... polygons) {
        this.polygons = Set.of(polygons);
    }

    public void addPolygon(Polygon p) {
        this.polygons.add(p);
    }

    public void removePolygon(Polygon p) {
        this.polygons.remove(p);
    }

    public int countPolygons() {
        return this.polygons.size();
    }

    @Override
    public String toString() {
        return "Geometries [polygons=" + polygons + "]";
    }

    
}
