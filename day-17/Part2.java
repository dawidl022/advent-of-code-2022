import java.util.*;

public class Part2 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String pattern = scanner.nextLine().strip();
        Iterator<Rock> rockSource = new RockSource().iterator();
        Iterator<Direction> gasSource = new GasSource(pattern).iterator();

        Set<Point> rocksPoints = new HashSet<>();
        int highest = -1;
        int repeatingI = 0;
        int subtracting = 0;
        List<List<Integer>> repeating = new ArrayList<>();

        List<Integer> heightAdditions = new ArrayList<>();
        int i;

        for (i = 0; i < pattern.length() * 10; i++) {
            Rock rock = rockSource.next();
            rock.move(0, highest + 4);
            boolean gasPushing = true;

            while (gasPushing || !rockAtBottom(rock) && !rockTouchingOtherRock(rocksPoints, rock)) {
                if (gasPushing) {
                    Direction dirToMove = gasSource.next();
                    if (dirToMove == Direction.LEFT) {
                        rock.move(-1, 0);
                        for (Point p : rock.points()) {
                            if (rocksPoints.contains(p)) {
                                rock.move(1, 0);
                                break;
                            }
                        }
                    } else {
                        rock.move(1, 0);
                        for (Point p : rock.points()) {
                            if (rocksPoints.contains(p)) {
                                rock.move(-1, 0);
                                break;
                            }
                        }
                    }
                } else {
                    rock.move(0, -1);
                }
                gasPushing = !gasPushing;
            }

            if (i >= pattern.length()) {
                heightAdditions.add(Math.max(0, rock.highest() - highest));
            }

            if (i >= pattern.length() && i < pattern.length() + 5) {
                repeating.add(rock.points().stream().map(Point::getX).toList());
                subtracting += Math.max(0, rock.highest() - highest);
            } else if (i >= pattern.length() * 2 && (i % pattern.length() % 5 == 0 || repeatingI > 0)) {
                if (repeating.get(i % pattern.length() % 5).equals(rock.points().stream().map(Point::getX).toList())) {
                    System.out.println(i);
                    repeatingI++;
                } else {
                    repeatingI = 0;
                }

            }
            if (rock.highest() > highest) {
                highest = rock.highest();
            }

            rocksPoints.addAll(rock.points());
            if (repeatingI == 5) {
                break;
            }
        }
//        for (int yCoord = highest; yCoord >= 0; yCoord--) {
//            for (int j = 0; j < 7; j++) {
//                if (rocksPoints.contains(new Point(j, yCoord))) {
//                    System.out.print("#");
//                } else {
//                    System.out.print(".");
//                }
//            }
//            System.out.println();
//        }
        heightAdditions = heightAdditions.stream().limit(heightAdditions.size() - 5).toList();
        System.out.println("I: " + i);
        System.out.println("Highest: " + (highest + 1 - subtracting));
        System.out.println("Repetition: " + heightAdditions.size());
        int loopSum = heightAdditions.stream().reduce(0, Integer::sum);
        int remSum = heightAdditions.stream()
            .limit((1000000000000L - i + 4) % heightAdditions.size())
            .reduce(0, Integer::sum);
        System.out.println(loopSum * ((1000000000000L - i + 4) / heightAdditions.size()) + highest + 1 - subtracting + remSum);
    }

    private static boolean rockTouchingOtherRock(Set<Point> rocksPoints, Rock rock) {
        for (Point p : rock.points()) {
            if (rocksPoints.contains(new Point(p.getX(), p.getY() - 1))) {
                return true;
            }
        }
        return false;
    }

    private static boolean rockAtBottom(Rock rock) {
        return rock.bottomEdge().get(0).getY() == 0;
    }
}
