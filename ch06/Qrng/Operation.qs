namespace Qrng {
    open Microsoft.Quantum.Intrinsic;

    // tag::next-random[]

    operation NextRandomBit() : Result {                           // <1>
        using (qubit = Qubit()) {                                  // <2>
            H(qubit);                                              // <3>
            let result = M(qubit);                                 // <4>
            Reset(qubit);                                          // <5>
            return result;                                         // <6>
        }
    }

    // end::next-random[]

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
