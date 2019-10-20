#!/bin/env python
# -*- coding: utf-8 -*-
##
# simulator.py: Defines a class that implements a single qubit simulator.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

from interface import QuantumDevice, Qubit
import numpy as np

# tag::constants[]
KET_0 = np.array([ 
    [1],
    [0]
], dtype=complex)                               # <1>
H = np.array([
    [1, 1],
    [1, -1]
], dtype=complex) / np.sqrt(2)                  # <2>
# end::constants[]

# tag::qubit[]
class SimulatedQubit(Qubit):
    def __init__(self):                         # <1>
        self.reset()

    def h(self):                                # <2>
        self.state = H @ self.state

    def measure(self) -> bool:                  
        pr0 = np.abs(self.state[0, 0]) ** 2     # <3>
        sample = np.random.random() <= pr0      # <4>
        return bool(0 if sample else 1)         # <5>

    def reset(self):
        self.state = KET_0.copy()
# end::qubit[]

class SingleQubitSimulator(QuantumDevice):
    available_qubits = [SimulatedQubit()]

    def allocate_qubit(self) -> SimulatedQubit:
        if self.available_qubits:
            return self.available_qubits.pop()

    def deallocate_qubit(self, qubit: SimulatedQubit):
        self.available_qubits.append(qubit)
