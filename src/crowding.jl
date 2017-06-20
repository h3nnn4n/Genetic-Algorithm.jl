include("types.jl")
include("distance.jl")


function crowding( pop :: _population, new_guys )
    pop.crowding_factor_on && pop.crowding < 2 &&
      throw(ArgumentError("crowding_factor_on is set but crowding is $(pop.crowding). Use a value bigger than 1"))

    if pop.crowding_factor_on
        for i in 1:pop.size
            some_guys = [rand(1:pop.size) for _ in 1:pop.crowding] :: Array{Int, 1}
            divers    = [distance(pop.individuals[i], new_guys[some_guys[j]]) for j in 1:pop.crowding]

            index  = some_guys[1]
            jindex = 1
            best   = divers[1]

            for j in 2:pop.crowding
                if divers[j] < best
                    best = divers[j]
                    index = some_guys[j]
                    jindex = j
                end
            end

            #=println("\n $i")=#
            #=println(some_guys)=#
            #=println(divers)=#
            #=println("$i $jindex $best")=#

            #=pop.individuals[i] = clone(new_guys[jindex])=#
            #=pop.individuals[i] = new_guys[some_guys[jindex]]=#
            pop.individuals[i] = new_guys[index]
        end
    else
        pop.individuals = new_guys
    end
end

