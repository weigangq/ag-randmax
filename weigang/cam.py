#!/usr/bin/env python
import numpy as np
import copy

class Population:
    def __init__(self, pop_size: int, target: str, in_stream: str, machine_size: int, rng_seed: object, mut: float) -> None:
        """
        Creates Population object. Contains machines, along with other information about the population.

        Args
            pop_size: int, default = 40.
                Number of machines in the population. 

            machine_size: int
                Number of states per individual

            rng_seed: {None, int, array_like[ints], SeedSequence, BitGenerator, Generator}, default = None.
                To generate reproducible results, specify a seed to initialize numpy.random.default_rng().
                By default, the rng results will be unpredictable.
        """
        if pop_size < 10:
            raise ValueError('The population size should be at least 10.')
        self.pop_size = (pop_size // 10) * 10

        # Generation counter that counts the number of times the population has undergone mutations.
        self.generation = 0
        self.machine_size = machine_size
        self.target = target
        self.in_stream = in_stream
        self.mut_rate = mut

        # Numpy rng
        self.rng = np.random.default_rng(seed=rng_seed)

        # Initialize a population of a single random amino acid sequence
        self.population = [ create_a_machine(self.machine_size, self.rng) for _ in range(pop_size)]
        
        # assign fitness
        for i in self.population:
            assign_fitness(i, target, in_stream)
        
        #print(len(self.population))

        # Elite list contains each generation's top 10 machines based on fitness, novelty, or a combination.
        # Will be updated during each selection function.
        # Format: list of 10 * [machine's index in population, Sequence string, Fitness]
        self.elite = get_elites(self.population)

        # The highest scoring machine of the generation based on fitness, novelty, or a combination.
        # Will be updated during each selection function.
        # Format: [machine's index in population, Sequence string, Fitness]
        self.elite1 = max(self.elite, key=lambda x: x[2])
        #self.avg_fit = round(np.mean([x[2] for x in self.elite]), 2)
        self.avg_fit = round(np.mean([ x['fit'] for x in self.population ]),4)

        # Archive contains sequences that were novel. Used during novelty and combo search.
        # self.archive = []

    def mutate(self) -> None:
        """
        Mutate a random number output or transition in a machine in the population.
        The number is chosen by a Poisson distribution where the expected value is the mutation rate.

        Args:
            mut_rate: float, default = 1.
                Average number of mutations for a sequence each generation.
        """
        # Increase generation counter.
        self.generation += 1
        # n_mut = 0
        # For each sequence in the population, mutate a random number of residues.
        # print("before mutation\t", [ x['fit'] for x in self.population ])       
        pop_copy = copy.deepcopy(self.population) ### don't use assignment!!!!
        self.population = [] # refresh not very efficient, but avoid reference error
        for n in range(self.pop_size):
            #print(n)
            # Get the number of sites to mutate a machine
            # num_mut = self.rng.poisson(mut_rate)
            machine = copy.deepcopy(pop_copy[n]) ### don't use assignment!!!!
            cut = self.rng.uniform()
            # print(f"{round(cut,2)}", end=":")
            # introduce a single mutation per machine
            if cut < self.mut_rate:
                # print("mut", end=";")
                # n_mut += 1
                # print(machine, end="\t")
                choice_action = self.rng.choice(['output', 'transition'])
                # mutate output of a chosen state, with replacement, so could be the same
                if choice_action == 'output':
                    choice_state = self.rng.choice(list(machine['states'].keys()))
                    choice_output = self.rng.choice(['0', '1'])
                    machine['states'][choice_state] = choice_output
                # choose & mutate a transition (rewiring), with replacement, could remain the same
                else:
                    choice_state = self.rng.choice(list(machine['states'].keys()))
                    choice_input = self.rng.choice(['0', '1'])
                    choice_dest = self.rng.choice(list(machine['states'].keys()))
                    machine['transitions'][choice_state][choice_input] = choice_dest
                assign_fitness(machine, self.target, self.in_stream)
                
            # else:
                # print("skip", end=";")
        # print()
                # print(machine)
            self.population.append(machine)
        # print("after mutation\t", [ x['fit'] for x in self.population ])
#       print([ x[2] for x in self.elite ])
        # print(f"gen={self.generation}\tnmut={n_mut}")
        return

    '''
    def replace_pop(self, method: str) -> None:
        """
        Replaces the current population of with a new population containing only the elite sequences.
        Takes each sequence in the elite and broadcasts it to be 1/10 of the population size.
        The elites are determined by the selection method (e.g., objective_selection) that calls this method.
        """
        if method == 'elite':
            elite_machines = [self.population[e[0]] for e in self.elite]
            # Clear population array.
            self.population = []
            # Broadcast elites to 10% of pop size, then append.
            for m in elite_machines:
                for _ in range(self.pop_size // 10):
                    self.population.append(m)
        return
    '''

    def elite_selection(self) -> None:
        """
        Selects the top 10 machines by fitness value, then replaces the population with the elites (fittest).
        """
        self.elite = get_elites(self.population)
        self.elite1 = max(self.elite, key=lambda x: x[2])
        #self.replace_pop('elite')

        elite_machines = [self.population[e[0]] for e in self.elite]
        # print("before elite\t", [ x['fit'] for x in self.population ])
        # Clear population array.
        self.population = []
        # Broadcast elites to 10% of pop size, then append.
        for m in elite_machines:
            for _ in range(self.pop_size // 10):
                self.population.append(m)
        self.avg_fit = round(np.mean([ x['fit'] for x in self.population ]),4)
        # self.avg_fit = [ x['fit'] for x in self.population ]
        # print("after elite\t", [ x['fit'] for x in self.population ])
        #print("elites", [ x[2] for x in self.elite ])
        #self.avg_fit = round(np.mean([x[2] for x in self.elite]),2)
        return

    def tour_selection(self) -> None:
        """
        Selects best of two, N times.
        """
        pop_before = copy.deepcopy(self.population)
        # print("before tour\t", [ x['fit'] for x in self.population ])
        self.population = []
        for i in range(self.pop_size):
            pairs = self.rng.choice(pop_before, size = 2)
            chosen = max(pairs, key=lambda x: x['fit'])
            self.population.append(chosen)

        self.elite = get_elites(self.population)
        self.elite1 = max(self.elite, key=lambda x: x[2])
        self.avg_fit = round(np.mean([ x['fit'] for x in self.population ]),4)
        # print("after tour\t", [ x['fit'] for x in self.population ])       
        # self.avg_fit = [ x['fit'] for x in self.population ]
        #print([ x['fit'] for x in self.population ])
        #print([ x[2] for x in self.elite ])
        #self.avg_fit = round(np.mean([x[2] for x in self.elite]),2)

        return


def create_a_machine(num_states: int, rng: object) -> dict:
    dict_states = {}
    # states with outputs:
    for i in range(num_states):
        dict_states['q'+str(i)] = rng.choice(['0', '1'])
        
    states = list(dict_states.keys())
    transitions = {}
    # build transitions
    for state in dict_states:
        transitions[state] = {'0': rng.choice(states),
                        '1': rng.choice(states)}
                        
    auto = {
        'states': dict_states,
        'transitions': transitions,
        'target': None,
        'input_stream': None,
        'fit': None,
        'output': None,
        'path': [] # for visualization by networkx
    }
    return auto

def assign_fitness(machine: dict, target: str, in_stream: str) -> None:
    """
    Get the fitness of a machine based on Hamming distance to target.

    Args:
        machine: an automata implemented as a dictionary

        target: target string

    Returns:
        Hamming distance
    """
    output = [machine['states']['q0']] # starting state & output
    last_state = 'q0'
    in_states = list(in_stream)
    target_sigs = list(target)
    # Hamming match as fitness
    num_match = 0
    # check first target digit:
    if target_sigs[0] == output[0]:
        num_match += 1

    edges = []
    step = 1
    for i in range(len(in_states)):
        input_sig = in_states[i]
        out_state = machine['transitions'][last_state][input_sig]
        out_sig = machine['states'][out_state]
        edges.append([last_state, out_state, "s_" + str(step) + ":" + input_sig + "->" + out_sig])
        output.append(out_sig)
        last_state = out_state
        step += 1
        if out_sig == list(target)[i+1]:
            num_match += 1
            
    machine['fit'] = num_match/len(target)
    machine['output'] = ''.join(output)
    machine['target'] = target
    machine['input_stream'] = in_stream
    machine['path'] = edges
    return


def get_elites(pop: list) -> list:
    """
    Used by a Population object to find the top 10 sequences of the population based on fitness/novelty/combo without
    having to sort the entire list of values.

    Args:
        pop: list
            Contains lists (representing amino acid sequences). Intended to be a list from a Population.population.

        population_metrics: list generated by population_fitness(), Population.population_novelty(), or
            Population.population_combo().
            This list contains only the fitness/novelty/combo scores of the sequences in the population.
            The scores have the same index in the list as the index of the corresponding sequence in the population.

    Returns:
        list of 10 * [machine's index in population, machine, Fitness]
    """
    # Temporary elite list containing [Sequence's population index, Metric]
    # Replace the smallest one, iteratively to get the top 10 highest.
    # Metric is either fitness, sparsity, or a weighted sum of the two.

    population_metrics = [ x['fit'] for x in pop ]
    elite = [[n, population_metrics[n]] for n in range(10)]
    elite_min = min(elite, key=lambda x: x[1])
    for index in range(10, len(pop)):
        if population_metrics[index] > elite_min[1]:
            elite.remove(elite_min)
            elite.append([index, population_metrics[index]])
            elite_min = min(elite, key=lambda x: x[1])

    elite_fitness = [ [e[0], pop[e[0]], e[1] ] for e in elite]
    return elite_fitness

