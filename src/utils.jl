include("objective_functions.jl")
include("types.jl")

function view_hp( ind :: _individual )
    model = get_hp_model()

    obj = 0
    gens = [(x -> x.value)(i) for i in ind.genetic_code]

    used = zeros(ind.n_genes * 2 + 1, ind.n_genes * 2 + 1)
    is_h = zeros(ind.n_genes * 2 + 1, ind.n_genes * 2 + 1)

    x, y = ind.n_genes + 1, ind.n_genes + 1
    direction = 0

    used[x, y] += 1

    if model[1] == 'H'
        is_h[x, y] += 1
    end

    for i in 2:ind.n_genes
        dir = gens[i]

        if dir == 0
            # nothing
        elseif dir == 1
            direction += 1
            if direction > 3
                direction = 0
            end
        elseif dir == -1
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
    end

    for i in 1:ind.n_genes * 2 + 1
        for j in 1:ind.n_genes * 2 + 1
            if used[x, y] > 1
                #=obj -= 2=#
            end

            if i >= 2 && j >= 2 && i <= ind.n_genes * 2 && j < ind.n_genes * 2
                if is_h[x, y] == 1
                    bonus = 0
                    bonus += is_h[x + 1, y + 0]
                    bonus += is_h[x - 1, y + 0]
                    bonus += is_h[x + 0, y + 1]
                    bonus += is_h[x + 0, y - 1]

                    obj += bonus
                end
            end
        end
    end

    display(used)
    println()
    display(is_h)
    #=exit()=#
end
