<?php
class Point
{
    private int $x;
    private int $y;

    function __construct(int $x, int $y)
    {
        $this->x = $x;
        $this->y = $y;
    }

    function getX(): int
    {
        return $this->x;
    }

    function getY(): int
    {
        return $this->y;
    }

    function __toString(): string
    {
        return "Point(" . $this->x .  "," . $this->y . ")";
    }

    static function manhattanDist(Point $a, Point $b): int
    {
        return abs($a->getX() - $b->getX()) +
            abs($a->getY() - $b->getY());
    }
}
