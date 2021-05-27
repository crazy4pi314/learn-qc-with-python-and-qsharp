// Operation.qs: Sample code for a quantum random number generator (Chapter 7).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

namespace Qrng {
    open Microsoft.Quantum.Intrinsic;

    operation GetNextRandomBit() : Result {
        use qubit = Qubit();
        H(qubit);
        return M(qubit);
    }

    @EntryPoint()
    operation PlayMorganasGame() : Unit {
        mutable nRounds = 0;
        mutable done = false;
        repeat {
            set nRounds = nRounds + 1;
            set done =
                (GetNextRandomBit() == Zero);
        }
        until done;

        Message($"It took Lancelot {nRounds} turns to get home.");
    }

}
