import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class Rock implements Cloneable {

    private final Point[] points;
    private Point offset = new Point(2, 0);
    private final int maxXOffset;

    public Rock(Point... points) {
        this.points = points;
        this.maxXOffset = 6 - Arrays.stream(points).max(Comparator.comparingInt(Point::getX)).get().getX();
    }

    public void move(int x, int y) {
        int xCoord = offset.getX() + x;
        if (xCoord < 0) {
            xCoord = 0;
        }
        if (xCoord > maxXOffset) {
            xCoord = maxXOffset;
        }
        offset = new Point(xCoord, offset.getY() + y);
    }

    public List<Point> bottomEdge() {
        return  Arrays.stream(points)
            .filter(point -> point.getY() == 0)
            .map(point -> new Point(point.getX() + offset.getX(), point.getY() + offset.getY())).toList();
    }

    public List<Point> leftEdge() {
        return  Arrays.stream(points)
            .filter(point -> point.getX() == leftMostXInRow(point.getY()))
            .map(point -> new Point(point.getX() + offset.getX(), point.getY() + offset.getY())).toList();
    }

    private int leftMostXInRow(int y) {
        return Arrays.stream(points)
            .filter(point -> point.getY() == y).min(Comparator.comparingInt(Point::getX)).get().getX();
    }

    public List<Point> rightEdge() {
        return  Arrays.stream(points)
            .filter(point -> point.getX() == rightMostXInRow(point.getY()))
            .map(point -> new Point(point.getX() + offset.getX(), point.getY() + offset.getY())).toList();
    }

    private int rightMostXInRow(int y) {
        return Arrays.stream(points)
            .filter(point -> point.getY() == y).max(Comparator.comparingInt(Point::getX)).get().getX();
    }


    public List<Point> points() {
        return Arrays.stream(points)
            .map(point -> new Point(point.getX() + offset.getX(), point.getY() + offset.getY()))
            .toList();
    }

    public int highest() {
        return Arrays.stream(points)
            .max(Comparator.comparingInt(Point::getY)).get().getY() + offset.getY();
    }

    @Override
    public Rock clone() {
        return new Rock(points.clone());
    }
}
