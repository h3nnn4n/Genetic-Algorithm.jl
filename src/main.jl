include("types.jl")
include("population.jl")
include("selection.jl")
include("objective_functions.jl")

Base.isless(x :: _individual, y :: _individual) = (x.fitness) < (y.fitness)

function main()
    pop = spawn_empty_population()
    pop.size = 40
    pop.n_genes = 20
    pop.mchance = 0.05
    pop.cchance = 0.75
    pop.tourney_size = 2
    pop.kelitism = 2

    #=pop.crossover_function = crossover_uniform=#
    #=pop.crossover_function = crossover_one_point=#
    pop.crossover_function = crossover_blx

    #=pop.selection_function = selection_ktourney=#
    pop.selection_function = selection_roulette
    #=pop.selection_function = selection_random=#

    #=pop.objective_function = objf_alternating_parity=#
    #=pop.objective_function = objf_alternating_bit=#
    #=pop.objective_function = objf_sphere=#
    pop.objective_function = objf_rosen

    pop.fitness_function   = fitness_sphere
    #=pop.fitness_function   = fitness_identity=#

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            #=new_gene = _gene(true, false, false, false, false, true, false)=#
            #=new_gene = _gene(false, true, false, false, -50.0, 50.0, 0.0)=#
            new_gene = _gene(false, true, false, false, -2.0, 2.0, 0.0)
            #=new_gene = _gene(false, true, false, false, -10.0, 10.0, 0.0)=#
            #=new_gene = _gene(false, false, true, false, 0, 10, 0)=#
            #=new_gene = _gene(false, false, false, true, 0, 10, 0)=#
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    init_population(pop)

    pop.objective_function(pop.individuals[1])

    pop.min_objf = pop.individuals[1].obj_f
    pop.max_objf = pop.individuals[1].obj_f

    best_ever = pop.individuals[1]

    for iter in 1:5000
        evaluate(pop)

        for i in 1:pop.size
            if pop.individuals[i].fitness > best_ever.fitness
                best_ever = clone(pop.individuals[i])
            end
        end

        elite = elitism_get(pop)

        #=print_pop(pop)=#
        #=println()=#

        print_status(pop)
        #=if iter % 1000 == 0=#
            #=print_status(pop)=#
            #=println()=#
            #=println("$iter")=#
        #=end=#

        selection(pop)
        crossover(pop)
        mutation(pop)

        elitism_put_back(pop, elite)
    end

    #=print_pop(pop)=#
    #=println("$(best_ever.fitness) $(best_ever.obj_f)")=#
    println()

    return
end

@time main()
