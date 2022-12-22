struct Point
    x::Int
    y::Int
    z::Int
end

points = Set(map(sstring -> Point(
        parse(Int, sstring[1]),
        parse(Int, sstring[2]),
        parse(Int, sstring[3])
    ), split.(chomp.(readlines()), ",")))
