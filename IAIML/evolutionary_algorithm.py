from typing import Callable, List

import numpy as np


# Randomly swaps two coordinates from each parent to create a child
def crossover(parent1, parent2):
    coord = np.random.choice(len(parent1), 2, replace=False)
    child = parent1.copy()
    child[coord] = np.where(np.random.random() > 0.5, parent1[coord], parent2[coord])
    return child


# Selects the mu_percentage best parents using roulette wheel selection
def select_parents(population, mu_percentage=30):
    n = int(len(population) * mu_percentage / 100)  # Number of parents to select
    fitnesses_sum = np.sum(population[:, -1])

    # Probabilities proportional to the fitnesses
    probs = population[:, -1] / fitnesses_sum

    return population[np.random.choice(len(population), n, p=probs)]


# Evolutionary algorithm which optimizes n hyperparameters fed as a list of
# n-dimensional floating points (the search space)
def ea(
    points,
    fitness: Callable[[np.ndarray], float],
    population_size=100,
    mutation_probability=0.2,
    mu_percentage=60,
    iterations=100,
) -> List[float]:
    population = points[np.random.choice(len(points), population_size)]
    population = np.c_[population, [fitness(p) for p in population]]

    for _ in range(iterations):
        parents = select_parents(population, mu_percentage)

        for _ in parents:
            if np.random.random() < mutation_probability:
                # A mutation just consists in picking a random point from the search space
                mutant = points[np.random.randint(len(points))]

                np.append(population, np.append(mutant, fitness(mutant)))
            else:
                idxs = np.random.choice(len(parents), 2, replace=False)
                p1, p2 = parents[idxs[0]], parents[idxs[1]]

                # The last element is the fitness, which is not used in the crossover
                child = crossover(p1[:-1], p2[:-1])

                np.append(population, np.append(child, fitness(child)))

        # Survivor selection: the best population_size individuals are kept
        population = population[np.argsort(population[:, -1])][:population_size]

    return population[0]
