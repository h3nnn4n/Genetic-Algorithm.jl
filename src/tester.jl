include("evo_loop.jl")
include("types.jl")

function tester()
    dump = 0
    ntests = 5
    pop = spawn_empty_population()
    pop.size = 50
    pop.max_iter = 1000
    pop.mchance = 0.005
    pop.cchance = 0.9
    pop.tourney_size = 2
    pop.kelitism = 1

    pop.crowding_factor_on = true
    pop.crowding = 30

    pop.fitness_sharing_on = true
    pop.fitness_sharing_sigma = 0.255
    pop.fitness_sharing_alpha = 1.05

    pop.Cfirst   = 1.2
    pop.Clast    = 2.0

    pop.genGapfirst   =-0.9
    pop.genGaplast    = 0.0
    pop.genGapiter    = 0.0

    pop.selection_function = selection_ktourney
    pop.crossover_function = crossover_rand_points

    data_iter          = [ 0   for _ in 1:pop.max_iter ]
    data_objf_max_ever = [ 0.0 for _ in 1:pop.max_iter ]
    data_objf_max      = [ 0.0 for _ in 1:pop.max_iter ]
    data_objf_avg      = [ 0.0 for _ in 1:pop.max_iter ]
    data_diver         = [ 0.0 for _ in 1:pop.max_iter ]
    data_fit_max       = [ 0.0 for _ in 1:pop.max_iter ]
    data_fit_avg       = [ 0.0 for _ in 1:pop.max_iter ]

    for i in 1:ntests
        d_iter, d_objf_max_ever, d_objf_max, d_objf_avg, d_diver, d_fit_max, d_fit_avg = run_f3_10( pop )

        for j in 1:pop.max_iter
            data_iter[j]           = d_iter[j]
            data_objf_max_ever[j] += d_objf_max_ever[j] / ntests
            data_objf_max[j]      += d_objf_max[j] / ntests
            data_objf_avg[j]      += d_objf_avg[j] / ntests
            data_diver[j]         += d_diver[j] / ntests
            data_fit_max[j]       += d_fit_max[j] / ntests
            data_fit_avg[j]       += d_fit_avg[j] / ntests
        end

        @printf(STDERR, "Finished run %d\n", i)
    end

    for i in 1:pop.max_iter
        @printf(STDERR, "%6d %f %f %f %f %f %f\n",
            data_iter[i],
            data_diver[i], data_objf_max_ever[i],
            data_objf_max[i], data_objf_avg[i],
            data_fit_max[i], data_fit_avg[i])
    end
end

function run_f3_10( pop :: _population )
    res = 20
    nbits = 3
    pop.n_genes = res * nbits
    change_f3_size(res)
    change_deceptiveN_size(res, nbits)
    set_fitness_ub( res  * nbits * 30 )

    pop.objective_function = objf_f3
    pop.fitness_function   = fitness_normalized_fixed_ub

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            new_gene = _gene(bool, false, true, 0.0)
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    return evolutionary_loop( pop )
end

tester()
