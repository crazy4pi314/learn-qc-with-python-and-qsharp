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

# tag::teleport[]
from interface import QuantumDevice, Qubit
from simulator import Simulator

def teleport(msg: Qubit, here: Qubit, there: Qubit) -> None:             # <1>
    here.h()                                                             # <2>
    here.cnot(there)                                                     # <3>

    # ...                                                                # <4>
    msg.cnot(here)                                                       # <5>
    msg.h()

    if msg.measure(): there.z()                                          # <6>
    if here.measure(): there.x()
    
    msg.reset()                                                          # <7>
    here.reset()

# end::teleport[]

# tag::main[]
if __name__ == "__main__":
    sim = Simulator(capacity=3)
    with sim.using_register(3) as (msg, here, there):           # <1>
        msg.ry(0.123)                                           # <2>
        teleport(msg, here, there)                              # <3>

        there.ry(-0.123)                                        # <4>
        sim.dump()                                                
# end::main[]
