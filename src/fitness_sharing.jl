include("types.jl")
include("population.jl") # To get the distance

function fitness_sharing( pop :: _population )
    dists = zeros(pop.size, pop.size)

    max = 0

    for i in 1:pop.size
        for j in 1:pop.size
            dists[i, j] = distance(pop.individuals[i], pop.individuals[j])
        end
    end

    max = maximum(dists)

    dists = dists ./ max

    display(dists)

    exit()
end

