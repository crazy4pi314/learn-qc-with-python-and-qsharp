#!/bin/env python
# -*- coding: utf-8 -*-
##
# bb84.py: Defines and runs a simulation of the BB84 protocol for quantum key
#     distribution. Uses the single qubit simulator defined in simulator.py,
#     and the interface to the simulator defined in interface.py.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

from interface import QuantumDevice, Qubit
from simulator import SingleQubitSimulator
from typing import List

def sample_random_bit(device: QuantumDevice) -> bool:
    with device.using_qubit() as q:
        q.h()
        result = q.measure()
        q.reset()
    return result

def prepare_message_qubit(message: bool, basis: bool, q: Qubit) -> None:
    if message:
        q.x()
    if basis:
        q.h()

def measure_message_qubit(basis: bool, q: Qubit) -> bool:
    if basis:
        q.h()
    result = q.measure()
    q.reset()
    return result

def convert_to_hex(bits: List[bool]) -> str:
    return hex(int(
        "".join(["1" if bit else "0" for bit in bits]),
        2
    ))

def send_single_bit_with_bb84(
    your_device: QuantumDevice,
    eve_device: QuantumDevice
    ) -> tuple:

    [your_message, your_basis] = [
        sample_random_bit(your_device) for _ in range(2)
    ]

    eve_basis = sample_random_bit(eve_device)

    with your_device.using_qubit() as q:
        prepare_message_qubit(your_message, your_basis, q)

        # QUBIT SENDING...

        eve_result = measure_message_qubit(eve_basis, q)

    return ((your_message, your_basis), (eve_result, eve_basis))

def simulate_bb84(n_bits: int) -> tuple:
    your_device = SingleQubitSimulator()
    eve_device = SingleQubitSimulator()

    key = []
    n_rounds = 0

    while len(key) < n_bits:
        n_rounds += 1
        ((your_message, your_basis), (eve_result, eve_basis)) = \
            send_single_bit_with_bb84(your_device, eve_device)

        if your_basis == eve_basis:
            assert your_message == eve_result
            key.append(your_message)

    print(f"Took {n_rounds} rounds to generate a {n_bits}-bit key.")

    return key

def apply_one_time_pad(message: List[bool], key: List[bool]) -> List[bool]:
    return [
        message_bit ^ key_bit
        for (message_bit, key_bit) in zip(message, key)
    ]

if __name__ == "__main__":
    print("Generating a 96-bit key by simulating BB84...")
    key = simulate_bb84(96)
    print(f"Got key                           {convert_to_hex(key)}.")

    message = [
        1, 1, 0, 1, 1, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 0, 1,
        1, 1, 0, 1, 1, 1, 0, 0,
        1, 0, 0, 1, 0, 1, 1, 0,
        1, 1, 0, 1, 1, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 0, 1,
        1, 1, 0, 1, 1, 1, 0, 0,
        0, 0, 0, 0, 1, 1, 0, 1,
        1, 1, 0, 1, 1, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 0, 1,
        1, 1, 0, 1, 1, 1, 0, 0,
        1, 0, 1, 1, 1, 0, 1, 1
    ]
    print(f"Using key to send secret message: {convert_to_hex(message)}.")

    encrypted_message = apply_one_time_pad(message, key)
    print(f"Encrypted message:                {convert_to_hex(encrypted_message)}.")

    decrypted_message = apply_one_time_pad(encrypted_message, key)
    print(f"Eve decrypted to get:             {convert_to_hex(decrypted_message)}.")
    