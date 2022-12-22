include("points.jl")

println(
    reduce(+,
        reduce(+,
            (neighbour in points) ? 0 : 1 for neighbour in neighbours(p)
        ) for p in points
    )
)
