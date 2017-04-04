type _gene
    is_bool   :: Bool
    is_real   :: Bool
    is_int    :: Bool
    is_permut :: Bool

    lb        :: Any
    ub        :: Any

    value     :: Any
end

type _individual
    n_genes :: Int
    fitness :: Any
    genetic_code :: Array{_gene, 1}
end

type _population
    n_genes :: Int
    size :: Int
    mchance :: Float32
    cchance :: Float32
    individuals :: Array{_individual, 1}
end
