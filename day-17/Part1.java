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

            while (gasPushing || !rockAtBottom(rock) && !rockTouchingOtherRock(rocksPoints, rock)) {
                if (gasPushing) {
                    Direction dirToMove = gasSource.next();
                    if (dirToMove == Direction.LEFT) {
                        rock.move(-1, 0);
                        for (Point p: rock.points()) {
                            if (rocksPoints.contains(p)) {
                                rock.move(1, 0);
                                break;
                            }
                        }
                    } else {
                        rock.move(1, 0);
                        for (Point p: rock.points()) {
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


            if (rock.highest() > highest) {
                highest = rock.highest();
            }
            rocksPoints.addAll(rock.points());

        }
        System.out.println(highest + 1);
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
