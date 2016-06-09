include("cnf.jl")

type Individual
    genes   :: Array{Bool}
    fitness :: Float64
end

+(x :: Individual, y :: Individual) = (x.fitness) + (y.fitness)
+(x :: Float64   , y :: Individual) = (x        ) + (y.fitness)

Base.isless(x :: Individual, y :: Individual) = (x.fitness) < (y.fitness)

function spawnPop(n, size, formula)
    pop = []

    for i in 1:n
        r = map( x -> x == 1, rand(0:1, size))
        push!(pop, Individual(r, fitness(r, formula)))
    end

    return pop
end

hamming(x, y) = sum([ x[i] != y[i] for i in 1:length(x)])

function diversity(pop)
    d, t = 0, 0
    for i in 1:length(pop), j in 1:i-1
        d += hamming(pop[i].genes, pop[j].genes)
        t += 1
    end
    return d / t
end

function cancer(a, formula)
    for i in 1:length(a.genes)
        a.genes[i] = rand() < 0.5 ? !a.genes[i] : a.genes[i]
    end
    a.fitness = fitness(a.genes, formula)
end

function roulette(pop)
    total   = sum( pop )
    newpop  = []
    elitism = true

    if elitism
        max = length(pop) - 1
        push!(newpop, getBest(pop))
    else
        max = length(pop)
    end

    for w in 1:max
        i, p, r = 0, 0, rand()
        while p < r
            i += 1
            p += pop[i].fitness/total
            if p >= r
                push!(newpop, pop[i])
            end
        end
    end
    return newpop
end

function getBest(pop)
    best = pop[1]

    for i in pop
        best = i.fitness > best.fitness ? i : best
    end

    return best
end

function getBestWorstMedianMean(pop)
    p = sort(pop)
    return p[end], p[1], p[div(end, 2)], sum(p)/length(p)
end

function mate(pop, formula)
    for i in 1:length(pop)/2
        a = rand(1:length(pop))
        b = rand(1:length(pop))
        if rand() < 0.9
            u, v = crossover(pop[a], pop[b], formula)
            pop[a] = u
            pop[b] = v
        end
    end

    return pop
end

function mutate(a)
    p = rand(1:length(a.genes))
    a.genes[p] = rand() < (1/length(a.genes)) ? !a.genes[p] : a.genes[p]
    return a
end

function crossover(a, b, formula)
    p = rand(1:length(a.genes))

    g1 = vcat(a.genes[1:p], b.genes[p+1:end])
    g2 = vcat(b.genes[1:p], a.genes[p+1:end])

    u = mutate(Individual(g1, fitness(g1, formula)))
    v = mutate(Individual(g2, fitness(g2, formula)))

    return u, v
end
