include("types.jl")

function selection_roulette( pop :: _population )
    total = mapfoldr(x -> x.fitness, +, pop.individuals)

    new_guys = []
    for _ in 1:pop.size

        p = rand()
        c = 0.0
        i = 0

        while c < p
            i += 1
            c += pop.individuals[i].fitness / total
        end

        push!(new_guys, clone(pop.individuals[i]))
    end

    pop.individuals = new_guys
end

function selection_ktourney( pop :: _population )
    k = 2

    new_guys = []
    for _ in 1:pop.size
        best_i = rand(1:pop.size)
        for _ in 1:k
            n = rand(1:pop.size)
            if pop.individuals[best_i].fitness < pop.individuals[n].fitness
                best_i = n
            end
        end
        push!(new_guys, clone(pop.individuals[best_i]))
    end

    pop.individuals = new_guys
end

