include("types.jl")
include("distance.jl")

function fitness_sharing( pop :: _population )
    if !pop.fitness_sharing_on
        return
    end

    dists = zeros(pop.size, pop.size)
    sd    = zeros(pop.size, pop.size)

    max = 0

    for i in 1:pop.size, j in 1:pop.size
        if j > i
            continue
        else
            dists[j, i] = dists[i, j] = distance(pop.individuals[i], pop.individuals[j])
        end
    end

    max = maximum(dists)

    dists = dists ./ max

    for i in 1:pop.size, j in 1:pop.size
        if j > i
            continue
        else
            if dists[i, j] > pop.fitness_sharing_sigma
                sd[i, j] = 0.0
                sd[j, i] = 0.0
            else
                sd[i, j] = 1.0 - ((dists[i, j]/pop.fitness_sharing_sigma) ^ pop.fitness_sharing_alpha)
                sd[j, i] = 1.0 - ((dists[i, j]/pop.fitness_sharing_sigma) ^ pop.fitness_sharing_alpha)
            end
        end
    end

    for i in 1:pop.size
        pop.individuals[i].fitness = pop.individuals[i].fitness / sum([(sd[i, j]) for j in 1:pop.size])
    end
end

