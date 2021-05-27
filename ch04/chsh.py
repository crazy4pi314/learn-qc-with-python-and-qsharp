#!/bin/env python
# -*- coding: utf-8 -*-
##
# chsh.py: Implements the CHSH nonlocal game using the multi-qubit simulator
#     in simulator.py with the simulator interface defined in interface.py.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

#NOTE: This file is only part of the CHSH sample that will be developed over
# chapters 4 and 5. For the complete, finished example please see the code in
# the `ch05` directory.

import random
from functools import partial
from typing import Tuple, Callable
import numpy as np

from interface import QuantumDevice, Qubit
from simulator import Simulator

Strategy = Tuple[Callable[[int], int], Callable[[int], int]]

def random_bit() -> int:
    return random.randint(0, 1)

def referee(strategy: Callable[[], Strategy]) -> bool:
    you, eve = strategy()
    your_input, eve_input = random_bit(), random_bit()
    parity = 0 if you(your_input) == eve(eve_input) else 1
    return parity == (your_input and eve_input)

def est_win_probability(strategy: Callable[[], Strategy],
                        n_games: int = 1000) -> float:
    return sum(
        referee(strategy)
        for idx_game in range(n_games)
    ) / n_games

def constant_strategy() -> Strategy:
    return (
        lambda your_input: 0,
        lambda eve_input: 0
    )

import qutip as qt
def quantum_strategy(initial_state: qt.Qobj) -> Strategy:
    shared_system = Simulator(capacity=2)
    shared_system.register_state = initial_state
    your_qubit = shared_system.allocate_qubit()
    eve_qubit = shared_system.allocate_qubit()

    shared_system.register_state = qt.bell_state()
    your_angles = [90 * np.pi / 180, 0]
    eve_angles = [45 * np.pi / 180, 135 * np.pi / 180]

    def you(your_input: int) -> int:
        your_qubit.ry(your_angles[your_input])
        return your_qubit.measure()

    def eve(eve_input: int) -> int:
        eve_qubit.ry(eve_angles[eve_input])
        return eve_qubit.measure()

    return you, eve

if __name__ == "__main__":
    constant_pr = est_win_probability(constant_strategy, 100)
    print(f"Constant strategy won {constant_pr:0.1%} of the time.")

    initial_state = qt.Qobj([[1], [0], [0], [1]]) / np.sqrt(2)
    quantum_pr = est_win_probability(
                    partial(quantum_strategy, initial_state),
                    100
                )
    print(f"Quantum strategy won {quantum_pr:0.1%} of the time " \
          f"with initial state:\n{initial_state}.")
