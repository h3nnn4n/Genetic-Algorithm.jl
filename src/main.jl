#using Images
#using ImageView
#using Colors
#using TestImages

include("types.jl")
include("population.jl")
include("selection.jl")
include("objective_functions.jl")

Base.isless(x :: _individual, y :: _individual) = (x.fitness) < (y.fitness)

function main()
    #=println("Starting")=#
    res = 8
    pop = spawn_empty_population()
    pop.size = 50
    #=pop.n_genes = res*res=#
    pop.n_genes = res
    pop.mchance = 0.07
    pop.cchance = 0.75
    pop.tourney_size = 2
    #=pop.kelitism = Int(ceil((res*res) * 0.15))=#
    pop.kelitism = 1

    pop.crossover_function = crossover_pmx
    #=pop.crossover_function = crossover_uniform=#
    #=pop.crossover_function = crossover_one_point=#
    #=pop.crossover_function = crossover_blx=#

    pop.selection_function = selection_ktourney
    #=pop.selection_function = selection_roulette=#
    #=pop.selection_function = selection_random=#

    #=pop.objective_function = objf_alternating_parity=#
    #=pop.objective_function = objf_alternating_bit=#
    #=pop.objective_function = objf_sphere=#
    #=pop.objective_function = objf_rosen=#
    #=pop.objective_function = objf_nqueens=#
    pop.objective_function = objf_nqueens_int
    #=pop.objective_function = objf_img=#

    pop.fitness_function   = fitness_sphere
    #=pop.fitness_function   = fitness_nqueens=#
    #=pop.fitness_function   = fitness_identity=#

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            #=new_gene = _gene(real, 0, 1.0, 0.0)=#
            #=new_gene = _gene(bool, false, true, 0.0)=#
            #=new_gene = _gene(int, 1, res, 0)=#
            new_gene = _gene(permut, 1, res, 0)
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    init_population(pop)

    pop.objective_function(pop.individuals[1])

    pop.min_objf = pop.individuals[1].obj_f
    pop.max_objf = pop.individuals[1].obj_f

    best_ever = pop.individuals[1]

    for iter in 1:1000
        evaluate(pop)

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

    for i in 1:res
        @printf(STDERR, "%d ", best_ever.genetic_code[i].value)
    end
    println()

    nqueens = res
    for i in 1:nqueens
        for j in 2:best_ever.genetic_code[i].value
            @printf(STDERR, ". ")
        end

        @printf(STDERR, "Q ")

        for j in best_ever.genetic_code[i].value+1:nqueens
            @printf(STDERR, ", ")
        end

        @printf(STDERR,"\n")
    end

    #=nqueens = res=#
    #=for i in 1:nqueens=#
        #=for j in 1:nqueens=#
            #=if best_ever.genetic_code[(i-1) + (j-1) * nqueens + 1].value=#
                #=@printf(STDERR, "Q ")=#
            #=else=#
                #=@printf(STDERR, ". ")=#
            #=end=#
        #=end=#
        #=@printf(STDERR,"\n")=#
    #=end=#

    #=for i in best_ever.genetic_code=#
        #=println("$(i.value) ")=#
    #=end=#

    return
end

@time main()
