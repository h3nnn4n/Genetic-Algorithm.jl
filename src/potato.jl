#!/usr/bin/env julia

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

function get_scaled_fit( C, data)
    a, b = get_alpha_beta(C, data)
    return [ data[i] * a + b for i in 1:length(data) ]
end

function test()
    teste1 = [10, 9.5, 9, 8]
    teste2 = [8, 5, 3, 1]

    println("\nTeste1")
    C = 2.0
    data = teste1
    rawfr = get_relative_fit(data)
    for d in rawfr @printf("%4.2f ", d) end; println()
    a, b = get_alpha_beta(C, data)
    @printf("α = %f, β = %f\n", a, b)
    newf = get_scaled_fit(C, data)
    for d in newf @printf("%4.2f ", d) end; println()
    for d in get_relative_fit(newf) @printf("%4.2f ", d) end; println()

    C = 1.2
    a, b = get_alpha_beta(1.2, data)
    @printf("α = %f, β = %f\n", a, b)
    newf = get_scaled_fit(C, data)
    for d in newf @printf("%4.2f ", d) end; println()
    for d in get_relative_fit(newf) @printf("%4.2f ", d) end; println()

    println("\nTeste2")
    C = 2.0
    data = teste2
    rawfr = get_relative_fit(data)
    for d in rawfr @printf("%4.2f ", d) end; println()
    a, b = get_alpha_beta(2.0, data)
    @printf("α = %f, β = %f\n", a, b)
    newf = get_scaled_fit(C, data)
    for d in newf @printf("%4.2f ", d) end; println()
    for d in get_relative_fit(newf) @printf("%4.2f ", d) end; println()

    C = 1.2
    a, b = get_alpha_beta(1.2, data)
    @printf("α = %f, β = %f\n", a, b)
    newf = get_scaled_fit(C, data)
    for d in newf @printf("%4.2f ", d) end; println()
    for d in get_relative_fit(newf) @printf("%4.2f ", d) end; println()
end
