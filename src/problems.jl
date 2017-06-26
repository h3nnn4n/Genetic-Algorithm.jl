include("types.jl")

function run_fs3_20( pop :: _population, param_name )
    res = 20
    nbits = 3
    pop.n_genes = res * nbits
    change_f3_size(res)
    change_deceptiveN_size(res, nbits)
    set_fitness_ub( res  * nbits * 30 )

    pop.objective_function = objf_f3s
    pop.fitness_function   = fitness_normalized_fixed_ub

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            new_gene = _gene(bool, false, true, 0.0)
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    print_param(param_name, pop)

    return evolutionary_loop( pop )
end

function run_fs3_10( pop :: _population, param_name )
    res = 10
    nbits = 3
    pop.n_genes = res * nbits
    change_f3_size(res)
    change_deceptiveN_size(res, nbits)
    set_fitness_ub( res  * nbits * 30 )

    pop.objective_function = objf_f3s
    pop.fitness_function   = fitness_normalized_fixed_ub

    for i in 1:pop.size
        new_guy = _individual(pop.n_genes, 0, 0, [])
        for j in 1:pop.n_genes
            new_gene = _gene(bool, false, true, 0.0)
            push!(new_guy.genetic_code, new_gene)
        end
        push!(pop.individuals, new_guy)
    end

    print_param(param_name, pop)

    return evolutionary_loop( pop )
end

function run_f3_20( pop :: _population, param_name )
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

    print_param(param_name, pop)

    return evolutionary_loop( pop )
end

function run_f3_10( pop :: _population, param_name )
    res = 10
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

    print_param(param_name, pop)

    return evolutionary_loop( pop )
end


