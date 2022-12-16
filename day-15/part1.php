<?php
// brute force solution :p
// takes a couple of seconds to complete
ini_set('memory_limit', '2G');

require_once './point.php';
require_once './parse_input.php';

class Sensor
{
    private Point $location;
    private Point $beacon;

    function __construct(Point $location, Point $beacon)
    {
        $this->location = $location;
        $this->beacon = $beacon;
    }

    function getLocation(): Point
    {
        return $this->location;
    }

    function getBeacon(): Point
    {
        return $this->beacon;
    }

    function distanceFromBeacon(): int
    {
        return Point::manhattanDist($this->location, $this->beacon);
    }

    function pointsCovered(int $y): array
    {
        $points = array();
        $curr_point = new Point($this->location->getX(), $y);
        $max_dist = $this->distanceFromBeacon();

        if (Point::manhattanDist($this->location, $curr_point) <= $max_dist) {
            $points[] = $curr_point;
            $points = array_merge(
                $points,
                $this->pointsCoveredLeft($y),
                $this->pointsCoveredRight($y)
            );
        }

        return $points;
    }

    private function pointsCoveredLeft(int $y): array
    {
        $points = array();
        $curr_point = new Point($this->location->getX() - 1, $y);
        $max_dist = $this->distanceFromBeacon();

        while (Point::manhattanDist($this->location, $curr_point) <= $max_dist) {
            $points[] = $curr_point;
            $curr_point = new Point($curr_point->getX() - 1, $y);
        }

        return $points;
    }

    private function pointsCoveredRight(int $y): array
    {
        $points = array();
        $curr_point = new Point($this->location->getX() + 1, $y);
        $max_dist = $this->distanceFromBeacon();

        while (Point::manhattanDist($this->location, $curr_point) <= $max_dist) {
            $points[] = $curr_point;
            $curr_point = new Point($curr_point->getX() + 1, $y);
        }

        return $points;
    }
}

$sensors = parse_input();

$covered = array();
$beacons = array();
$y = 2000000;

for ($i = 0; $i < count($sensors); $i++) {
    $covered = array_merge($covered, $sensors[$i]->pointsCovered($y));
    if ($sensors[$i]->getBeacon()->getY() == $y) {
        $beacons[] = $sensors[$i]->getBeacon();
    }
}

echo count(array_diff(array_unique($covered), $beacons)) . "\n";
