namespace DeutschJozsa {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    // tag::is-oracle-balanced[]
    operation IsOracleBalanced(
            oracle : ((Qubit, Qubit) => Unit)              
    ) : Bool {
        mutable result = Zero;
        using ((control, target) = (Qubit(), Qubit())) {   // <1>
            H(control);                                    // <2>
            X(target);
            H(target);

            oracle(control, target);                       // <3>

            H(target);                                     // <4>
            X(target);

            set result = MResetX(control);                 // <5>
        }
        return result == One;
    }
    // end::is-oracle-balanced[]

    // tag::entry-point[]
    operation RunDeutschJozsaAlgorithm() : Unit {
        AssertBoolEqual(IsOracleBalanced(ZeroOracle), false, "Test failed for zero oracle."); // <1>
        AssertBoolEqual(IsOracleBalanced(OneOracle), false, "Test failed for one oracle.");   // <2>
        AssertBoolEqual(IsOracleBalanced(IdOracle), true, "Test failed for id oracle.");
        AssertBoolEqual(IsOracleBalanced(NotOracle), true, "Test failed for not oracle.");

        Message("All tests passed!");                                                         // <3>
    }
    // end::entry-point[]

}
