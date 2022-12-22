import java.util.*;

public class Part1 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Iterator<Rock> rockSource = new RockSource().iterator();
        Iterator<Direction> gasSource = new GasSource(scanner.nextLine().strip()).iterator();

        Set<Point> rocksPoints = new HashSet<>();
        int highest = -1;

        for (int i = 0; i < 2022; i++) {
            Rock rock = rockSource.next();
            rock.move(0, highest + 4);
            boolean gasPushing = true;

            while (gasPushing || rock.canFall(rocksPoints)) {
                if (gasPushing) {
                    Direction dirToMove = gasSource.next();
                    if (dirToMove == Direction.LEFT) {
                        rock.moveLeftIfPossible(rocksPoints);
                    } else {
                        rock.moveRightIfPossible(rocksPoints);
                    }
                } else {
                    rock.move(0, -1);
                }
                gasPushing = !gasPushing;
            }

            if (rock.highestYCoord() > highest) {
                highest = rock.highestYCoord();
            }
            rocksPoints.addAll(rock.points());
        }
        System.out.println(highest + 1);
    }
}
