<?php

function parse_input(): array
{
    $input_regex = "/Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)/";
    $sensors = array();

    while (!feof(STDIN)) {
        $input = trim(fgets(STDIN));
        if (preg_match($input_regex, $input, $matches)) {
            $location = new Point(intval($matches[1]), intval($matches[2]));
            $closestBeacon = new Point(intval($matches[3]), intval($matches[4]));
            $sensors[] = new Sensor($location, $closestBeacon);
        }
    }
    return $sensors;
}
