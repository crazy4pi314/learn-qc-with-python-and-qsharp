namespace DeutschJozsa {
    open Microsoft.Quantum.Intrinsic;

    operation ZeroOracle(control : Qubit, target : Qubit) : Unit {
    }

    operation OneOracle(control : Qubit, target : Qubit) : Unit {
        X(target);
    }

    operation IdOracle(control : Qubit, target : Qubit) : Unit {
        CNOT(control, target);
    }

    operation NotOracle(control : Qubit, target : Qubit) : Unit {
        X(control);
        CNOT(control, target);
        X(control);
    }
}