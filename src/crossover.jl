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

Base.isfinite( a :: _gene ) = true

function crossover_pmx( pop :: _population, p1 :: Int, p2 :: Int )
    u = clone(pop.individuals[p1])
    v = clone(pop.individuals[p2])

    for i in 1:pop.n_genes
        @printf("%d ", pop.individuals[p1].genetic_code[i].value)
    end; println()

    for i in 1:pop.n_genes
        @printf("%d ", pop.individuals[p2].genetic_code[i].value)
    end; println()

    a, b = rand(1:v.n_genes), rand(1:v.n_genes)

    if a == b
        b += 1
    end

    if b < a
        c = a
        a = b
        b = c
    end

    @printf("swap on (%d, %d)\n", a, b)

    for i in a:b
        change = true
        if u.genetic_code[i] != v.genetic_code[i]

            for j in a:b
                if u.genetic_code[i] == 1
                end
            end
            t = u.genetic_code[i]
            u.genetic_code[i] = v.genetic_code[i]
            u.genetic_code[i] = t
        end
    end

    for i in 1:pop.n_genes
        @printf("%d ", u.genetic_code[i].value)
    end; println()

    for i in 1:pop.n_genes
        @printf("%d ", v.genetic_code[i].value)
    end; println()

    exit()

    return u, v
end
