#!/usr/bin/env julia

teste1 = [10, 9.5, 9, 8]
teste2 = [8, 5, 3, 1]

function get_alpha_beta( C, data )
    fmin = minimum(data)
    fmax = maximum(data)
    favg = mean(data)

    α = 0
    β = 0

    if fmin > ( C*favg - fmax ) / ( C - 1 )
        α = (favg - (C-1)) / (fmax - favg)
        β = (favg * (fmax - C *favg)) / (fmax - favg)
    else
        α = favg / (favg - fmin)
        β = ( - fmin * favg ) / ( favg - fmin )
    end

    return α, β
end

function get_relative_fit( data )
    total = sum(data)
    return [ data[i] / total for i in 1:length(data) ]
end

println("\nTeste1")
println(get_relative_fit(teste1))
a, b = get_alpha_beta(2.0, teste1)
@printf("α = %f, β = %f\n", a, b)
a, b = get_alpha_beta(1.2, teste1)
@printf("α = %f, β = %f\n", a, b)

println("\nTeste2")
println(get_relative_fit(teste2))
a, b = get_alpha_beta(2.0, teste2)
@printf("α = %f, β = %f\n", a, b)
a, b = get_alpha_beta(1.2, teste2)
@printf("α = %f, β = %f\n", a, b)

