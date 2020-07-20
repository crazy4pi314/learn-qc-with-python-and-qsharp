// Operation.qs: Sample code for a quantum random number generator (Chapter 6).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

namespace Qrng {
    open Microsoft.Quantum.Intrinsic;

    // tag::next-random[]

    operation NextRandomBit() : Result {                           // <1>
        using (qubit = Qubit()) {                                  // <2>
            H(qubit);                                              // <3>
            return M(qubit);                                       // <4>
        }
    }

    // end::next-random[]

    @EntryPoint()
    // tag::play-morganas[]

    operation PlayMorganasGame() : Unit {
        mutable nRounds = 0;                                       // <1>
        mutable done = false;
        repeat {                                                   // <2>
            set nRounds = nRounds + 1;
            set done = (NextRandomBit() == Zero);                  // <3>
        }
        until (done)                                               // <4>     
        fixup {}

        Message($"It took Lancelot {nRounds} turns to get home."); // <5>
    }

    // end::play-morganas[]

}
