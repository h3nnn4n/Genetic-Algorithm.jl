include("types.jl")
include("selection.jl")
include("crossover.jl")

function spawn_empty_population()
    new_pop = _population(0, 0, 0, 0, [], 0, 0, _ -> _, _ -> _, _ -> _, _ -> _, _ -> _)
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

function evaluate( pop :: _population )
    a, b = 0, 0
    for i in 1:pop.size
        pop.objective_function(pop.individuals[i])

        if i == 1
            a = pop.individuals[i].obj_f
            b = pop.individuals[i].obj_f
        end

        a = min(a, pop.individuals[i].obj_f)
        b = max(b, pop.individuals[i].obj_f)
    end

    pop.min_objf = min(a, pop.min_objf)
    pop.max_objf = max(b, pop.max_objf)

    for i in 1:pop.size
        pop.fitness_function( pop, pop.individuals[i] )
    end
end

function clone( guy :: _individual )
    genetic_code = Array{_gene}( guy.n_genes )

    for i in 1:guy.n_genes
        genetic_code[i] = _gene(guy.genetic_code[i].is_bool,
                                guy.genetic_code[i].is_real,
                                guy.genetic_code[i].is_int,
                                guy.genetic_code[i].is_permut,
                                guy.genetic_code[i].lb,
                                guy.genetic_code[i].ub,
                                guy.genetic_code[i].value)
    end

    new_guy = _individual(guy.n_genes, guy.fitness, guy.obj_f, genetic_code)

    return new_guy
end

function selection( pop :: _population )
    pop.individuals = pop.selection_function( pop )
end

function crossover( pop :: _population )
    new_guys = []
    for i in 1:pop.size
        for j in 1:pop.n_genes
            if rand() < pop.cchance
                p1 = rand(1:pop.size)
                p2 = rand(1:pop.size)

                while p1 == p2
                    p1 = rand(1:pop.size)
                    p2 = rand(1:pop.size)
                end

                u, v = pop.crossover_function(pop, p1, p2)

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
