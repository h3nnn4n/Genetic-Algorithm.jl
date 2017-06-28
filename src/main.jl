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
include("evo_loop.jl")

function main()
    #=println("Starting")=#
    res = 8
    nbits = 1
    pop = spawn_empty_population()
    pop.size = 50
    pop.max_iter = 1000
    #=pop.n_genes = res*res=#
    pop.n_genes = res * nbits
    pop.mchance = 0.005
    pop.cchance = 0.9
    pop.tourney_size = 2
    pop.kelitism = 1

    pop.crowding_factor_on = false
    pop.crowding = 45

    pop.fitness_sharing_on = false
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
    #=pop.crossover_function = crossover_rand_points=#
    pop.crossover_function = crossover_one_point
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
    pop.objective_function = objf_path
    #=pop.objective_function = objf_f3=#
    #=pop.objective_function = objf_f3s=#
    #=pop.objective_function = objf_deceptiveN=#

    #=pop.fitness_function   = fitness_sphere=#
    #=pop.fitness_function   = fitness_nqueens=#
    #=pop.fitness_function   = fitness_identity=#
    #=pop.fitness_function   = fitness_normalized_ub=#
    #=pop.fitness_function   = fitness_normalized_fixed_ub=#
    #=pop.fitness_function   = fitness_normalized_lb=#
    pop.fitness_function   = fitness_super_normalizer

    set_fitness_ub( res  * nbits * 30 )

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            #=new_gene = _gene(real, -2.6, 2.6, 0.0)=#
            #=new_gene = _gene(bool, false, true, 0.0)=#
            #=new_gene = _gene(int, 1, 4, 0)=#
            #=new_gene = _gene(permut, 1, res, 0)=#
            new_gene = _gene(int, 1, res, 0)
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    result, best_ever = evolutionary_loop( pop )

    #=genes = [(x -> x.value)(i) for i in best_ever.genetic_code]=#

    #=for i in 1:length(genes)=#
        #=@printf(STDERR, "%d", ((genes[i])))=#
        #=if mod(i, nbits) == 0=#
            #=@printf(STDERR, " ")=#
        #=end=#
        #=[>print("$(i?:1:0) ")<]=#
    #=end=#
    #=@printf(STDERR, " = %f\n", best_ever.obj_f)=#

    #=len, full = path_length(best_ever)=#
    #=@printf(STDERR, "len = %3d   complete = %s\n", len, full ? "yes" : "no")=#

    #=print_path(best_ever)=#

    return
end

main()
