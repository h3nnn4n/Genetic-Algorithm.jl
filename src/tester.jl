using Gadfly

include("main.jl")

Base.(:+)(x :: Tuple{Int64,Float64,Bool}, y :: Tuple{Int64,Float64,Bool}) = (x[1] + y[1], x[2] + y[2], x[3] + y[3])
Base.(:+)(x :: Tuple{Int64,Float64,Int64}, y :: Tuple{Int64,Float64,Bool}) = (x[1] + y[1], x[2] + y[2], x[3] + y[3])

function tester()
    out = open("data.log", "w")
    cd("../instances")
    files = readdir()
    for file in files
        name = split(splitext(file)[1], '-')[1]
        if name == "uf20"
            println("$file \t")

            todo  = [file for i in 1:10]
            inf   = (pmap(x -> main(x), todo))
            info  = sum(inf)
            info2 = (info[1]/10, info[2]/10, info[3])

            println(info)
            write(out, "$file $inf $info2\n")
            flush(out)
        end
    end
    cd("../src")
    close(out)
end

function evalmChanceVersusCrossovercance()
    name  = @sprintf "data_crossover_versus_mutation.log"
    out   = open(name, "w")

    crossover_mmin  = 0.25
    crossover_mmax  = 1.00
    crossover_iters = 3

    mutation_mmin  = 0.01
    mutation_mmax  = 1.00
    mutation_iters = 32

    m = 10

    for i in 0:mutation_iters
        mChance         = (mutation_mmax  - mutation_mmin ) * (i/mutation_iters ) + mutation_mmin
        write(out, "$mChance")
        print("$mChance")
        for j in 0:crossover_iters
            crossoverChance = (crossover_mmax - crossover_mmin) * (i/crossover_iters) + crossover_mmin

            w = sum(pmap(x -> main(x, mChance, crossoverChance), ["../instances/uf20-01.cnf" for j in 1:m]))

            write(out, "\t$(w[1]/m)")
            print("\t$(w[1]/m)")
        end
        write(out, "\n")
        println("")
        flush(out)
    end

    close(out)
end

function evalmChance(crossoverChance = 0.95)
    m     = 10
    name  = @sprintf "out_iter_%.4f.png" crossoverChance
    out   = open(name, "w")
    x     = []
    yiter = []
    ytime = []
    mmin  = 0.01
    mmax  = 1.00
    iters = 32

    for i in 1:iters
        mChance = (mmax - mmin)*(i/iters) + mmin
        w = sum(pmap(x -> main(x, mChance, crossoverChance), ["../instances/uf20-01.cnf" for j in 1:m]))
        push!(x    , mChance)
        push!(yiter, w[1]/m)
        push!(ytime, w[2]/m)

        println("$mChance $(w[1]/m) $(w[2]/m) $(w[3])")
        write(out, "$mChance $w\n")
        flush(out)
    end

    close(out)

    name = @sprintf "out_time_%.4f.png" crossoverChance
    draw(PNG(name, 800px, 600px),
        plot(
            layer( x = x, y = ytime,
                Geom.point, Geom.line,   Theme(default_color=colorant"orange")
            ),
            layer( x = x, y = ytime,
                Geom.point, Geom.smooth, Theme(default_color=colorant"purple")
            ),
            Theme(background_color=colorant"white"),
            Guide.xlabel("Mutation Chance"),
            Guide.ylabel("Time"),
            Guide.title("Genetic Algorithm for 3cnf-sat")
        )
    )
    name = @sprintf "out_iter_%.4f.png" crossoverChance
    draw(PNG(name, 800px, 600px),
        plot(
            layer( x = x, y = yiter,
                Geom.point, Geom.line,   Theme(default_color=colorant"orange")
            ),
            layer( x = x, y = yiter,
                Geom.point, Geom.smooth, Theme(default_color=colorant"purple")
            ),
            Theme(background_color=colorant"white"),
            Guide.xlabel("Mutation Chance"),
            Guide.ylabel("Iterations"),
            Guide.title("Genetic Algorithm for 3cnf-sat")
        )
    )
end
