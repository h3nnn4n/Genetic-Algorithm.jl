include("types.jl")

map = readdlm("map.txt")

function print_path( ind :: _individual )
    xs, ys =  11,  2   # start pos
    xf, yf =  2 , 21   # end pos

    sizex, sizey = size(map)

    used = deepcopy(map)

    used[xs, ys] = -1
    used[xf, yf] = -1

    x, y = xs, ys

    len = 0

    invalid_path = false
    complete_path = false
    @printf(STDERR, "\npos = %2d %2d: %2d\n", x, y, map[x, y])

    for i in 1:ind.n_genes
        move = ind.genetic_code[i].value

        if move == 1
            y -= 1
        elseif move == 2
            x += 1
        elseif move == 3
            y += 1
        elseif move == 4
            x -= 1
        end

        if x < 1 || x > sizex || y < 1 || y > sizey
            break
        elseif !invalid_path && map[x, y] == 0
            invalid_path = true
        end

        if x == xf && y == yf
            complete_path = true
            break
        end

        if invalid_path
            break
        else
            used[x, y] += 2
        end
    end

    x, y = size(map)

    for i in 1:x
        for j in 1:y
            if used[i, j] == 0
                @printf("X ")
                #=@printf("  ")=#
            elseif used[i, j] == 1
                @printf("  ")
            elseif used[i, j] == 3
                @printf(". ")
            elseif used[i, j] == -1
                @printf("* ")
            else
                @printf("? ")
            end
        end
        @printf("\n")
    end
end

function path_length( ind :: _individual )
    xs, ys =  11,  2   # start pos
    xf, yf =  2 , 21   # end pos

    sizex, sizey = size(map)

    used = zeros(size(map))

    x, y = xs, ys

    len = 0

    invalid_path = false
    complete_path = false
    @printf(STDERR, "\npos = %2d %2d: %2d\n", x, y, map[x, y])

    for i in 1:ind.n_genes
        move = ind.genetic_code[i].value

        if move == 1
            y -= 1
        elseif move == 2
            x += 1
        elseif move == 3
            y += 1
        elseif move == 4
            x -= 1
        else
            println(move)
            throw("invalid move:")
        end

        if x < 1 || x > sizex || y < 1 || y > sizey
            @printf(STDERR, "OOB!\n")
            break
        elseif !invalid_path && map[x, y] == 0
            invalid_path = true
        end

        @printf(STDERR, "move = %2d - pos = %2d %2d: %2d\n", move, x, y, map[x, y])

        if invalid_path
            #=@printf(STDERR, "Invalid path penalty\n")=#
        else
            #=@printf(STDERR, "Valid path so far!\n")=#
        end

        if x == xf && y == yf
            complete_path = true
            #=@printf(STDERR, "Complete path!\n")=#
            break
        end

        if invalid_path
            @printf(STDERR, "Invalid Path!\n")
            break
        else
            len += 1
            #=@printf(STDERR, "%d ", move)=#
        end
    end

    @printf(STDERR, "\n")

    #=ind.obj_f = obj=#
    return len, complete_path
end

#=nqueens = res=#
#=for i in 1:nqueens=#
    #=for j in 2:best_ever.genetic_code[i].value=#
        #=@printf(STDERR, ". ")=#
    #=end=#

    #=@printf(STDERR, "Q ")=#

    #=for j in best_ever.genetic_code[i].value+1:nqueens=#
        #=@printf(STDERR, ", ")=#
    #=end=#

    #=@printf(STDERR,"\n")=#
#=end=#

#=nqueens = res=#
#=for i in 1:nqueens=#
    #=for j in 1:nqueens=#
        #=if best_ever.genetic_code[(i-1) + (j-1) * nqueens + 1].value=#
            #=@printf(STDERR, "Q ")=#
        #=else=#
            #=@printf(STDERR, ". ")=#
        #=end=#
    #=end=#
    #=@printf(STDERR,"\n")=#
#=end=#

#=for i in best_ever.genetic_code=#
    #=println("$(i.value) ")=#
#=end=#
