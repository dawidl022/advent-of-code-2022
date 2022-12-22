import Base.:*
import Base.:+
include("points.jl")

function *(p::Point, c::Int)
    return Point(p.x * c, p.y * c, p.z * c)
end

function +(p1::Point, p2::Point)
    return Point(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)
end

function is_constaintrained_by(p::Point, face::Point)
    if face.x < 0
        p.x > face.x
    elseif face.x > 0
        p.x < face.x
    elseif face.y < 0
        p.y > face.y
    elseif face.y > 0
        p.y < face.y
    elseif face.z < 0
        p.z > face.z
    elseif face.z > 0
        p.z < face.z
    else
        throw("Unexpected branch")
    end
end

faces = [
    Point(-1, 0, 0), Point(+1, 0, 0),
    Point(0, -1, 0), Point(0, +1, 0),
    Point(0, 0, -1), Point(0, 0, +1)
]

function is_air_bubble(p::Point, allPoints::Set{Point}, memo::Dict{Point,Bool})
    if p in keys(memo)
        return memo[p]
    end

    if any(
        is_outer_point(p, face, allPoints)
        for face in faces
    )
        return false
    end

    memo[p] = all(
        neighbour in allPoints || is_air_bubble(
            neighbour, union(allPoints, Set([p])), memo
        )
        for neighbour in neighbours(p)
    )
end

function is_outer_point(p::Point, face::Point, allPoints::Set{Point})
    max_point = face * 20
    while is_constaintrained_by(p, max_point)
        p += face
        if p in allPoints
            return false
        end
    end
    true
end


memo = Dict{Point,Bool}()

println(
    reduce(+,
        reduce(+,
            (neighbour in points) || is_air_bubble(neighbour, points, memo) ?
            0 :
            1
            for neighbour in neighbours(p)
        ) for p in points
    )
)
