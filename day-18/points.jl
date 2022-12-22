struct Point
    x::Int
    y::Int
    z::Int
end

function neighbours(p::Point)
    [
        Point(p.x - 1, p.y, p.z), Point(p.x + 1, p.y, p.z),
        Point(p.x, p.y - 1, p.z), Point(p.x, p.y + 1, p.z),
        Point(p.x, p.y, p.z - 1), Point(p.x, p.y, p.z + 1)
    ]
end

points = Set(map(sstring -> Point(
        parse(Int, sstring[1]),
        parse(Int, sstring[2]),
        parse(Int, sstring[3])
    ), split.(chomp.(readlines()), ",")))
