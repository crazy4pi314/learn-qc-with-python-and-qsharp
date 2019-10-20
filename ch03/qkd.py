#!/bin/env python
# -*- coding: utf-8 -*-
##
# qkd.py: Defines functions needed to perform a basic quantum key exchange
#     protocol.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

from interface import QuantumDevice, Qubit
from simulator import SingleQubitSimulator

# tag::exchange_bits[]
def prepare_classical_message(bit: bool, q: Qubit) -> None:              # <1>
    if bit:
        q.x()                                                            # <2>
    
def eve_measure(q: Qubit) -> bool:
    return q.measure()                                                   # <3>

def send_classical_bit(device: QuantumDevice, bit: bool) -> None:
    with device.using_qubit() as q:
        prepare_classical_message(bit, q)
        result = eve_measure(q)
        q.reset()
    assert result == bit                                                 # <4>
# end::exchange_bits[]


# tag::qrng[]
def qrng(device: QuantumDevice) -> bool:
    with device.using_qubit() as q:
        q.h()
        return q.measure()
# end::qrng[]

# tag::exchange_bits_plusminus_basis[]
def prepare_classical_message_plusminus(bit: bool, q: Qubit) -> None:        
    if bit:
        q.x()   
    q.h()                   # <1>

def eve_measure_plusminus(q: Qubit) -> bool:                             
    q.h()                   # <2>
    return q.measure()

def send_classical_bit_plusminus(device: QuantumDevice, bit: bool) -> None:
    with device.using_qubit() as q:
        prepare_classical_message_plusminus(bit, q)
        result = eve_measure_plusminus(q)
        assert result == bit
# end::exchange_bits_plusminus_basis[]

# tag::exchange_bits_diff_basis[]
def prepare_classical_message(bit: bool, q: Qubit) -> None:              # <1>
    if bit:
        q.x()                                

def eve_measure_plusminus(q: Qubit) -> bool:                             
    q.h()                                                                # <2>
    return q.measure()

def send_classical_bit_wrong_basis(device: QuantumDevice, bit: bool) -> None:
    with device.using_qubit() as q:
        prepare_classical_message(bit, q)
        result = eve_measure_plusminus(q)
        assert result == bit, "Two parties do not have the same bit value"    # <3>
# end::exchange_bits_diff_basis[]
