#using Images
#using ImageView
#using Colors
#using TestImages

include("types.jl")
include("population.jl")
include("selection.jl")
include("objective_functions.jl")
include("utils.jl")

Base.isless(x :: _individual, y :: _individual) = (x.fitness) < (y.fitness)

function evolutionary_loop( pop :: _population )
    init_population(pop)

    pop.objective_function(pop.individuals[1])

    pop.min_objf = pop.individuals[1].obj_f
    pop.max_objf = pop.individuals[1].obj_f

    best_ever = pop.individuals[1]

    #=evaluate(pop)=#
    #=print_pop(pop)=#

    for iter in 1:pop.max_iter
        evaluate(pop)
        pop.Citer = iter / pop.max_iter

        for i in 1:pop.size
            if pop.individuals[i].fitness > best_ever.fitness
                best_ever = clone(pop.individuals[i])
            end
        end

        elite = elitism_get(pop)

        #=if iter % 100 == 0=#
            #=@printf(STDERR, "%d %f\n", iter, best_ever.fitness)=#
        #=end=#

        print("$iter ")
        print_status(pop)
        #=@printf("min, max = %f %f\n", pop.min_objf, pop.max_objf)=#

        #=print_pop(pop)=#
        #=println()=#

        #=if iter % 1000 == 0=#
            #=print_status(pop)=#
            #=println()=#
            #=println("$iter")=#
        #=end=#

        selection(pop)
        crossover(pop)
        mutation(pop)

        elitism_put_back(pop, elite)
        #=name = @sprintf("kappa_%02d.png", iter)=#

        #=img_final = [ (Float32(i.value)) for i in best_ever.genetic_code ] # :: Array{Float32}=#
        #=img_final2 = convert(Array{Gray{Float32}}, reshape(img_final, res, res))=#
        #=save(name, img_final2)=#
    end

    return pop, best_ever
end

function main()
    #=println("Starting")=#
    res = 100
    pop = spawn_empty_population()
    pop.size = 50
    pop.max_iter = 500
    #=pop.n_genes = res*res=#
    pop.n_genes = res
    pop.mchance = 0.02
    pop.cchance = 0.90
    pop.tourney_size = 2
    #=pop.kelitism = Int(ceil((res*res) * 0.15))=#
    pop.kelitism = 1
    pop.Cfirst   = 1.2
    pop.Clast    = 2.0
    pop.Cfirst   = 2.0
    pop.Clast    = 1.2

    #=pop.crossover_function = crossover_pmx=#
    #=pop.crossover_function = crossover_uniform=#
    #=pop.crossover_function = crossover_rand_points=#
    #=pop.crossover_function = crossover_one_point=#
    pop.crossover_function = crossover_blx

    #=pop.selection_function = selection_ktourney=#
    pop.selection_function = selection_roulette
    #=pop.selection_function = selection_roulette_linear_scalling=#
    #=pop.selection_function = selection_random=#

    #=pop.objective_function = objf_alternating_parity=#
    #=pop.objective_function = objf_alternating_bit=#
    #=pop.objective_function = objf_sphere=#
    pop.objective_function = objf_rosen
    #=pop.objective_function = objf_nqueens=#
    #=pop.objective_function = objf_nqueens_int=#
    #=pop.objective_function = objf_img=#
    #=pop.objective_function = objf_path=#

    pop.fitness_function   = fitness_sphere
    #=pop.fitness_function   = fitness_nqueens=#
    #=pop.fitness_function   = fitness_identity=#
    #=pop.fitness_function   = fitness_normalized_ub=#
    #=pop.fitness_function   = fitness_super_normalizer=#

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            new_gene = _gene(real, -2.6, 2.6, 0.0)
            #=new_gene = _gene(bool, false, true, 0.0)=#
            #=new_gene = _gene(int, 1, 4, 0)=#
            #=new_gene = _gene(permut, 1, res, 0)=#
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    result, best_ever = evolutionary_loop( pop )

    #=len, full = path_length(best_ever)=#
    #=@printf(STDERR, "len = %3d   complete = %s\n", len, full ? "yes" : "no")=#

    #=print_path(best_ever)=#

    return
end

@time main()
