include("types.jl")

map = readdlm("map.txt")

function print_path( ind :: _individual )
    xs, ys =  11,  2   # start pos
    xf, yf =  2 , 21   # end pos

    obj = 0
    step_point = 0

    sizex, sizey = size(map)

    used = deepcopy(map)

    used[xs, ys] = -1
    used[xf, yf] = -1

    x, y = xs, ys

    len = 0

    invalid_path = false
    complete_path = false
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

            if x < 1 || x > sizex || y < 1 || y > sizey || map[x, y] == 0# || used[x, y] != 1
                x, y = oldx, oldy
            else
                obj += step_point * 5
                used[x, y] += 2
                @printf(STDERR, "%3d move = %2d pos = %2d %2d: %2d  WITH TURN\n", i, move, x, y, map[x, y])
            end
        end

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

            if x < 1 || x > sizex || y < 1 || y > sizey || map[x, y] == 0 #|| used[x, y] != 1
                x, y = oldx, oldy
                break
            end

            used[x, y] += 2
            #=obj += step_point=#

            @printf(STDERR, "%3d move = %2d pos = %2d %2d: %2d FORWARD\n", i, move, x, y, map[x, y])
        end

        if crossroads == 2
            #=obj += step_point=#
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
                @printf("+ ")
            end
        end
        @printf("\n")
    end
end

function path_length( ind :: _individual )
    xs, ys =  11,  2   # start pos
    xf, yf =  2 , 21   # end pos

    obj = 0
    step_point = 0

    complete_path = false
    len = 0

    sizex, sizey = size(map)

    used = deepcopy(map)

    used[xs, ys] = -1
    used[xf, yf] = -1

    x, y = xs, ys

    len = 0

    invalid_path = false
    complete_path = false
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

            if x < 1 || x > sizex || y < 1 || y > sizey || map[x, y] == 0# || used[x, y] != 1
                x, y = oldx, oldy
            else
                len += 1
                obj += step_point * 5
                used[x, y] += 2
                #=@printf(STDERR, "pos = %2d %2d: %2d  WITH TURN\n", x, y, map[x, y])=#
            end

            if x == xf && y == yf
                complete_path = true
                break
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

                if x < 1 || x > sizex || y < 1 || y > sizey || map[x, y] == 0 #|| used[x, y] != 1
                    x, y = oldx, oldy
                    break
                else
                    len += 1
                end

                if x == xf && y == yf
                    complete_path = true
                    break
                end

                used[x, y] += 2
                #=obj += step_point=#

                #=@printf(STDERR, "pos = %2d %2d: %2d FORWARD\n", x, y, map[x, y])=#
            end
        end
    end

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

function print_mapppp( used )
    x, y = size(used)

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
                @printf("+ ")
            end
        end
        @printf("\n")
    end
end

function map_magic( mapp )
    changed = true

    xs , ys = size( mapp )

    #=print_mapppp ( mapp )=#

    cnt = 0

    while changed && cnt < 10
        cnt += 1
        changed = false
        for i in 2:xs-1
            for j in 2:ys-1
                s = 0
                for a in -1:1
                    for b in -1:1
                        s += mapp[i + a, j + b]
                    end
                end

                if s == 2
                    changed = true
                    mapp[i, j] = 0
                end
            end
        end
        #=print_mapppp ( mapp )=#
    end
end
