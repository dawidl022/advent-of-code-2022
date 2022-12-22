import java.util.Iterator;

public class GasSource implements Iterable<Direction> {

    private final String pattern;

    GasSource(String pattern) {
        this.pattern = pattern;
    }

    @Override
    public Iterator<Direction> iterator() {
        return new Iterator<>() {
            private int i = 0;

            @Override
            public boolean hasNext() {
                return true;
            }

            @Override
            public Direction next() {
                if (pattern.charAt(i++ % pattern.length()) == '<')
                    return Direction.LEFT;
                return Direction.RIGHT;
            }
        };
    }
}
