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

function ninja()
    mmin  = 0.05
    mmax  = 1.00
    iters = 19

    for i in 0:iters
        crossoverChance = (mmax - mmin)*(i/iters) + mmin
        println("\n $crossoverChance \n---------")
        evalmChance(crossoverChance)
    end

end

function evalmChance(crossoverChance = 0.95)
    m     = 25
    out   = open("mChange" + crossoverChance + ".log", "w")
    x     = []
    yiter = []
    ytime = []
    mmin  = 0.01
    mmax  = 1.00
    iters = 100

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

    #=out = open("mChange_iter.log", "w"); write(out, "$yiter"); close(out)=#
    #=out = open("mChange_time.log", "w"); write(out, "$ytime"); close(out)=#
    #=out = open("mChange_x.log", "w");    write(out, "$x");     close(out)=#

    draw(PNG("out_time" + crossoverChance + ".png", 800px, 600px),
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
    draw(PNG("out_iter" + crossoverChance + ".png", 800px, 600px),
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
