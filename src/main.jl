include("types.jl")
include("population.jl")

# Done:
# k-elitism
#
# Xovers:
# - Uniform xover (bin, int, real)
# - 1-point xover (bin, int, real)
#
# Mutation:
# - bit-flip (bin)
# - delta, gaussian (real)
# - delta, gaussian (int)
#
# Selection:
# - k-tourney
# - roulette

# TODO
# - Everything about permutations
# - diversity plot
# - BLX (real)
# - PMX, CX (xover, permut)
# - 2swap (permut)

function fitness_alternating_bit( ind :: _individual )
    #=fit = 0.0 :: Float32=#
    fit = 0.0

    for i in 2:ind.n_genes
        if ind.genetic_code[i].value $ ind.genetic_code[i - 1].value
            fit += 1
        end
    end

    ind.fitness = fit
end

function fitness_alternating_parity( ind :: _individual )
    #=fit = 0 :: Float32=#
    fit = 0.0

    for i in 2:ind.n_genes
        if (ind.genetic_code[i].value % 2) != (ind.genetic_code[i - 1].value % 2)
            fit += 1
        end
    end

    ind.fitness = fit
end

function fitness_sphere( ind :: _individual )
    #=fit = 0.0 :: Float32=#
    fit = 0.0

    for i in 1:ind.n_genes
        fit += ind.genetic_code[i].value ^ 2.0
    end

    #=fit *= -1.0=#

    #=fit = (ind.genetic_code[1].ub - ind.genetic_code[1].lb) ^ (ind.n_genes) - fit=#
    #=fit /= (ind.genetic_code[1].ub - ind.genetic_code[1].lb) ^ (ind.n_genes)=#

    ind.fitness = fit
end

function main()
    pop = spawn_empty_population()
    pop.size = 10
    pop.n_genes = 10
    pop.mchance = 0.05
    pop.cchance = 0.75

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, [])
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

    for iter in 1:100
        #=evaluate(pop, fitness_alternating_parity)=#
        #=evaluate(pop, fitness_alternating_bit)=#
        evaluate(pop, fitness_sphere)

        print_pop(pop)
        println()

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
