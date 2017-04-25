include("types.jl")

#=img = load("lena2.png")=#
#=img = load("lena3.png")=#
#=img = load("box.png")=#

function objf_nqueens( ind :: _individual )
    obj = 0.0

    nqueens = Int(sqrt(ind.n_genes))

    hv = 0
    vv = 0

    dv1 = 0
    dv2 = 0

    for i in 1:nqueens
        w = 0
        for j in 1:nqueens
            if ind.genetic_code[(i-1) + (j-1) * nqueens + 1].value
                w += 1
            end
        end

        if w == 1
            hv += 0
        elseif w == 0
            hv += 2
        else
            hv += w
        end
    end

    for i in 1:nqueens
        w = 0
        for j in 1:nqueens
            if ind.genetic_code[(j-1) + (i-1) * nqueens + 1].value
                w += 1
            end
        end

        if w == 1
            vv += 0
        elseif w == 0
            vv += 2
        else
            vv += w
        end
    end

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

function fitness_sphere( pop :: _population, ind :: _individual )
    fit = ind.obj_f

    fit = fit / (pop.max_objf)

    ind.fitness = (1.0 - fit)

    if isnan(ind.fitness)
        println("$(pop.max_objf) 0.0")
        throw("kek")
    end

end
