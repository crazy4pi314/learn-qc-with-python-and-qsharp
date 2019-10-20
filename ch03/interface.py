#!/bin/env python
# -*- coding: utf-8 -*-
##
# interface.py: Contains classes that define the interface to the qubit 
#     simulator in simulator.py.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

from abc import ABCMeta, abstractmethod
from contextlib import contextmanager

# tag::qubit_interface[]
class Qubit(metaclass=ABCMeta):
    @abstractmethod
    def h(self): pass

    @abstractmethod
    def x(self): pass                                                    # <1>

    @abstractmethod
    def measure(self) -> bool: pass

    @abstractmethod
    def reset(self): pass
# end::qubit_interface[]

# tag::device_interface[]
class QuantumDevice(metaclass=ABCMeta):
    @abstractmethod
    def allocate_qubit(self) -> Qubit:                                   # <1>
        pass

    @abstractmethod
    def deallocate_qubit(self, qubit: Qubit):                            # <2>
        pass

    @contextmanager
    def using_qubit(self):                                               # <3>
        qubit = self.allocate_qubit()
        try:
            yield qubit
        finally:
            qubit.reset()                                                # <4>
            self.deallocate_qubit(qubit)
# end::device_interface[]
