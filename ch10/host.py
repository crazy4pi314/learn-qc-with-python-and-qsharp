#!/bin/env python
# -*- coding: utf-8 -*-
##
# host.py: Host program for the Hamiltonian simulation example (Chapter 9).
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

import qsharp
import HamiltonianSimulation as H2Simulation

bond_lengths = H2Simulation.H2BondLengths.simulate()

def estimate_energy(bond_index: float,
                    n_measurements_per_scale: int = 3
    ) -> float:
    print(f"Estimating energy for bond length of {bond_lengths[bond_index]} Å.")
    return min([H2Simulation.EstimateH2Energy.simulate(idxBondLength=bond_index)
                    for _ in range(n_measurements_per_scale)])

if __name__ == "__main__":
    import matplotlib.pyplot as plt

    print(f"Number of bond lengths: {len(bond_lengths)}.\n")
    energies = [estimate_energy(i) for i in range(len(bond_lengths))]
    plt.figure()
    plt.plot(bond_lengths, energies, 'o')
    plt.title('Energy levels of H₂ as a function of bond length')
    plt.xlabel('Bond length (Å)')
    plt.ylabel('Ground state energy (Hartree)')
    plt.show()
