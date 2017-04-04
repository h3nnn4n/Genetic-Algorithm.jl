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

function selection( pop :: _population )
    throw("Not implemented")
end

function crossover( pop :: _population )
    for i in 1:pop.size
        for j in 1:pop.n_genes
            if rand() < pop.cchance
                if pop.individuals[i].genetic_code[j].is_bool
                    throw("Not implemented")
                elseif pop.individuals[i].genetic_code[j].is_int
                    throw("Not implemented")
                elseif pop.individuals[i].genetic_code[j].is_real
                    throw("Not implemented")
                elseif pop.individuals[i].genetic_code[j].is_permut
                    throw("Not implemented")
                end
            end
        end
    end
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
