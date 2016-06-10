using Gadfly

include("ga.jl")
include("cnf.jl")
include("readFile.jl")

function main(name)
    tic()
    size            = readSize(name)
    formula         = readFormula(name)
    maxIter         = 5 * 10^5
    iter            = 0
    populationSize  = 100
    population      = spawnPop(populationSize, size, formula)
    x               = []
    ybest           = []
    yworst          = []
    ymedian         = []
    ymean           = []
    ydiversity      = []
    plotInt         = 10^2
    canDraw         = false
    progress        = false
    crossoverChance = 0.95

    while iter < maxIter
        iter += 1

        new   = roulette(population)
        newer = mate(new, formula, crossoverChance)
        diver = diversity(newer)

        best, worst, median, mean = getBestWorstMedianMean(newer)

        if iter % plotInt == 0 || best.fitness == 1.0 || ( iter < plotInt && iter % div(plotInt, 10) == 0 ) || iter == 1
            if canDraw
                push!(x         , iter           )
                push!(ybest     , best.fitness   )
                push!(yworst    , worst.fitness  )
                push!(ymedian   , median.fitness )
                push!(ymean     , mean           )
                push!(ydiversity, diver          )
            end

            if progress
                println("$iter \t $(length(population)) \t $(best.fitness) \t $(worst.fitness) \t $(median.fitness) \t $mean \t $(best.fitness - worst.fitness) \t $diver")
            end
        end

        if best.fitness == 1.0
            break
        end

        population = newer
    end

    if canDraw
        draw(PNG("out_best.png", 800px, 600px),
            plot(x = x, y = ybest, Geom.line,
            Theme(background_color=colorant"white"),
            Guide.xlabel("Time"),
            Guide.ylabel("Best"),
            Guide.title("Genetic Algorithm for 3cnf-sat"))
            )
        draw(PNG("out_worst.png", 800px, 600px),
            plot(x = x, y = yworst, Geom.line,
            Theme(background_color=colorant"white"),
            Guide.xlabel("Time"),
            Guide.ylabel("Worst"),
            Guide.title("Genetic Algorithm for 3cnf-sat"))
            )
        draw(PNG("out_median.png", 800px, 600px),
            plot(x = x, y = ymedian, Geom.line,
            Theme(background_color=colorant"white"),
            Guide.xlabel("Time"),
            Guide.ylabel("Median"),
            Guide.title("Genetic Algorithm for 3cnf-sat"))
            )
        draw(PNG("out_mean.png", 800px, 600px),
            plot(x = x, y = ymean, Geom.line,
            Theme(background_color=colorant"white"),
            Guide.xlabel("Time"),
            Guide.ylabel("Mean"),
            Guide.title("Genetic Algorithm for 3cnf-sat"))
            )
        draw(PNG("out_diversity.png", 800px, 600px),
            plot(x = x, y = ydiversity, Geom.line,
            Theme(background_color=colorant"white"),
            Guide.xlabel("Time"),
            Guide.ylabel("Diversity"),
            Guide.title("Genetic Algorithm for 3cnf-sat"))
            )
    end

    r = iter == maxIter ? (iter, toq(), false) : (iter, toq(), true)
    println(r)
    return r
end
