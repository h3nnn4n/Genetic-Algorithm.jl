include("types.jl")
include("fitness_sharing.jl")
include("elitism.jl")
include("gengap.jl")
include("population.jl")
include("selection.jl")
include("objective_functions.jl")
include("utils.jl")
include("crowding.jl")

Base.isless(x :: _individual, y :: _individual) = (x.fitness) < (y.fitness)

function evolutionary_loop( pop :: _population )
    data_iter          = [ 0   for _ in 1:pop.max_iter ]
    data_objf_max_ever = [ 0.0 for _ in 1:pop.max_iter ]
    data_objf_max      = [ 0.0 for _ in 1:pop.max_iter ]
    data_objf_avg      = [ 0.0 for _ in 1:pop.max_iter ]
    data_diver         = [ 0.0 for _ in 1:pop.max_iter ]
    data_fit_max       = [ 0.0 for _ in 1:pop.max_iter ]
    data_fit_avg       = [ 0.0 for _ in 1:pop.max_iter ]

    init_population(pop)

    pop.objective_function(pop.individuals[1])

    pop.min_objf = pop.individuals[1].obj_f
    pop.max_objf = pop.individuals[1].obj_f

    best_ever = pop.individuals[1]

    for iter in 1:pop.max_iter
        evaluate(pop)

        oldC = getGap(pop)
        pop.Citer = iter / pop.max_iter
        pop.genGapiter = iter / pop.max_iter

        if oldC != getGap(pop) && pop.genGapfirst > 0 && pop.genGaplast > 0
            shuffle!(pop.individuals)
        end

        if pop.fitness_sharing_on
            fitness_sharing( pop )
        end

        for i in 1:pop.size
            if pop.fitness_sharing_on
                if pop.individuals[i].obj_f > best_ever.obj_f
                    best_ever = clone(pop.individuals[i])
                end
            else
                if pop.individuals[i].fitness > best_ever.fitness
                    best_ever = clone(pop.individuals[i])
                end
            end
        end

        elite = elitism_get(pop)

        data_iter[iter]          = iter
        data_objf_max_ever[iter] = best_ever.obj_f
        data_fit_max[iter], data_fit_avg[iter], data_diver[iter], data_objf_max[iter], data_objf_avg[iter] = get_pop_status( pop )


        if iter % Int(pop.max_iter/10) == 0
            @printf(STDERR, "%6d\n", iter)
        end

        #=@printf("%6d ", iter)=#
        #=print_status(pop)=#
        #=@printf("%8d %4d \n", best_ever.obj_f, getGap(pop))=#

        genGap = gengap_get(pop)

        selection(pop)
        crossover(pop)
        mutation(pop)

        gengap_put_back(pop, genGap)

        elitism_put_back(pop, elite)
    end

    #=return pop, best_ever=#
    return (data_iter, data_objf_max_ever, data_objf_max, data_objf_avg, data_diver, data_fit_max, data_fit_avg)
end
