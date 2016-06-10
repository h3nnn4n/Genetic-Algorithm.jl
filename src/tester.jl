include("main.jl")

Base.(:+)(x :: Tuple{Int64,Float64,Bool}, y :: Tuple{Int64,Float64,Bool}) = (x[1] + y[1], x[2] + y[2], x[3] + y[3])
Base.(:+)(x :: Tuple{Int64,Float64,Int64}, y :: Tuple{Int64,Float64,Bool}) = (x[1] + y[1], x[2] + y[2], x[3] + y[3])

function tester()
    n   = nworkers()
    t   = 10
    out = open("data.log", "w")
    cd("../instances")
    files = readdir()
    for file in files
        name = split(splitext(file)[1], '-')[1]
        if name == "uf20"
            println("$file \t")
            todo = [file for i in 1:t]
            info = pmap(x -> main(x), todo)
            println(info)
            write(out, "$file $info\n")
            flush(out)
        end
    end
    cd("../src")
    close(out)
end
