#!/bin/env python
# -*- coding: utf-8 -*-
##
# teleport.py: Implements a quantum teleportation program using the simulator
#     in simulator.py with the interface defined in interface.py.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

from interface import QuantumDevice, Qubit
from simulator import Simulator

def teleport(msg: Qubit, here: Qubit, there: Qubit) -> None:
    here.h()
    here.cnot(there)

    # ...
    msg.cnot(here)
    msg.h()

    if msg.measure(): there.z()
    if here.measure(): there.x()

    msg.reset()
    here.reset()

if __name__ == "__main__":
    sim = Simulator(capacity=3)
    with sim.using_register(3) as (msg, here, there):
        msg.ry(0.123)
        teleport(msg, here, there)

        there.ry(-0.123)
        sim.dump()
