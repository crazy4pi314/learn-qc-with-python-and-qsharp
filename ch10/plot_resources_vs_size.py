import numpy as np
import matplotlib.pyplot as plt
import random
import qsharp
from GroverSearch import RunGroverSearch

if __name__ == "__main__":
    
    n_search_items = 2 ** np.arange(4, 25)
    depth = np.empty_like(n_search_items)

    for idx, searchsize in enumerate(n_search_items):
        estimate = RunGroverSearch.estimate_resources(
            nItems=int(searchsize), 
            idxMarkedItem=int(random.randint(0,searchsize-1))
        )
        depth[idx] = estimate['Depth']

    plt.plot(n_search_items, n_search_items, label='Classical')
    plt.plot(n_search_items, depth, label='Quantum', linestyle='--')
    plt.xlabel('# of Items')
    plt.ylabel('# of Steps')
    plt.legend()

    plt.show()
