import numpy as np
import matplotlib.pyplot as plt
import qsharp

if __name__ == "__main__":
    run_grover = qsharp.compile("""
        open GroverSearch;
        operation RunGroverSearchForNQubits(nQubits : Int) : Unit {
            let idxMarkedItem = 6;
            let markItem = ApplyOracle(idxMarkedItem, _, _);
            let foundItem = SearchList(nQubits, markItem);
        }
    """)

    n_qubitses = np.arange(4, 25)
    n_itemses = 2 ** n_qubitses
    depth = np.empty_like(n_itemses)

    for idx_n_qubits, n_qubits in enumerate(n_qubitses):
        estimate = run_grover.estimate_resources(nQubits=int(n_qubits))
        depth[idx_n_qubits] = estimate['Depth']

    plt.plot(n_itemses, n_itemses, label='Classical')
    plt.plot(n_itemses, depth, label='Quantum',linestyle='--')
    plt.xlabel('# of Items')
    plt.ylabel('# of Steps')
    plt.legend()

    plt.show()
