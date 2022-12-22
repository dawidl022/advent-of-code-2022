import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Set;

public class Rock implements Cloneable {

    private final Point[] points;
    private Point offset = new Point(2, 0);
    private final int maxXOffset;

    public Rock(Point... points) {
        this.points = points;
        this.maxXOffset = 6 - Arrays.stream(points).max(Comparator.comparingInt(Point::x)).get().x();
    }

    public void move(int x, int y) {
        int xCoord = offset.x() + x;
        if (xCoord < 0) {
            xCoord = 0;
        }
        if (xCoord > maxXOffset) {
            xCoord = maxXOffset;
        }
        offset = new Point(xCoord, offset.y() + y);
    }

    public List<Point> bottomEdge() {
        return  Arrays.stream(points)
            .filter(point -> point.y() == 0)
            .map(point -> new Point(point.x() + offset.x(), offset.y())).toList();
    }

    public List<Point> points() {
        return Arrays.stream(points)
            .map(point -> new Point(point.x() + offset.x(), point.y() + offset.y()))
            .toList();
    }

    public int highestYCoord() {
        return Arrays.stream(points)
            .max(Comparator.comparingInt(Point::y)).get().y() + offset.y();
    }

    public boolean canFall(Set<Point> rocksPoints) {
        return !isOnFloor() && !isTouchingOtherRock(rocksPoints);
    }

    private boolean isTouchingOtherRock(Set<Point> rocksPoints) {
        for (Point p : points()) {
            if (rocksPoints.contains(new Point(p.x(), p.y() - 1))) {
                return true;
            }
        }
        return false;
    }

    private boolean isOnFloor() {
        return bottomEdge().get(0).y() == 0;
    }

    public void moveLeftIfPossible(Set<Point> rocksPoints) {
        move(-1, 0);
        for (Point p: points()) {
            if (rocksPoints.contains(p)) {
                move(1, 0);
                break;
            }
        }
    }

    public void moveRightIfPossible(Set<Point> rocksPoints) {
        move(1, 0);
        for (Point p: points()) {
            if (rocksPoints.contains(p)) {
                move(-1, 0);
                break;
            }
        }
    }

    @Override
    public Rock clone() {
        return new Rock(points.clone());
    }
}
