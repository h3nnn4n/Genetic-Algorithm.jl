#### Impact of mutation chance on solving 3cnf-sat

The instance _uf20-01.cnf_ from _uf20-91_ was used as a benchmark problem and for each mutation chance (mChance)
the problem was solved 500 times with a population of size 25 and a crossover chance of 95%. The mChance variable
went from 0.01 to 0.2 with an increment of 0.001. In total the same instance was solved 10000 times.


The following image has a plot with the mean of the iterations necessary to solve the problem 500 times for each mChance.
The data seems to be too noisy and no futher conclusion was draw.

![Iterations versus time](https://raw.githubusercontent.com/h3nnn4n/Genetic-Algorithm.jl/master/src/tests/mChance/out_iter.png)

