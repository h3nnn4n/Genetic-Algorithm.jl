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

function evalmChance()
    m = 500

    out = open("mChange.log", "w")

    x     = []
    ytime = []
    yiter = []
    ysolv = []

    for i in 1:200
        mChance = i/1000
        w = sum(pmap(x -> main(x, mChance, 0.95), ["../instances/uf20-01.cnf" for j in 1:m]))
        push!(x    , mChance)
        push!(yiter, w[1]/m)
        push!(ytime, w[2]/m)
        push!(ysolv, w[3]/m)

        println("$mChance $w")
        write(out, "$mChance $w\n")
        flush(out)
    end

    close(out)

    draw(PNG("out_iter.png", 800px, 600px),
        plot(x = x, y = yiter, Geom.line,
        Theme(background_color=colorant"white"),
        Guide.xlabel("Mutation Chance"),
        Guide.ylabel("Iterations"),
        Guide.title("Genetic Algorithm for 3cnf-sat"))
        )
    draw(PNG("out_time.png", 800px, 600px),
        plot(x = x, y = ytime, Geom.line,
        Theme(background_color=colorant"white"),
        Guide.xlabel("Mutation Chance"),
        Guide.ylabel("Time"),
        Guide.title("Genetic Algorithm for 3cnf-sat"))
        )
    draw(PNG("out_solv.png", 800px, 600px),
        plot(x = x, y = ysolv, Geom.line,
        Theme(background_color=colorant"white"),
        Guide.xlabel("Mutation Chance"),
        Guide.ylabel("Solved"),
        Guide.title("Genetic Algorithm for 3cnf-sat"))
        )
end
