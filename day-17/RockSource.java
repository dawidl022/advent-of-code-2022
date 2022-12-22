import java.util.Iterator;

public class RockSource implements Iterable<Rock> {
    private final Rock[] rocks = new Rock[]{
        new Rock(new Point(0, 0), new Point(1, 0), new Point(2, 0), new Point(3, 0)),
        new Rock(new Point(1, 0), new Point(0, 1), new Point(1, 1), new Point(2, 1), new Point(1, 2)),
        new Rock(new Point(0, 0), new Point(1, 0), new Point(2, 0), new Point(2, 1), new Point(2, 2)),
        new Rock(new Point(0, 0), new Point(0, 1), new Point(0, 2), new Point(0, 3)),
        new Rock(new Point(0, 0), new Point(1, 0), new Point(0, 1), new Point(1, 1))
    };

    @Override
    public Iterator<Rock> iterator() {
        return new Iterator<>() {
            int i = 0;

            @Override
            public boolean hasNext() {
                return true;
            }

            @Override
            public Rock next() {
                return rocks[i++ % rocks.length].clone();
            }
        };
    }
}
