include("types.jl")
include("population.jl")
include("selection.jl")
include("objective_functions.jl")

Base.isless(x :: _individual, y :: _individual) = (x.fitness) < (y.fitness)

function main()
    pop = spawn_empty_population()
    pop.size = 10
    pop.n_genes = 10
    pop.mchance = 0.05
    pop.cchance = 0.75
    pop.crossover_function = crossover_uniform
    pop.selection_function = selection_ktourney

    #=pop.objective_function = objf_alternating_parity=#
    #=pop.objective_function = objf_alternating_bit=#
    pop.objective_function = objf_sphere

    pop.fitness_function   = fitness_sphere
    #=pop.fitness_function   = fitness_identity=#

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            #=new_gene = _gene(true, false, false, false, false, true, false)=#
            new_gene = _gene(false, true, false, false, -50.0, 50.0, 0.0)
            #=new_gene = _gene(false, false, true, false, 0, 10, 0)=#
            #=new_gene = _gene(false, false, false, true, 0, 10, 0)=#
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    init_population(pop)

    print_pop(pop)
    println()
    evaluate(pop)

    for iter in 1:20
        evaluate(pop)

        #=print_pop(pop)=#
        #=println()=#

        #=if iter % 10 == 0=#
            #=println("$iter")=#
        #=end=#

        selection(pop)
        crossover(pop)
        mutation(pop)
    end

    print_pop(pop)
    println()

    return
end

@time main()
