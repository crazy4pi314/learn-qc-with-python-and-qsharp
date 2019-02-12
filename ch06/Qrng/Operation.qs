namespace Qrng {
    open Microsoft.Quantum.Primitive;

    // tag::next-random[]

    operation NextRandomBit() : Result {                           // <1>
        mutable result = Zero;                                     // <2>
        using (qubit = Qubit()) {                                  // <3>
            H(qubit);                                              // <4>
            set result = M(qubit);                                 // <5>
            Reset(qubit);                                          // <6>
        }
        return result;                                             // <7>
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
