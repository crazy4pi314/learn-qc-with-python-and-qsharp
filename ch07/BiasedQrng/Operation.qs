// Operation.qs: Sample code for a biased quantum random number generator
// (Chapter 7).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

namespace Qrng {
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    operation PrepareBiasedCoin(winProbability : Double, qubit : Qubit)
    : Unit {
        let rotationAngle = 2.0 * ArcCos(
            Sqrt(1.0 - winProbability));
        Ry(rotationAngle, qubit);
    }

    operation GetNextRandomBit(statePreparation : (Qubit => Unit))
    : Result {
        use qubit = Qubit();
        statePreparation(qubit);
        return MResetZ(qubit);
    }

    operation PlayMorganasGame(winProbability : Double) : Unit {
        mutable nRounds = 0;
        mutable done = false;
        let prep = PrepareBiasedCoin(
            winProbability, _);
        repeat {
            set nRounds = nRounds + 1;
            set done = (GetNextRandomBit(prep) == Zero);
        }
        until done;

        Message($"It took Lancelot {nRounds} turns to get home.");
    }

    @EntryPoint()
    operation RunPlayMorganasGame() : Unit {
        PlayMorganasGame(0.95);
    }

}
