include("types.jl")
include("population.jl")

function fitness( ind :: _individual )
    return 0.0
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

    print_pop(pop)
    println()

    for iter in 1:5
        selection(pop)
        crossover(pop)
        mutation(pop)
        print_pop(pop)
        println()
    end

    return
end

@time main()
