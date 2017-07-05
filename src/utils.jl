
include("objective_functions.jl")
include("types.jl")

function view_hp( ind :: _individual )
    model = get_hp_model()

    xd = []
    yd = []

    obj = 0
    gens = [(x -> x.value)(i) for i in ind.genetic_code]

    used = zeros(Int32, ind.n_genes * 2 + 1, ind.n_genes * 2 + 1)
    is_h = zeros(Int32, ind.n_genes * 2 + 1, ind.n_genes * 2 + 1)

    x, y = ind.n_genes + 1, ind.n_genes + 1
    direction = 0

    used[x, y] = 1

    if model[1] == 'H'
        is_h[x, y] += 1
    end

    push!(xd, x)
    push!(yd, y)

    for i in 2:ind.n_genes
        dir = gens[i]

        if dir == 2
            # nothing
        elseif dir == 1
            direction += 1
            if direction > 3
                direction = 0
            end
        elseif dir == 3
            direction -= 1
            if direction < 0
                direction = 3
            end
        end

        if direction == 0
            x += 1
        elseif direction == 1
            y += 1
        elseif direction == 2
            x -= 1
        elseif direction == 3
            y -= 1
        end

        used[x, y] += 1
        if model[i] == 'H'
            is_h[x, y] += 1
        end

        push!(xd, x)
        push!(yd, y)
    end

    println(xd)
    println(yd)

    plot(xd, yd)
    gui()

    display(used)
    println()
    display(is_h)
end
