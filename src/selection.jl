include("types.jl")
include("linear_scaling.jl")

function selection_random( pop :: _population )
    new_guys = []
    for _ in 1:pop.size
        i = rand(1:pop.size)
        push!(new_guys, clone(pop.individuals[i]))
    end

    pop.individuals = new_guys
end

function selection_roulette_linear_scalling( pop :: _population )
    C = (pop.Clast - pop.Cfirst) * pop.Citer + pop.Cfirst

    #=@printf(STDERR, "C: %4.2f  Last: %4.2f  First: %4.2f  iter: %4.2f  \n", C, pop.Clast, pop.Cfirst, pop.Citer)=#

    tfit = [ (x -> x.fitness)(f) for f in pop.individuals ]
    #=print(tfit)=#
    a, b = get_alpha_beta(C, tfit)
    scaled_fit = get_scaled_fit(C, tfit)
    total = foldr(+, scaled_fit)

    new_guys = []
    for _ in 1:pop.size

        p = rand()
        c = 0.0
        i = 0

        while c < p
            i += 1
            c += scaled_fit[i] / total
        end

        push!(new_guys, clone(pop.individuals[i]))
    end

    pop.individuals = new_guys
end

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
    k = pop.tourney_size

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

