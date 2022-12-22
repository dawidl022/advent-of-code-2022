import Base.:*
include("points.jl")

faces = [
    Point(-1, 0, 0), Point(+1, 0, 0),
    Point(0, -1, 0), Point(0, +1, 0),
    Point(0, 0, -1), Point(0, 0, +1)
]

function *(p::Point, c::Int)
    return Point(p.x * c, p.y * c, p.z * c)
end

function neighbours(p::Point)
    [
        Point(p.x - 1, p.y, p.z), Point(p.x + 1, p.y, p.z),
        Point(p.x, p.y - 1, p.z), Point(p.x, p.y + 1, p.z),
        Point(p.x, p.y, p.z - 1), Point(p.x, p.y, p.z + 1)
    ]
end

function is_air_bubble(p::Point, allPoints::Set{Point}, memo::Dict{Point,Bool})
    println("Checking $p")
    if p in keys(memo)
        return memo[p]
    end

    for face in faces
        if is_outer_point(p, face, allPoints)
            return false
        end
    end
    nei_count = 0
    for neighbour in neighbours(p)
        if neighbour in allPoints || is_air_bubble(neighbour, union(allPoints, Set([p])), memo)
            nei_count += 1
        end
    end
    memo[p] = nei_count == 6
    if nei_count == 6
        println("is air bublle $p")
    end
    return nei_count == 6
end

function is_outer_point(p::Point, face::Point, allPoints::Set{Point})
    max_point = face * 20
    if face.x == -1
        while p.x > face.x * 20
            p = Point(p.x - 1, p.y, p.z)
            if p in allPoints
                return false
            end
        end
    elseif face.x == 1
        while p.x < face.x * 20
            p = Point(p.x + 1, p.y, p.z)
            if p in allPoints
                return false
            end
        end
    elseif face.y == -1
        while p.y > face.y * 20
            p = Point(p.x, p.y - 1, p.z)
            if p in allPoints
                return false
            end
        end
    elseif face.y == 1
        while p.y < face.y * 20
            p = Point(p.x, p.y + 1, p.z)
            if p in allPoints
                return false
            end
        end
    elseif face.z == -1
        while p.z > face.z * 20
            p = Point(p.x, p.y, p.z - 1)
            if p in allPoints
                return false
            end
        end
    elseif face.z == 1
        while p.z < face.z * 20
            p = Point(p.x, p.y, p.z + 1)
            if p in allPoints
                return false
            end
        end
    else
        throw("Unhandled branch")
    end
    true
end

surface_area = 0
memo = Dict{Point,Bool}()
for p in points
    for neighbour in neighbours(p)
        if !(neighbour in points) && !is_air_bubble(neighbour, points, memo)
            global surface_area += 1
        end
    end
end

println(surface_area)
