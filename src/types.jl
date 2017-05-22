@enum GENE_TYPE bool=1 int=2 real=3 permut=4

type _gene
    gen_type  :: GENE_TYPE

    lb        :: Any
    ub        :: Any

    value     :: Any
end

type _individual
    n_genes  :: Int
    fitness  :: Float32
    obj_f    :: Float32
    genetic_code :: Array{_gene, 1}
end

type _population
    n_genes  :: Int
    size     :: Int
    mchance  :: Float32
    cchance  :: Float32
    individuals :: Array{_individual, 1}
    min_objf :: Float32
    max_objf :: Float32
    tourney_size :: Int
    kelitism :: Int
    max_iter :: Int
    Cfirst   :: Float32
    Clast    :: Float32
    Citer    :: Float32
    genGapfirst :: Float32
    genGaplast  :: Float32
    genGapiter  :: Float32
    crossover_function
    selection_function
    mutation_function
    objective_function
    fitness_function
end
