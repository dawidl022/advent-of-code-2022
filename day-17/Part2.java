import java.util.*;

public class Part2 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String pattern = scanner.nextLine().strip();
        Iterator<Rock> rockSource = new RockSource().iterator();
        Iterator<Direction> gasSource = new GasSource(pattern).iterator();

        Set<Point> rocksPoints = new HashSet<>();
        List<List<Integer>> repeatingXCoords = new ArrayList<>();
        List<Integer> heightAdditions = new ArrayList<>();

        int highest = -1;
        int surplusHeight = 0;

        int i;
        int repeatingRockCount;

        for (i = 0, repeatingRockCount = 0; repeatingRockCount < 5; i++) {
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

            if (i >= pattern.length()) {
                heightAdditions.add(Math.max(0, rock.highestYCoord() - highest));
            }

            List<Integer> rockXCoords = rock.points().stream().map(Point::x).toList();

            if (isFirst5AfterPattern(pattern, i)) {
                repeatingXCoords.add(rockXCoords);
                surplusHeight += Math.max(0, rock.highestYCoord() - highest);
            } else {
                int rockOffset = i % pattern.length() % 5;
                if (i >= pattern.length() * 2 && (rockOffset == 0 || repeatingRockCount > 0)) {
                    if (repeatingXCoords.get(rockOffset).equals(rockXCoords)) {
                        repeatingRockCount++;
                    } else {
                        repeatingRockCount = 0;
                    }
                }
            }

            if (rock.highestYCoord() > highest) {
                highest = rock.highestYCoord();
            }

            rocksPoints.addAll(rock.points());
        }
        // the first 5 repeated rocks were added to the heights, so we remove them from the list
        heightAdditions = heightAdditions.stream().limit(heightAdditions.size() - 5).toList();

        long repetitions = 1000000000000L - i + 5;
        int loopSum = heightAdditions.stream().reduce(0, Integer::sum);
        int remSum = heightAdditions.stream()
            .limit(repetitions % heightAdditions.size())
            .reduce(0, Integer::sum);

        System.out.println(
            loopSum * (repetitions / heightAdditions.size())
                + highest + 1
                + remSum
                - surplusHeight);
    }

    private static boolean isFirst5AfterPattern(String pattern, int i) {
        return i >= pattern.length() && i < pattern.length() + 5;
    }
}
