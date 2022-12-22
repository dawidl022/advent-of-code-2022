include("points.jl")

function neighbours(p::Point)
    [
        Point(p.x - 1, p.y, p.z), Point(p.x + 1, p.y, p.z),
        Point(p.x, p.y - 1, p.z), Point(p.x, p.y + 1, p.z),
        Point(p.x, p.y, p.z - 1), Point(p.x, p.y, p.z + 1)
    ]
end

println(
    reduce(+, [
        reduce(+, [
            (neighbour in points) ? 0 : 1 for neighbour in neighbours(p)
        ]) for p in points
    ])
)
