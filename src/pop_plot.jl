#=using Gadfly=#

include("types.jl")

function pop_plot( pop :: _population, iter :: Int )
    base_name  = @sprintf("%s__%08d__pop.txt", Dates.format(now(), "yyyy-mm-dd-HH-MM-SS"), iter)

    #=data = [ [i] for i in 1:pop.size ]=#
    data = [ [] for _ in 1:pop.size ]

    if pop.individuals[1].genetic_code[1].gen_type == bool
        for j in 1:pop.n_genes
            for i in 1:pop.size
                push!(data[i], pop.individuals[i].genetic_code[j].value ? 1 : 0)
            end
        end
    end

    f = open(base_name, "w")

    for j in 1:pop.n_genes
        for i in 1:pop.size
            @printf(f, "%d ", data[i][j])
        end
        @printf(f, "\n")
    end

    close(f)
    exit()
end

# Lixo
#=x_data = [ ind.genetic_code[j].value ? 1 : 0 for j in 1:pop.n_genes ]=#

#=for i in 1:length(x_data)-1=#
    #=@printf("%d ", x_data[i])=#
#=end=#
#=@printf("%d\n", x_data[length(x_data)])=#

#=println(x_data)=#
#=println([i for i in 1:length(x_data)])=#

#=draw(PNG("out_diversity.png", 800px, 600px),=#
#=plot(x=[i for i in 1:length(x_data)], y=x_data, Geom.line,=#
#=Theme(background_color=colorant"white"),=#
#=Guide.xlabel("Time"),=#
#=Guide.ylabel("Diversity"),=#
#=Guide.title("HUe"))=#
#=)=#
