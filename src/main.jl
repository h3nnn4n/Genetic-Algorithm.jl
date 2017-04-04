include("types.jl")
include("population.jl")

function fitness( ind :: _individual )
    fit = 0 :: Int64
    for i in 2:ind.n_genes
        if (ind.genetic_code[i].value % 2) != (ind.genetic_code[i - 1].value % 2)
            fit += 1
        end
    end

    ind.fitness = fit
end

function main()
    pop = spawn_empty_population()
    pop.size = 10
    pop.n_genes = 5
    pop.mchance = 0.05
    pop.cchance = 0.75

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, [])
        for j in 1:pop.n_genes
            #=new_gene = _gene(true, false, false, false, false, true, false)=#
            #=new_gene = _gene(false, true, false, false, 0.0, 1.0, 0.0)=#
            new_gene = _gene(false, false, true, false, 0, 10, 0)
            #=new_gene = _gene(false, false, false, true, 0, 10, 0)=#
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    init_population(pop)

    for iter in 1:5
        evaluate(pop, fitness)

        print_pop(pop)
        println()

        selection(pop)
        crossover(pop)
        mutation(pop)
    end

    return
end

@time main()
