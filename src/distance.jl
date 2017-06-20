include("types.jl")


distance(a :: _individual, b :: _individual) = mapfoldr((x) -> (x[1].value - x[2].value) ^ 2 , +, collect(zip(a.genetic_code, b.genetic_code)))
