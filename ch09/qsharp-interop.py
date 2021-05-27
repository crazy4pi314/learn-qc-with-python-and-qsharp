#!/bin/env python
# -*- coding: utf-8 -*-
##
# qsharp-interop.py: Demo showing how Q# code can be run from a Python host.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

import qsharp

prepare_qubit = qsharp.compile("""          // <2>
    open Microsoft.Quantum.Diagnostics;     // <3>

    operation PrepareQubit(): Unit {        // <4>
        using (qubit = Qubit()) {
                DumpMachine();
        }
    }
    """)

if __name__ == "__main__":
    prepare_qubit.simulate()
