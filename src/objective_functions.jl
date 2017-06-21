include("types.jl")
include("utils.jl")

#=img = load("lena2.png")=#
#=img = load("lena3.png")=#
#=img = load("box.png")=#

f3_size = 0
deceptiveN_size = 0
deceptiveN_nbits = 0

fitness_ub = 0

map = readdlm("map.txt")

eu_dist( x, y, a, b ) = sqrt(( x - a )^2 + ( y - b )^2)

function set_fitness_ub( v )
    global fitness_ub = v
end

function change_deceptiveN_size( nsize :: Int, nbits :: Int )
    global deceptiveN_size  = nsize
    global deceptiveN_nbits = nbits
end

function change_f3_size( nsize :: Int )
    global f3_size = nsize
end

function eval_f3( vet )
    if     reduce(&, true, vet .== [false, false, false])
        return 28
    elseif reduce(&, true, vet .== [false, false, true ])
        return 26
    elseif reduce(&, true, vet .== [false, true , false])
        return 22
    elseif reduce(&, true, vet .== [true , false, false])
        return 14
    elseif reduce(&, true, vet .== [true , true , true ])
        return 30
    else
        return 0
    end

    return 0
end

function objf_f3( ind :: _individual )
    obj = 0
    gens = [(x -> x.value)(i) for i in ind.genetic_code]

    for i in 1:f3_size
        obj += eval_f3(gens[(i-1)*3+1:i*3])
    end

    ind.obj_f = obj
end

function objf_f3s( ind :: _individual )
    obj = 0
    gens = [(x -> x.value)(i) for i in ind.genetic_code]

    for i in 1:f3_size
        obj += eval_f3([gens[i], gens[i + 10], gens[i+20]])
    end

    ind.obj_f = obj
end

function objf_deceptiveN( ind :: _individual )
    obj = 0
    gens = [(x -> x.value)(i) for i in ind.genetic_code]

    for i in 1:deceptiveN_size
        v = sum(gens[(i-1) * deceptiveN_nbits + 1: i * deceptiveN_nbits])

        if v == 0
            obj += deceptiveN_nbits + 1
        else
            obj += v
        end
    end

    ind.obj_f = obj
end

function objf_path( ind :: _individual )
    #=map_magic(map)=#

    #=exit()=#
    obj = 0.0

    oob_penalty = -5
    invalid_path_penalty = -1
    step_point = 2
    complete_point = 500
    neutral_move_penalty = -2

    xs, ys =  11,  2   # start pos
    xf, yf =  2 , 21   # end pos

    sizex, sizey = size(map)
    used = deepcopy(map)

    x, y = xs, ys

    invalid_path = false
    #=@printf(STDERR, "\npos = %2d %2d: %2d\n", x, y, map[x, y])=#

    for i in 1:ind.n_genes
        move = ind.genetic_code[i].value

        crossroads = map[x - 1, y + 0] +
                     map[x + 1, y + 0] +
                     map[x + 0, y - 1] +
                     map[x + 0, y + 1]

        #=@printf("Trying move: %2d  crossroads = %2d\n", move, crossroads)=#

        #=if crossroads == 1=#
            #=break=#
        #=end=#

        if x == xf && y == yf
            obj += complete_point
            break
        end

        if crossroads > 2 || crossroads == 1
            oldx, oldy = x, y

            if move == 1
                y -= 1
            elseif move == 2
                x += 1
            elseif move == 3
                y += 1
            elseif move == 4
                x -= 1
            end

            if x < 1 || x > sizex || y < 1 || y > sizey || map[x, y] == 0 || used[x, y] != 1
                x, y = oldx, oldy
            else
                obj += step_point * 5

                if used[x, y] > 1
                    obj -= (step_point * used[x, y]) ^ 2
                else
                    obj += step_point
                end

                used[x, y] += 2
                #=@printf(STDERR, "pos = %2d %2d: %2d  WITH TURN\n", x, y, map[x, y])=#
            end
        else
            while crossroads == 2
                oldx, oldy = x, y

                if move == 1
                    y -= 1
                elseif move == 2
                    x += 1
                elseif move == 3
                    y += 1
                elseif move == 4
                    x -= 1
                end

                if x < 1 || x > sizex || y < 1 || y > sizey || map[x, y] == 0 || used[x, y] != 1
                    x, y = oldx, oldy
                    break
                end

                if used[x, y] > 1
                    obj -= (step_point * used[x, y]) ^ 2
                else
                    #=obj += step_point=#
                    obj += 2# + ((45 - eu_dist(x, y, xf, yf)) / 45)
                end

                used[x, y] += 2

                #=@printf(STDERR, "pos = %2d %2d: %2d FORWARD\n", x, y, map[x, y])=#
            end
        end
    end

    #=@printf(STDERR, "cost: %3d\n\n", obj)=#

    #=print_path( ind )=#

    for i in 1:x
        for j in 1:y
            if used[i, j] > 0
                used[i, j] -= 1
            end
        end
    end

    #=obj /= sum( used )=#

    ind.obj_f = obj
end

function objf_nqueens_int( ind :: _individual )
    obj = 0.0

    nqueens = Int((ind.n_genes))

    hv = 0

    dv1 = 0

    # Horizontal and vertical
    for i in 1:nqueens
        for j in 1:nqueens
            if ind.genetic_code[i].value == ind.genetic_code[j].value
                if i != j
                    hv += 2
                    #=@printf("%d %d %d %d\n", i, ind.genetic_code[i].value, j, ind.genetic_code[j].value)=#
                end
            end
        end
    end

    # Both diagonals
    for i in 1:nqueens
        for j in 1:nqueens
            if abs(ind.genetic_code[i].value - ind.genetic_code[j].value) == abs(i-j)
            #=if abs(ind.genetic_code[i].value - i) == abs(ind.genetic_code[j].value - j)=#
                if i != j
                    dv1 += 1
                end
            end
        end
    end

    obj = hv + dv1

    ind.obj_f = obj
end

function objf_nqueens( ind :: _individual )
    obj = 0.0

    nqueens = Int(sqrt(ind.n_genes))

    hv = 0
    vv = 0

    dv1 = 0
    dv2 = 0

    # Horizontal and vertical
    for i in 1:nqueens
        u = 0
        v = 0
        for j in 1:nqueens
            if ind.genetic_code[(i-1) + (j-1) * nqueens + 1].value
                u += 1
            end

            if ind.genetic_code[(j-1) + (i-1) * nqueens + 1].value
                v += 1
            end
        end

        if u == 1
            hv += 0
        elseif u == 0
            hv += 4
        else
            hv += u * 2.0
        end

        if v == 1
            hv += 0
        elseif v == 0
            hv += 4
        else
            hv += v * 2.0
        end
    end

    #=u = 0=#
    #=for i in 1:nqueens=#
        #=if ind.genetic_code[(i-1) + (i-1) * nqueens + 1].value=#
            #=u += 1=#
        #=end=#
    #=end=#

    obj = hv + vv + dv1 + dv2

    ind.obj_f = obj
end


function objf_alternating_bit( ind :: _individual )
    obj = 0.0

    for i in 2:ind.n_genes
        if ind.genetic_code[i].value $ ind.genetic_code[i - 1].value
            obj += 1
        end
    end

    ind.obj_f = obj
end

function objf_alternating_parity( ind :: _individual )
    obj = 0.0

    for i in 2:ind.n_genes
        if (ind.genetic_code[i].value % 2) != (ind.genetic_code[i - 1].value % 2)
            obj += 1
        end
    end

    ind.obj_f = obj
end

function objf_sphere( ind :: _individual )
    obj = 0.0

    for i in 1:ind.n_genes
        obj += ind.genetic_code[i].value ^ 2.0
    end

    ind.obj_f = obj
end

function objf_img(ind :: _individual )
    obj = 0

    #=x = size(img)[1]=#
    #=y = size(img)[2]=#

    #=total = 1=#

    #=for i in 1:x=#
        #=for j in 1:y=#
            #=obj += abs(ind.genetic_code[(j-1) * x + (i-1) + 1].value - (convert(Gray{Float32}, img[i, j])))=#
            #=total += 1=#
        #=end=#
    #=end=#

    ind.obj_f = obj
    #=ind.obj_f = 1.0 - ( obj / total )=#
end

function objf_rosen(ind :: _individual )
    d = ind.n_genes

    xi    = ind.genetic_code[1:d-1]
    xnext = ind.genetic_code[2:d]

    s = mapfoldr(x -> 100.0 * (x[2].value - x[1].value^2.0)^2.0 + (x[1].value - 1.0)^2.0, +, collect(zip(xi, xnext)))

    ind.obj_f = s
end

function fitness_nqueens( _, ind :: _individual )
    ind.fitness = 1.0 - ind.obj_f / ( sqrt(ind.n_genes) * 4.0 )
end

function fitness_identity( _, ind :: _individual )
    ind.fitness = ind.obj_f
end

function fitness_normalized_lb( pop :: _population, ind :: _individual )
    ind.fitness = ind.obj_f - pop.min_objf
end

function fitness_normalized_ub( pop :: _population, ind :: _individual )
    ind.fitness = ind.obj_f / pop.max_objf
end

function fitness_normalized_fixed_ub( pop :: _population, ind :: _individual )
    ind.fitness = ind.obj_f / fitness_ub
end

function fitness_sphere( pop :: _population, ind :: _individual )
    fit = ind.obj_f

    fit = fit / (pop.max_objf)

    ind.fitness = (1.0 - fit)

    if isnan(ind.fitness)
        println("$(pop.max_objf) 0.0")
        throw("kek")
    end

end

function fitness_super_normalizer( pop :: _population, ind :: _individual )
    fit = ind.obj_f
    fit -= pop.min_objf
    fit = fit / (pop.max_objf - pop.min_objf)

    #=ind.fitness = (1.0 - fit)=#
    ind.fitness = fit

    if isnan(ind.fitness)
        ind.fitness = rand()
        #=println("$(pop.max_objf) 0.0")=#
        #=throw("kek")=#
    end
end
