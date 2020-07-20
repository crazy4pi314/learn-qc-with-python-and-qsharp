#!/bin/env python
# -*- coding: utf-8 -*-
##
# simulator.py: Defines a class that implements a multi-qubit simulator.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

from interface import QuantumDevice, Qubit
import qutip as qt
import numpy as np
from typing import List

KET_0 = qt.basis(2, 0)
H = qt.hadamard_transform()

# tag::qubit_and_sq_operations[]

class SimulatedQubit(Qubit):
    qubit_id: int
    parent: "Simulator"

    def __init__(self, parent_simulator: "Simulator", id: int):          # <1>
        self.qubit_id = id
        self.parent = parent_simulator

    def h(self) -> None:
        self.parent._apply(H, [self.qubit_id])                           # <2>

    def ry(self, angle: float) -> None:
        self.parent._apply(qt.ry(angle), [self.qubit_id])                # <3>

    def x(self) -> None:
        self.parent._apply(qt.sigmax(), [self.qubit_id])

# end::qubit_and_sq_operations[]

# tag::measure_multiple[]
    def measure(self) -> bool:
        projectors = [                                                   # <1>
            qt.circuit.gate_expand_1toN(                                 # <2>
                qt.basis(2, outcome) * qt.basis(2, outcome).dag(),
                self.parent.capacity,
                self.qubit_id
            )
            for outcome in (0, 1)
        ]
        post_measurement_states = [
            projector * self.parent.register_state                       # <3>
            for projector in projectors
        ]
        probabilities = [                                                # <4>
            post_measurement_state.norm() ** 2
            for post_measurement_state in post_measurement_states
        ]
        sample = np.random.choice([0, 1], p=probabilities)               # <5>
        self.parent.register_state = post_measurement_states[sample].unit()   # <6>
        return bool(sample)

    def reset(self) -> None:                                             # <7>
        if self.measure(): self.x()

# end::measure_multiple[]

# tag::simulator_setup[]
class Simulator(QuantumDevice):                                          # <1>
    capacity: int                                                        # <2>
    available_qubits: List[SimulatedQubit]                               # <3>
    register_state: qt.Qobj                                              # <4>
    def __init__(self, capacity=3):         
        self.capacity = capacity         
        self.available_qubits = [                                        # <5>
            SimulatedQubit(self, idx)         
            for idx in range(capacity)         
        ]         
        self.register_state = qt.tensor(                                 # <6>
            *[         
                qt.basis(2, 0)         
                for _ in range(capacity)         
            ]         
        )         
    def allocate_qubit(self) -> SimulatedQubit:                          # <7>
        if self.available_qubits:
            return self.available_qubits.pop()

    def deallocate_qubit(self, qubit: SimulatedQubit):
        self.available_qubits.append(qubit)

# end::simulator_setup[]

# tag::apply_method[]

    def _apply(self, unitary: qt.Qobj, ids: List[int]):                  # <1>
        if len(ids) == 1:                                                # <2>
            matrix = qt.circuit.gate_expand_1toN(
                unitary, self.capacity, ids[0]
            )
        else:
            raise ValueError("Only single-qubit unitary matrices are supported.")
        
        self.register_state = matrix * self.register_state               # <3>

# end::apply_method[]
