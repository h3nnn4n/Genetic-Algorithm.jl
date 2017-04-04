include("types.jl")

function spawn_empty_population()
    new_pop = _population(0, 0, 0, 0, [])
end

function init_population( pop :: _population )
    for i in 1:pop.size
        for j in 1:pop.n_genes
            if pop.individuals[i].genetic_code[j].is_bool
                pop.individuals[i].genetic_code[j].value = rand(Bool)
            elseif pop.individuals[i].genetic_code[j].is_int
                pop.individuals[i].genetic_code[j].value = rand(pop.individuals[i].genetic_code[j].lb:pop.individuals[i].genetic_code[j].ub)
            elseif pop.individuals[i].genetic_code[j].is_real
                pop.individuals[i].genetic_code[j].value = rand() * (pop.individuals[i].genetic_code[j].ub - pop.individuals[i].genetic_code[j].lb) + pop.individuals[i].genetic_code[j].lb
            elseif pop.individuals[i].genetic_code[j].is_permut
                throw("Not implemented")
            end
        end
    end
end

function evaluate( pop :: _population, f )
    for i in 1:pop.size
        f(pop.individuals[i])
    end
end

function selection_roulette( pop :: _population )
    throw("Not implemented")
end

function selection_ktourney( pop :: _population, k )
    new_guys = [] # :: Array{_individual, 1}
    for _ in 1:pop.size
        best_i = rand(1:pop.size)
        for _ in 1:k
            n = rand(1:pop.size)
            if pop.individuals[best_i].fitness < pop.individuals[n].fitness
                best_i = n
            end
        end
        push!(new_guys, deepcopy(pop.individuals[best_i]))
    end

    pop.individuals = new_guys
end

function selection( pop :: _population )
    #=pop.individuals = selection_roulette( pop )=#
    pop.individuals = selection_ktourney( pop, 2 )
end

function crossover_one_point( pop :: _population, p1 :: Int, p2 :: Int )
    u = deepcopy(pop.individuals[p1])
    v = deepcopy(pop.individuals[p2])

    s = rand(2:pop.n_genes - 1)

    for i in s:pop.n_genes
        a = u.genetic_code[i]
        u.genetic_code[i] = v.genetic_code[i]
        v.genetic_code[i] = a
    end

    return u, v
end

function crossover_uniform( pop :: _population, p1 :: Int, p2 :: Int )
    u = deepcopy(pop.individuals[p1])
    v = deepcopy(pop.individuals[p2])

    for i in 1:pop.n_genes
        if rand() < 0.5
            a = u.genetic_code[i]
            u.genetic_code[i] = v.genetic_code[i]
            v.genetic_code[i] = a
        end
    end

    return u, v
end

function crossover( pop :: _population )
    new_guys = [] # :: Array{_individual, 1}
    for i in 1:pop.size
        for j in 1:pop.n_genes
            if rand() < pop.cchance
                p1 = rand(1:pop.size)
                p2 = rand(1:pop.size)

                while p1 == p2
                    p1 = rand(1:pop.size)
                    p2 = rand(1:pop.size)
                end

                if pop.individuals[i].genetic_code[j].is_bool
                    u, v = crossover_uniform(pop, p1, p2)
                elseif pop.individuals[i].genetic_code[j].is_int
                    u, v = crossover_uniform(pop, p1, p2)
                elseif pop.individuals[i].genetic_code[j].is_real
                    u, v = crossover_uniform(pop, p1, p2)
                elseif pop.individuals[i].genetic_code[j].is_permut
                    throw("Not implemented")
                end

                push!(new_guys, u)
                push!(new_guys, v)
            end
        end
    end

    pop.individuals = new_guys
end

function mutation( pop :: _population )
    for i in 1:pop.size
        for j in 1:pop.n_genes
            if rand() < pop.mchance
                if pop.individuals[i].genetic_code[j].is_bool
                    pop.individuals[i].genetic_code[j].value = !pop.individuals[i].genetic_code[j].value
                elseif pop.individuals[i].genetic_code[j].is_int
                    dist = Int(ceil((pop.individuals[i].genetic_code[j].ub - pop.individuals[i].genetic_code[j].lb) * 0.025))
                    pop.individuals[i].genetic_code[j].value += rand(-dist:dist)
                elseif pop.individuals[i].genetic_code[j].is_real
                    dist = (pop.individuals[i].genetic_code[j].ub - pop.individuals[i].genetic_code[j].lb) * 0.05
                    pop.individuals[i].genetic_code[j].value += (rand() * 2.0 - 1.0) * dist
                elseif pop.individuals[i].genetic_code[j].is_permut
                    throw("Not implemented")
                end
            end
        end
    end
end

function print_pop( pop :: _population )
    for i in 1:pop.size
        for j in 1:pop.n_genes
            print("$(pop.individuals[i].genetic_code[j].value) ")
        end
        println(" = $(pop.individuals[i].fitness)")
    end
end
