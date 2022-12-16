<?php
// brute force solution :p
// takes about a minute to complete
ini_set('memory_limit', '1G');

define("MAX_COORD", 4000000);
define("MIN_COORD", 0);

require_once './point.php';
require_once './parse_input.php';

class Sensor
{
    private Point $location;
    private Point $beacon;
    private int $max_dist;

    function __construct(Point $location, Point $beacon)
    {
        $this->location = $location;
        $this->beacon = $beacon;
        $this->max_dist = $this->distanceFromBeacon();
    }

    function getLocation(): Point
    {
        return $this->location;
    }

    function getBeacon(): Point
    {
        return $this->beacon;
    }

    private function distanceFromBeacon(): int
    {
        return Point::manhattanDist($this->location, $this->beacon);
    }

    private function addPointIfInRange(Point $p, array &$points)
    {
        if (
            $p->getX() <= MAX_COORD && $p->getX() >= MIN_COORD &&
            $p->getY() <= MAX_COORD && $p->getY() >= MIN_COORD
        ) {
            $points[] = $p;
        }
    }

    function perimeterPoints(): array
    {
        $points = array();

        $curr_point = new Point($this->location->getX(), $this->location->getY() + $this->max_dist + 1);

        // clockwise motion, from 12 to 3 o'clock.
        while ($curr_point->getY() >= $this->location->getY()) {
            $this->addPointIfInRange($curr_point, $points);
            $curr_point = new Point($curr_point->getX() + 1, $curr_point->getY() - 1);
        }
        // 3 to 6 o'clock
        while ($curr_point->getX() >= $this->location->getX()) {
            $this->addPointIfInRange($curr_point, $points);
            $curr_point = new Point($curr_point->getX() - 1, $curr_point->getY() - 1);
        }
        // 6 to 9 o'clock
        while ($curr_point->getY() <= $this->location->getY()) {
            $this->addPointIfInRange($curr_point, $points);
            $curr_point = new Point($curr_point->getX() - 1, $curr_point->getY() + 1);
        }
        // 9 to 12 o'clock
        while ($curr_point->getX() < $this->location->getX()) {
            $this->addPointIfInRange($curr_point, $points);
            $curr_point = new Point($curr_point->getX() + 1, $curr_point->getY() + 1);
        }

        return $points;
    }

    function doesCoverPoint(Point $p): bool
    {
        if (Point::manhattanDist($this->location, $p) <= $this->max_dist) {
            return true;
        }
        return false;
    }
}

$sensors = parse_input();

for ($i = 0; $i < count($sensors); $i++) {
    $points = $sensors[$i]->perimeterPoints();

    for ($j = 0; $j < count($points); $j++) {
        $covered = false;

        for ($k = 0; $k < count($sensors); $k++) {
            $covered = $sensors[$k]->doesCoverPoint($points[$j]);
            if ($covered) {
                break;
            }
        }
        if (!$covered) {
            $result = $points[$j]->getX() * MAX_COORD + $points[$j]->getY();
            echo $result . "\n";
            break 2;
        }
    }
}
