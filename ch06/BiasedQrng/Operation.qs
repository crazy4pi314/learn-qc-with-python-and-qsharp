namespace Qrng {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Math;

    // tag::main-body[]

    open Microsoft.Quantum.Canon;                                       // <1>

    operation PrepareBiasedCoin(winProbability : Double, qubit : Qubit) : Unit {
        let rotationAngle = 2.0 * ArcCos(Sqrt(1.0 - winProbability));   // <2>
        Ry(rotationAngle, qubit);
    }

    operation NextRandomBit(statePreparation : (Qubit => Unit)) : Result {
        mutable result = Zero;
        using (qubit = Qubit()) {
            statePreparation(qubit);                                    // <3>
            set result = MResetZ(qubit);                                // <4>
        }
        return result;
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
