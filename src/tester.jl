include("evo_loop.jl")
include("types.jl")
include("problems.jl")

used = false

function tester()
    dump = 0
    ntests = 5
    pop = spawn_empty_population()
    pop.size = 50
    pop.max_iter = 5000
    pop.mchance = 0.01
    pop.cchance = 0.9
    pop.tourney_size = 2
    pop.kelitism = 1

    pop.crowding_factor_on = true
    pop.crowding = 3

    pop.fitness_sharing_on = false
    pop.fitness_sharing_sigma = 0.255
    pop.fitness_sharing_alpha = 1.05

    pop.Cfirst   = 1.2
    pop.Clast    = 2.0

    pop.genGapfirst   = 0.9
    pop.genGaplast    = 0.0
    pop.genGapiter    = 0.0

    pop.selection_function = selection_ktourney
    #=pop.selection_function = selection_roulette=#
    #=pop.selection_function = selection_roulette_linear_scalling=#
    #=pop.crossover_function = crossover_rand_points=#
    pop.crossover_function = crossover_uniform

    k = 0

    #=for f in [run_f3_10, run_fs3_10, run_fs3_20, run_f3_20]=#
    #=for f in [run_f3_20, run_f3_20]=#
    for f in [run_nqueens16]
        #=k += 1=#

        #=if k == 1=#
            #=pop.fitness_sharing_on = false=#
        #=elseif k == 2=#
            #=pop.fitness_sharing_on = true=#
        #=end=#

        base_name  = @sprintf("%s__%08d", Dates.format(now(), "yyyy-mm-dd-HH-MM-SS"), rand(1:10^8))
        param_name = @sprintf("%s__params.txt", base_name)
        data_name  = @sprintf("%s__data.txt", base_name)

        global used = false

        data_iter          = [ 0   for _ in 1:pop.max_iter ]
        data_objf_max_ever = [ 0.0 for _ in 1:pop.max_iter ]
        data_objf_max      = [ 0.0 for _ in 1:pop.max_iter ]
        data_objf_avg      = [ 0.0 for _ in 1:pop.max_iter ]
        data_diver         = [ 0.0 for _ in 1:pop.max_iter ]
        data_fit_max       = [ 0.0 for _ in 1:pop.max_iter ]
        data_fit_avg       = [ 0.0 for _ in 1:pop.max_iter ]

        for i in 1:ntests
            @printf(STDERR, "Running %s %d\n", f, i)
            pop.individuals = []
            d_iter, d_objf_max_ever, d_objf_max, d_objf_avg, d_diver, d_fit_max, d_fit_avg = f( pop, param_name )

            for j in 1:pop.max_iter
                data_iter[j]           = d_iter[j]
                data_objf_max_ever[j] += d_objf_max_ever[j] / ntests
                data_objf_max[j]      += d_objf_max[j] / ntests
                data_objf_avg[j]      += d_objf_avg[j] / ntests
                data_diver[j]         += d_diver[j] / ntests
                data_fit_max[j]       += d_fit_max[j] / ntests
                data_fit_avg[j]       += d_fit_avg[j] / ntests
            end
        end

        print_data(data_name, pop, data_iter, data_fit_max, data_fit_avg, data_diver, data_objf_max, data_objf_avg, data_objf_max_ever)
    end
end

function print_param( name, pop :: _population )
    if used == false
        global used = true
        f = open(name, "w")
        @printf(f, "pop.size = %d\n", pop.size)
        @printf(f, "pop.max_iter = %d\n", pop.max_iter)
        @printf(f, "pop.mchance = %f\n", pop.mchance)
        @printf(f, "pop.cchance = %f\n", pop.cchance)
        @printf(f, "pop.tourney_size = %d\n", pop.tourney_size)
        @printf(f, "pop.kelitism = %d\n", pop.kelitism)

        @printf(f, "pop.crowding_factor_on = %s\n", pop.crowding_factor_on ? "true" : "false")
        @printf(f, "pop.crowding = %d\n", pop.crowding)
        @printf(f, "pop.fitness_sharing_on = %s\n", pop.fitness_sharing_on ? "true" : "false")
        @printf(f, "pop.fitness_sharing_sigma = %f\n", pop.fitness_sharing_sigma)
        @printf(f, "pop.fitness_sharing_alpha = %f\n", pop.fitness_sharing_alpha)
        @printf(f, "pop.Cfirs = %f\n", pop.Cfirst)
        @printf(f, "pop.Clast = %f\n", pop.Clast)
        @printf(f, "pop.genGapfirst = %f\n", pop.genGapfirst)
        @printf(f, "pop.genGaplast = %f\n", pop.genGaplast)
        @printf(f, "pop.genGapiter = %f\n", pop.genGapiter)

        @printf(f, "pop.selection_function = %s\n", pop.selection_function)
        #=@printf(f, "pop.mutation_function = %s\n", pop.genGapiter)=#
        @printf(f, "pop.crossover_function = %s\n", pop.crossover_function)
        @printf(f, "pop.fitness_function = %s\n", pop.fitness_function)
        @printf(f, "pop.objective_function = %s\n", pop.objective_function)

        close(f)
    end
end

function print_data( name, pop, data_iter, data_fit_max, data_fit_avg, data_diver, data_objf_max, data_objf_avg, data_objf_max_ever)
    f = open(name, "w")

    for i in 1:pop.max_iter
        @printf(f, "%6d %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n",
            data_iter[i],
            data_fit_max[i],
            data_fit_avg[i],
            data_diver[i],
            data_objf_max[i],
            data_objf_avg[i],
            data_objf_max_ever[i],
            )
    end

    close(f)
end

tester()
