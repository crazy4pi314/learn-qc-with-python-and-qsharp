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
from qutip.qip.operations import hadamard_transform
import numpy as np
from typing import List

KET_0 = qt.basis(2, 0)
H = hadamard_transform()

class SimulatedQubit(Qubit):
    qubit_id: int
    parent: "Simulator"

    def __init__(self, parent_simulator: "Simulator", id: int):
        self.qubit_id = id
        self.parent = parent_simulator

    def h(self) -> None:
        self.parent._apply(H, [self.qubit_id])

    def measure(self) -> bool:
        projectors = [
            qt.circuit.gate_expand_1toN(
                qt.basis(2, outcome) * qt.basis(2, outcome).dag(),
                self.parent.capacity,
                self.qubit_id
            )
            for outcome in (0, 1)
        ]
        post_measurement_states = [
            projector * self.parent.register_state
            for projector in projectors
        ]
        probabilities = [
            post_measurement_state.norm() ** 2
            for post_measurement_state in post_measurement_states
        ]
        sample = np.random.choice([0, 1], p=probabilities)
        self.parent.register_state = post_measurement_states[sample].unit()
        return int(sample)

    def reset(self) -> None:
        if self.measure(): self.x()

    def swap(self, target: Qubit) -> None:
        self.parent._apply(
            qt.swap(),
            [self.qubit_id, target.qubit_id]
        )

    def cnot(self, target: Qubit) -> None:
        self.parent._apply(
            qt.cnot(),
            [self.qubit_id, target.qubit_id]
        )

    def rx(self, theta: float) -> None:
        self.parent._apply(qt.rx(theta), [self.qubit_id])

    def ry(self, theta: float) -> None:
        self.parent._apply(qt.ry(theta), [self.qubit_id])

    def rz(self, theta: float) -> None:
        self.parent._apply(qt.rz(theta), [self.qubit_id])

    def x(self) -> None:
        self.parent._apply(qt.sigmax(), [self.qubit_id])

    def y(self) -> None:
        self.parent._apply(qt.sigmay(), [self.qubit_id])

    def z(self) -> None:
        self.parent._apply(qt.sigmaz(), [self.qubit_id])

class Simulator(QuantumDevice):
    capacity: int
    available_qubits: List[SimulatedQubit]
    register_state: qt.Qobj
    def __init__(self, capacity=3):
        self.capacity = capacity
        self.available_qubits = [
            SimulatedQubit(self, idx)
            for idx in range(capacity)
        ]
        self._sort_available()
        self.register_state = qt.tensor(
            *[
                qt.basis(2, 0)
                for _ in range(capacity)
            ]
        )
    def _sort_available(self) -> None:
        self.available_qubits = list(sorted(
            self.available_qubits,
            key=lambda qubit: qubit.qubit_id,
            reverse=True
        ))

    def allocate_qubit(self) -> SimulatedQubit:
        if self.available_qubits:
            return self.available_qubits.pop()

    def deallocate_qubit(self, qubit: SimulatedQubit):
        self.available_qubits.append(qubit)
        self._sort_available()

    def _apply(self, unitary: qt.Qobj, ids: List[int]):
        if len(ids) == 1:
            matrix = qt.circuit.gate_expand_1toN(unitary,
                                                 self.capacity, ids[0])
        elif len(ids) == 2:
            matrix = qt.circuit.gate_expand_2toN(unitary,
                                                 self.capacity, *ids)
        else:
            raise ValueError("Only one- or two-qubit unitary matrices supported.")

        self.register_state = matrix * self.register_state

    def dump(self) -> None:
        print(self.register_state)
