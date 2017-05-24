include("types.jl")

function elitism_get( pop :: _population )
    s = sort( pop.individuals, rev=true )[1:pop.kelitism]
    x = []

    for i in s
        push!(x, clone(i))
    end

    return x
end

function elitism_put_back( pop :: _population, elite )
    if pop.kelitism == 0
        return
    end

    new_guys = []

    #=for i in elite=#
        #=push!(new_guys, i)=#
    #=end=#

    #=for i in pop.individuals[pop.kelitism:pop.size]=#
        #=push!(new_guys, i)=#
    #=end=#

    ##################3

    for i in pop.individuals[1:pop.size]
        push!(new_guys, i)
    end

    used = 1

    for a in elite
        dist = -1
        for b in new_guys
            d = distance(a, b)
            if distance(a, b) < dist || dist == -1
                dist = d
            end
        end

        if dist != 0
            new_guys[used] = a
            used += 1
        end
    end

    pop.individuals = new_guys
end
