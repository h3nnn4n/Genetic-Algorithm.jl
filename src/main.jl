#using Images
#using ImageView
#using Colors
#using TestImages

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

        @printf("%6d ", iter)
        print_status(pop)
        @printf("%8d %4d \n", best_ever.obj_f, getGap(pop))

        genGap = gengap_get(pop)

        #=println("sel hue", pop.selection_function)=#
        selection(pop)
        crossover(pop)
        mutation(pop)

        gengap_put_back(pop, genGap)

        elitism_put_back(pop, elite)
    end

    return pop, best_ever
end

function main()
    #=println("Starting")=#
    res = 20
    nbits = 3
    pop = spawn_empty_population()
    pop.size = 50
    pop.max_iter = 500
    #=pop.n_genes = res*res=#
    pop.n_genes = res * nbits
    pop.mchance = 0.005
    pop.cchance = 0.95
    pop.tourney_size = 2
    pop.kelitism = Int(ceil((res*res) * 0.10))
    pop.kelitism = 1

    pop.crowding_factor_on = true
    pop.crowding = 5

    pop.fitness_sharing_on = true
    pop.fitness_sharing_sigma = 0.255
    pop.fitness_sharing_alpha = 1.05

    pop.Cfirst   = 1.2
    pop.Clast    = 2.0

    pop.genGapfirst   = 0.9
    pop.genGaplast    = 0.0
    pop.genGapiter    = 0.0

    change_f3_size(res)
    change_deceptiveN_size(res, nbits)

    #=pop.crossover_function = crossover_pmx=#
    #=pop.crossover_function = crossover_uniform=#
    pop.crossover_function = crossover_rand_points
    #=pop.crossover_function = crossover_one_point=#
    #=pop.crossover_function = crossover_blx=#

    #=pop.selection_function = selection_ktourney=#
    pop.selection_function = selection_roulette
    #=pop.selection_function = selection_roulette_linear_scalling=#
    #=pop.selection_function = selection_random=#
    #=pop.selection_function = selection_nothing=#

    #=pop.objective_function = objf_alternating_parity=#
    #=pop.objective_function = objf_alternating_bit=#
    #=pop.objective_function = objf_sphere=#
    #=pop.objective_function = objf_rosen=#
    #=pop.objective_function = objf_nqueens=#
    #=pop.objective_function = objf_nqueens_int=#
    #=pop.objective_function = objf_img=#
    #=pop.objective_function = objf_path=#
    pop.objective_function = objf_f3
    #=pop.objective_function = objf_f3s=#
    #=pop.objective_function = objf_deceptiveN=#

    #=pop.fitness_function   = fitness_sphere=#
    #=pop.fitness_function   = fitness_nqueens=#
    pop.fitness_function   = fitness_identity
    #=pop.fitness_function   = fitness_normalized_ub=#
    #=pop.fitness_function   = fitness_normalized_lb=#
    #=pop.fitness_function   = fitness_super_normalizer=#

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            #=new_gene = _gene(real, -2.6, 2.6, 0.0)=#
            new_gene = _gene(bool, false, true, 0.0)
            #=new_gene = _gene(int, 1, 4, 0)=#
            #=new_gene = _gene(permut, 1, res, 0)=#
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    result, best_ever = evolutionary_loop( pop )

    genes = [(x -> x.value)(i) for i in best_ever.genetic_code]

    for i in 1:length(genes)
        @printf(STDERR, "%d", ((genes[i])?:1:0))
        if mod(i, nbits) == 0
            @printf(STDERR, " ")
        end
        #=print("$(i?:1:0) ")=#
    end
    @printf(STDERR, " = %f\n", best_ever.obj_f)

    #=len, full = path_length(best_ever)=#
    #=@printf(STDERR, "len = %3d   complete = %s\n", len, full ? "yes" : "no")=#

    #=print_path(best_ever)=#

    return
end

main()
