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
        fixup {}

        Message($"It took Lancelot {nRounds} turns to get home.");
    }

    // end::main-body[]

}
