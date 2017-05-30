include("types.jl")

function getGap( pop :: _population )
    # Linear
    index = pop.genGapiter

    C = Int(ceil(((pop.genGaplast - pop.genGapfirst) * index + pop.genGapfirst) * pop.size))

    for i in 1:10
        if index > (i-1)/10 && index < (i+0)/10
            index = (i-0)/10
        end
    end

    C = Int(ceil(((pop.genGaplast - pop.genGapfirst) * index + pop.genGapfirst) * pop.size))

    return C
end

function gengap_get( pop :: _population )
    if pop.genGapfirst < 0
        return []
    end

    x = []

    C = getGap(pop)
    s = ((pop.individuals))[1:C]

    for i in s
        push!(x, clone(i))
    end

    return x
end

function gengap_put_back( pop :: _population, elite )
    if pop.genGapfirst < 0
        return
    end

    C = getGap(pop)

    new_guys = []

    for i in elite
        push!(new_guys, i)
    end

    for i in pop.individuals[length(elite)+1:pop.size]
        push!(new_guys, i)
    end

    pop.individuals = new_guys
end

