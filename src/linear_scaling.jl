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
