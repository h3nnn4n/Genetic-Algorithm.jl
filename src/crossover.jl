include("types.jl")

function crossover_one_point( pop :: _population, p1 :: Int, p2 :: Int )
    u = clone(pop.individuals[p1])
    v = clone(pop.individuals[p2])

    s = rand(2:pop.n_genes - 1)

    for i in s:pop.n_genes
        a = u.genetic_code[i]
        u.genetic_code[i] = v.genetic_code[i]
        v.genetic_code[i] = a
    end

    return u, v
end

function crossover_uniform( pop :: _population, p1 :: Int, p2 :: Int )
    u = clone(pop.individuals[p1])
    v = clone(pop.individuals[p2])

    for i in 1:pop.n_genes
        if rand() < 0.5
            a = u.genetic_code[i]
            u.genetic_code[i] = v.genetic_code[i]
            v.genetic_code[i] = a
        end
    end

    return u, v
end

function crossover_blx( pop :: _population, p1 :: Int, p2 :: Int )
    u = clone(pop.individuals[p1])
    v = clone(pop.individuals[p2])

    α = 0.5

    for i in 1:pop.n_genes
        d = abs(v.genetic_code[i].value - u.genetic_code[i].value)

        a = min(v.genetic_code[i].value, u.genetic_code[i].value) - α * d
        b = max(v.genetic_code[i].value, u.genetic_code[i].value) + α * d

        v.genetic_code[i].value = rand() * (b-a) + a
        u.genetic_code[i].value = rand() * (b-a) + a
    end

    return u, v
end
