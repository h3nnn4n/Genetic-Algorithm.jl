using StatsBase

include("types.jl")
include("distance.jl")


function crowding( pop :: _population, new_guys )
    pop.crowding_factor_on && pop.crowding < 2 &&
      throw(ArgumentError("crowding_factor_on is set but crowding is $(pop.crowding). Use a value bigger than 1"))

    if pop.crowding_factor_on
        for i in 1:pop.size
            some_guys = sample(1:pop.size, pop.crowding, replace=false)
            divers    = [distance(pop.individuals[i], new_guys[some_guys[j]]) for j in 1:pop.crowding]

            index  = some_guys[1]
            best   = divers[1]

            for j in 2:pop.crowding
                if divers[j] < best
                    best = divers[j]
                    index = some_guys[j]
                end
            end

            pop.individuals[i] = new_guys[index]
        end
    else
        pop.individuals = new_guys
    end
end

