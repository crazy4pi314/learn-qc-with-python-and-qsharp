// Operation.qs: Sample code for a biased quantum random number generator
// (Chapter 6).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

namespace Qrng {
    open Microsoft.Quantum.Intrinsic;

    // tag::main-body[]

    open Microsoft.Quantum.Math;                                        // <1>
    open Microsoft.Quantum.Measurement;

    operation PrepareBiasedCoin(winProbability : Double, qubit : Qubit) : Unit {
        let rotationAngle = 2.0 * ArcCos(Sqrt(1.0 - winProbability));   // <2>
        Ry(rotationAngle, qubit);
    }

    operation NextRandomBit(statePreparation : (Qubit => Unit)) : Result {
        using (qubit = Qubit()) {
            statePreparation(qubit);                                    // <3>
            return MResetZ(qubit);                                      // <4>
        }
    }

    operation PlayMorganasGame(winProbability : Double) : Unit {
        mutable nRounds = 0;
        mutable done = false;
        let prep = PrepareBiasedCoin(winProbability, _);                // <5>
        repeat {
            set nRounds = nRounds + 1;
            set done = (NextRandomBit(prep) == Zero);
        }
        until (done)

        Message($"It took Lancelot {nRounds} turns to get home.");
    }

    // end::main-body[]

    @EntryPoint()
    operation RunPlayMorganasGame() : Unit {
        PlayMorganasGame(0.95);
    }

}
